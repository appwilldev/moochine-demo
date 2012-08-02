

debug={
    on=true,
    to="response", -- "ngx.log"
}

config={
    templates="templates",
}

subapps={
    demo3 = {path="/path/to/another/moochineapp", config={}},
}


