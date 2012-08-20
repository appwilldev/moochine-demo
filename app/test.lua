#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

module("test", package.seeall)

local JSON = require("cjson")
local Redis = require("resty.redis")

local logger = require("logger")

function hello(req, resp, name)
    logger:e("hello request started!")
    if req.method=='GET' then
        -- resp:writeln('Host: ' .. req.host)
        -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
        -- resp:writeln('name, ' .. req.uri_args['name'])
        resp.headers['Content-Type'] = 'application/json'
        resp:writeln(JSON.encode(req.uri_args))

        resp:writeln({{'a','c',{'d','e', {'f'}}},'b'})
    elseif req.method=='POST' then
        -- resp:writeln('POST to Host: ' .. req.host)
        req:read_body()
        resp.headers['Content-Type'] = 'application/json'
        resp:writeln(JSON.encode(req.post_args))
    end
    logger:e("hello request completed!")
end

function longtext(req, resp)
    resp:writeln(string.rep("x", 1000000))
    resp:writeln("end!")
    resp:finish()
    resp:writeln("yyyyyyyy!")
    
    local red = Redis:new()
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        resp:writeln({"failed to connect: ", err})
    end
    
    for i=1,1000 do
        local k = "foo"..tostring(i)
        red:set(k, "bar"..tostring(i))
        local v = red:get(k)
        ngx.log(ngx.ERR, "i:"..tostring(i), ", v:", v)
        
        ngx.sleep(1)
    end
end

function ltp(req, resp)
    resp:ltp("ltp.html", {v="hello, moochine!"})
end

