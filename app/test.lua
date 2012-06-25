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

