--
-- application configuration
--
-- var in this file can be got by "mch.util.get_config(key)"
--

debug={
    on=true,
    to="response", -- "ngx.log"
}

config={
    templates="templates",
}

subapps={
    -- subapp_name = {path="/path/to/another/moochineapp", config={}},
}


