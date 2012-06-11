#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

module("logger", package.seeall)

local JSON = require("cjson")

local table_insert = table.insert
local table_concat = table.concat

LOG_LEVEL='debug' -- debug, info, warning, error, critical

LEVELS = {
    ["critical"] = ngx.CRIT,
    ["error"]    = ngx.ERR,
    ["warning"]  = ngx.WARN,
    ["info"]     = ngx.NOTICE,
    ["debug"]    = ngx.INFO
}

function log_content(self, arguments)
    local log = nil
    
    if type(arguments)=='table' then
        local log_array = {}
        for _,arg in ipairs(arguments) do
            if type(arg)=='table' or arg==ngx.null then
                local r, v = pcall(JSON.encode, arg)
                if r then 
                    arg = v 
                else 
                    arg = '"ERR: Cannot serialise table"' 
                end
            end
            if type(arg) == 'boolean' then
                if arg then arg = 'true' else arg = 'false' end
            end
            table_insert(log_array, arg)
        end

        log = table_concat(log_array, " ")
    else
        log = arguments
    end

    return table_concat({"[logger]-->", log}, "")
end

function set_level(self, log_level)
    LOG_LEVEL = log_level
end

function output_log(self, log_level, args)
    if LEVELS[log_level]<=LEVELS[LOG_LEVEL] then
        local log = self:log_content(args)
        ngx.log(LEVELS[log_level], log)
    end
end

function d(self, ...)
    self:output_log('debug', {...})
end

function i(self, ...)
    self:output_log('info', {...})
end

function w(self, ...)
    self:output_log('warn', {...})
end

function e(self, ...)
    self:output_log('error', {...})
end

function c(self, ...)
    self:output_log('critical', {...})
end

local mt = {__index=logger}
return setmetatable({}, mt)

