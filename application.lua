--
-- application configuration
--
-- var in this file can be got by "mch.util.get_config(key)"
--

debug={
    on=false,
    to="response", -- "ngx.log"
}

logger = {
    file = "moochine_demo.log",
    level = "DEBUG",
}

config={
    templates="templates",
}

subapps={
    -- subapp_name = {path="/path/to/another/moochineapp", config={}},
}


