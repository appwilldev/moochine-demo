#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

module("awutils", package.seeall)

local JSON          = require("cjson")
local Redis         = require("resty.redis")
local Bit           = require("bit")

local table_insert  = table.insert
local table_concat  = table.concat
local table_remove  = table.remove

local string_find   = string.find
local string_sub    = string.sub
local string_len    = string.len
local string_lower  = string.lower
local string_gsub   = string.gsub
local string_upper  = string.upper
local string_format = string.format
local string_match  = string.match

local math_min      = math.min
local math_floor    = math.floor

local band          = Bit.band
local brshift       = Bit.rshift

local null          = ngx.null
local tcp           = ngx.socket.tcp

-- ////////////////////////////////////////////////////////////////////////////////
-- Request

function get_one_uri_arg(arg)
    if type(arg)=='table' then
        if #arg>=1 then
            arg = arg[1]
        else
            arg = ''
        end
    end
    
    if type(arg)~='string' then arg='' end

    return arg
end

-- ////////////////////////////////////////////////////////////////////////////////
-- Int

function int(value, default)
    local int_value = default
    
    local value_type = type(value)
    if value_type=='number' then
        int_value = value
    elseif value_type=='string' then
        int_value = tonumber(value)
        if not int_value then int_value = default end
    end

    return int_value
end

function basen(n, b)
    if not b or b==10 then 
        return tostring(n) 
    end

    if b<=1 then return nil end
    
    local digits = "0123456789abcdefghijklmnopqrstuvwxyz"
    
    local t = {}
    
    local sign = nil
    if n < 0 then
        sign = "-"
        n = -n
    end

    n = math_floor(n)
    repeat
        local d = (n % b) + 1
        n = math_floor(n / b)
        table_insert(t, 1, digits:sub(d,d))
    until n == 0
    
    if sign then 
        return sign .. table_concat(t) 
    end
    
    return table_concat(t)
end

function base10to36(i)
    if type(i)=='string' then i=tonumber(i) end
    -- if type(i)~='number' then return nil end
    return basen(i, 36)
end

function base36to10(s)
    return tonumber(s, 36)
end

-- ////////////////////////////////////////////////////////////////////////////////
-- String

function trim(s)
    local from = s:match"^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end

function string_index(str, substr) 
    local order_by_index = string_find(str, substr, 1, true) 
    return order_by_index 
end

function string_rindex(str, substr) 
    return string_match(str, '.*()'..substr) 
end

function string_startswith(str, substr)
    return string_index(str, substr)==1
end

function string_endswith(str, substr)
    return string_rindex(str, substr)==(string_len(str)-string_len(substr)+1)
end

function dirpath(str)
    local last_slash_index = string_rindex(str, "/")
    if last_slash_index then
        return string_sub(str, 1, last_slash_index-1)
    end
    return nil
end

-- ////////////////////////////////////////////////////////////////////////////////
-- Table

function table_index(t, value)
    if type(t) ~= 'table' then return nil end
    for i,v in ipairs(t) do
        if v==value then
            return i
        end
    end

    return nil
end

function table_sub(t, s, e)
    local t_count = #t

    if s<0 then 
        s = t_count + s + 1 
    end
    
    if e<0 then 
        e = t_count + e + 1 
    end
    
    if s<=0 or s>t_count or e<=0 then 
        return nil 
    end

    e = math_min(t_count, e)

    local new_t = {}
    for i=s,e,1 do
        table_insert(new_t, t[i])
    end

    return new_t
end

function table_extend(t, t1)
    for _,v in ipairs(t1) do
        table_insert(t, v)
    end
    return t
end

function table_merge(t1, t2)
    local new_t = {}
    for i,v in ipairs(t1) do
        table_insert(new_t, v)
    end
    for i,v in ipairs(t2) do
        table_insert(new_t, v)
    end
    return new_t
end

function table_update(t1, t2)
    for k,v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

function table_rm_value(t, value)
    local idx = table_index(t, value)
    if idx then
        table_remove(t, idx)
    end
    return idx
end

function table_contains_value(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

function table_contains_key(t, element)
    return t[element]~=nil
end

function table_count(t, value)
    local count = 0
    for _,v in ipairs(t) do
        if v==value then
            count = count + 1
        end
    end
    return count
end

function table_real_length(t)
    local count = 0
    for k,v in pairs(t) do
        count = count + 1
    end
    return count
end

function table_empty(t)
    if not t then return true end
    if type(t)=='table' and #t<=0 then return true end
    return false
end

function table_unique(t)
    local n_t1 = {}
    local n_t2 = {}
    for k,v in ipairs(t) do
        if n_t1[v] == nil then
            n_t1[v] = v
            table.insert(n_t2, v)
        end
    end
    return n_t2
end

function table_excepted(t1, t2)
    local ret = {}
    for _,v1 in ipairs(t1) do
        local finded = false
        for _,v2 in ipairs(t2) do
            if type(v2) == type(v1) and v1==v2 then
                finded = true
                break
            end
        end
        if not finded then
            table.insert(ret,v1)
        end
    end
    return ret
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- ////////////////////////////////////////////////////////////////////////////////
-- Redis

local redis_host = '127.0.0.1'
local redis_port = 9900
local redis_pool_size = 100

function redis_client()
    local client = Redis:new()
    if not client then
        return nil
    end

    client:set_timeout(2000) -- 2 seconds
    local ok, err = client:connect(redis_host, redis_port)
    if not ok then
        return nil
    end
    
    return client
end

function redis_get(key, expire)
    local redis_client = redis_client()
    if redis_client then
        local ret = redis_client:get(key)
        if expire and expire>0 then redis_client:expire(key, expire) end
        redis_client:set_keepalive(0, redis_pool_size)
        return ret
    end
    return nil
end

function redis_set(key, value, expire)
    local redis_client = redis_client()
    if redis_client then
        local ret = redis_client:set(key, value)
        if expire and expire>0 then redis_client:expire(key, expire) end
        redis_client:set_keepalive(0, redis_pool_size)
        return ret
    end
    return nil
end

function redis_lpush(key, value)
    local redis_client = redis_client()
    if redis_client then
        local ret = redis_client:lpush(key, value)
        redis_client:set_keepalive(0, redis_pool_size)
        return ret
    end
    return nil
end

-- ////////////////////////////////////////////////////////////////////////////////
-- URL Fetch

local default_headers = {
    ["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.79 Safari/535.11",
    ["Accept"]     = "*/*",
    ["Pragma"]     = "no-cache",
    -- ["Accept-Language"] = "en",
    ["mt"]         = nil
}

function form_request(host, uri, headers)
    local output_t = {
        "GET ", uri, " HTTP/1.0\r\n",
        "HOST: ", host, "\r\n"
    }

    local t = {}
    for k,v in pairs(default_headers) do
        t[k] = v    
    end
   
    if type(headers)=='table' then
        for k,v in pairs(headers) do
            t[k] = v
        end
    end

    for k,v in pairs(t) do
        table_insert(output_t, k)
        table_insert(output_t, ": ")
        table_insert(output_t, v)
        table_insert(output_t, "\r\n")
    end
    table_insert(output_t, "\r\n")

    return table_concat(output_t)
end

function url_fetch(url, method, post_args, to_json, headers)
    local sock = tcp()
    sock:settimeout(30000) -- timeout 30 seconds

    local host, uri = string.match(url, "http%://(.-)(/.*)")
    local ok, err = sock:connect(host, 80)
    if not ok then return nil end

    local req = form_request(host, uri, headers)
    sock:send(req)
    
    local read_headers = sock:receiveuntil("\r\n\r\n")
    headers, err = read_headers()
    if not headers then return nil end

    local content = sock:receive("*a")
    if content then
        if to_json==true then
            return JSON.decode(content)
        end
        return content
    end

    return nil 
end

-- ////////////////////////////////////////////////////////////////////////////////
-- MySQL


-- ////////////////////////////////////////////////////////////////////////////////
-- Others

function map(func, t)
    local new_t = {}
    for i,v in ipairs(t) do
        table_insert(new_t, func(v, i))
    end
    return new_t
end

function timestamp()
    return ngx.time()
end

function isNull(v)
    return (v==nil or v==ngx.null)
end

function isNotNull(v)
    return not isNull(v)
end

function isNotEmptyString(...)
    local args = {...}
    local v = nil
    for i=1,table.maxn(args) do
        v = args[i]
        if v==nil or v==ngx.null or type(v)~='string' or string.len(v)==0 then
            return false
        end
    end
    return true
end

function traceback()
    logger:e(require("debug").traceback())
end

function _strify(o, tab, act, logged)
    local v=tostring(o)
    if logged[o] then return v end
    if string.sub(v,0,6) == "table:" then
        logged[o]=true
        act = "\n" .. string.rep("|    ",tab) .. "{ [".. tostring(o) .. ", "
        act = act .. table_real_length(o) .." item(s)]"
        for k,v in pairs(o) do
            act =  act .."\n" .. string.rep("|    ",tab)
            act =  act .. "|   *".. k .. "\t=>\t" .. _strify(v,tab+1,act, logged)
        end
        act= act .. "\n"..string.rep("|    ",tab) .."}"
        return act
    else
        return v
    end
end

function strify(o) return _strify(o,1,"",{}) end

function table_print(t)
    local s1="\n* Table String:"
    local s2="\n* End Table"
    logger:e(s1 .. strify(t) .. s2)
end

