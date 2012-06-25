# 一、安装配置

## 1.1 OpenResty 安装
参看：http://openresty.org/#Installation

## 1.2 Moochine 安装
    #Checkout Moochine 代码
    git clone git://github.com/appwilldev/moochine.git 
    

## 1.3 配置环境变量
    #设置OpenResty环境变量
    export OPENRESTY_HOME=/usr/local/openresty
    
    #设置Moochine环境变量
    export MOOCHINE_HOME=/path/to/moochine
    
    #使环境变量生效
    source ~/.bashrc
    
    #将以上三个环境变量 加到 ~/.bashrc 或者~/.profile 里，下次登陆自动生效
    vim ~/.bashrc
    

# 二、示例(模版)程序
## 2.1 Checkout 示例代码
    git clone git://github.com/appwilldev/moochine-demo.git
    cd moochine-demo
    
## 2.2 程序目录结构
    
    moochine-demo #程序根目录
    |
    |-- app #应用目录
    |   |-- routing.lua #URL Routing配置
    |   |-- test.lua #请求处理函数
    |   `-- logger.lua  #调试日志打印
    |
    |-- bin #脚本目录
    |   |-- debug.sh #关闭服务->清空error log->启动服务->查看error log
    |   |-- reload.sh #平滑重载配置
    |   |-- start.sh #启动
    |   `-- stop.sh #关闭
    |
    |-- conf  #配置目录
    |    `-- nginx.conf  #Nginx配置文件模版
    |
    |-- templates  #ltp模版目录
    |    `-- ltp.html  #ltp模版文件
    |
    `-- nginx_runtime #Nginx运行时 目录。这个目录下的文件由程序自动生成，无需手动管理。
        |-- conf
        |   `-- p-nginx.conf #Nginx配置文件(自动生成)，执行 ./bin/start.sh 时会根据conf/nginx.conf 自动生成。
        `-- logs #Nginx运行时日志目录
            |-- access.log #Nginx 访问日志
            |-- error.log #Nginx 错误日志
            `-- nginx.pid #Nginx进程ID文件
    

## 2.3 启动/关闭/重载/重启 方法
    ./bin/start.sh #启动
    ./bin/stop.sh #停止
    ./bin/reload.sh #平滑重载配置
    ./bin/debug.sh #关闭服务->清空error log->启动服务->查看error log

注意：以上命令只能在程序根目录执行，类似 `./bin/xxx.sh` 的方式。    

## 2.4 测试
    curl "http://localhost:9800/hello?name=xxxxxxxx"
    curl "http://localhost:9800/ltp"
    tail -f nginx_runtime/logs/access.log  #查看 Nginx 访问日志的输出
    tail -f nginx_runtime/logs/error.log  #查看 Nginx 错误日志和调试日志 的输出
    

# 三、开发Web应用
## 3.1 URL Routing: app/routing.lua
    #!/usr/bin/env lua
    -- -*- lua -*-
    -- copyright: 2012 Appwill Inc.
    -- author : ldmiao
    --
    
    require 'mch.router'
    mch.router.setup('moochine-demo') --moochine-demo 必须和`程序根目录名` 保持一致
    
    ---------------------------------------------------------------------
    
    map('^/hello%?name=(.*)',           'test.hello')
    
    ---------------------------------------------------------------------
    

## 3.2 请求处理函数：app/test.lua
请求处理函数接收2个参数，request和response，分别对应HTTP的request和response。从request对象拿到客户端发送过来的数据，通过response对象返回数据。

    #!/usr/bin/env lua
    -- -*- lua -*-
    -- copyright: 2012 Appwill Inc.
    -- author : ldmiao
    --
    
    module("test", package.seeall)
    
    local JSON = require("cjson")
    local Redis = require("resty.redis")
    
    function hello(req, resp, name)
        if req.method=='GET' then
            -- resp:writeln('Host: ' .. req.host)
            -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
            -- resp:writeln('name, ' .. req.uri_args['name'])
            resp.headers['Content-Type'] = 'application/json'
            resp:writeln(JSON.encode(req.uri_args))

            resp:writeln({{'a','c',{'d','e', {'f','b'})
        elseif req.method=='POST' then
            -- resp:writeln('POST to Host: ' .. req.host)
            req:read_body()
            resp.headers['Content-Type'] = 'application/json'
            resp:writeln(JSON.encode(req.post_args))
        end 
    end

## 3.3 request对象的属性和方法
以下属性值的详细解释，可以通过 http://wiki.nginx.org/HttpLuaModule 和 http://wiki.nginx.org/HttpCoreModule 查找到。

    --属性
    method=ngx.var.request_method
    schema=ngx.var.schema
    host=ngx.var.host
    hostname=ngx.var.hostname
    uri=ngx.var.request_uri
    path=ngx.var.uri
    filename=ngx.var.request_filename
    query_string=ngx.var.query_string
    headers=ngx.req.get_headers()
    user_agent=ngx.var.http_user_agent
    remote_addr=ngx.var.remote_addr
    remote_port=ngx.var.remote_port
    remote_user=ngx.var.remote_user
    remote_passwd=ngx.var.remote_passwd
    content_type=ngx.var.content_type
    content_length=ngx.var.content_length
    uri_args=ngx.req.get_uri_args()
    post_args=ngx.req.get_post_args()
    socket=ngx.req.socket
    
    --方法
    request:read_body()
    request:get_cookie(key, decrypt)
    request:rewrite(uri, jump)
    request:set_uri_args(args)
    

## 3.4 response对象的属性和方法
    --属性
    headers=ngx.header
    
    --方法
    response:write(content)
    response:writeln(content)
    response:redirect(url, status)
    response:set_cookie(key, value, encrypt, duration, path)
    response:ltp(template,data)
    

## 3.5 打印调试日志
    local logger = require("logger“)
    logger:e(info)

查看调试日志

    tail -f nginx_runtime/logs/error.log  #查看 Nginx 错误日志和调试日志 的输出
    

# 四、参考 
1. http://wiki.nginx.org/HttpLuaModule 
1. http://wiki.nginx.org/HttpCoreModule 
1. http://openresty.org
1. https://github.com/appwilldev/moochine
