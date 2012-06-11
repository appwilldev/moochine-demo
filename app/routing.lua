#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : ldmiao
--

require 'mch.router'
mch.router.setup('MoochineWeb')

---------------------------------------------------------------------

map('^/hello%?name=(.*)',           'test.hello')

---------------------------------------------------------------------

