module("sphinxsearch", package.seeall)

_VERSION = '0.10'

local class = sphinxsearch
local mt = { __index = class }

local mysql = require("resty.mysql")

function new(self)
    local sphinx, err = mysql:new()
    if not sphinx then
        return nil, err
    end
    return setmetatable({ sphinx = sphinx }, mt)
end

function set_timeout(self, timeout)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:settimeout(timeout)
end

function connect(self, host, port)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end
    
    local params = {
        host = host,
        port = port,
        compact_arrays = true,
        max_packet_size = 1024 * 1024 
    }
    return sphinx:connect(params)
end

function set_keepalive(self, ...)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:setkeepalive(...)
end

function close(self)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:close()
end

function query(self, sql)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:query(sql)   
end

function send_query(self, sql)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:send_query(sql)   
end

function read_result(self)
    local sphinx = self.sphinx
    if not sphinx then
        return nil, "not initialized"
    end

    return sphinx:read_result()   
end

-- to prevent use of casual module global variables
getmetatable(class).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '"')
end

