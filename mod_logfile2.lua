--[[
-- Copyright (C) TC Ang (flash_ang)

# mod_logfile2
lua write log into file.

Reference : 
strftime(3): format date/time - Linux man page
https://linux.die.net/man/3/strftime

--]]

local _M = {}

local gettime -- get system time.
-- local socket = require 'socket'
local io = io -- file open / write.
local os = os -- os.date
local filename = './file1.log';

local function req()
    -- gettime = require 'socket'.gettime()
    gettime = require 'socket'.gettime
end

if pcall( req ) then
    -- cli
    -- print("require socket Success")
else
    -- nginx
    -- ngx.say("require socket Failure")
    if ngx ~= nil then
        gettime = ngx.time
    end
end


function _M.AddLog( txt )
    if txt == nil then return false end -- skip if no parameter.

    -- local ms = socket.gettime()
    local ms = gettime()
    local t = os.date('%Y%m%d %H:%M:%S', ms) .. string.sub(ms%1, 2, 5 ) .. ' : ';
    -- print( t ) -- 20221024 17:19:45.393

    -- a : Open or Create (if not exists), Write ONLY, write from the end.
    -- a+ : Open or Create (if not exists), Read from the start, write from the end.
    local f = io.open( filename, 'a+' )
    if( f==nil ) then
        print( 'Error to open log file [' .. filename ..']' )
        return false
    end

    io.output( f )
    io.write( t )
    io.write( txt )
    io.write('\n' )
    io.flush();
    io.close()

    ms = nil
    t = nil
    f = nil
    return true
end

function _M.init( fullFilePath )
    filename = fullFilePath
end

return _M

--[[
-- Test : 

f = io.open( 'testfile', 'a' )
io.output( f )
io.write( 'this is a test \n line 2 \n' )
io.close()

f = io.open( 'testfile', 'a+' )
io.output( f )

print( 'f:seek() current position : ', f:seek() )
print( 'f:read(1) read 1 char : ', f:read(1) )
print( 'f:seek() current position : ', f:seek() )
print( 'f:read() read 1 line : ', f:read() )
print( 'f:seek() current position : ', f:seek() )
print( 'f:lines() read lines : ', f:lines() )

for line in f:lines() do
    print( 'line', line )
end

print( 'f:seek("set", 0) starting of the file : ', f:seek( 'set', 0 ) )
print( 'f:read()', f:read() ) -- !!! This will affect write !!!
io.write( 'line 3 \n' ); -- will not write to file as no close.
print( 'f:read()', f:read() )
print( 'f:seek("set", 0) starting of the file : ', f:seek( 'set', 0 ) )
print( 'f:read()', f:read() )
print( 'f:read()', f:read() )
print( 'f:read()', f:read() )

!!! f:read will affect write !!!
-- f:seek( "set", 0 ) -- move write position to the end of the file.



-- output : ---------- 

f:seek() current position :     0
f:read(1) read 1 char :         t
f:seek() current position :     1
f:read() read 1 line :  his is a test
f:seek() current position :     17
f:lines() read lines :  function: 0042EC80
line     line 2
f:seek("set", 0) starting of the file :         0
f:read()        this is a test
f:read()        nil
f:seek("set", 0) starting of the file :         0
f:read()        this is a test
f:read()         line 2
f:read()        nil

---------- ---------- ---------- ---------- ---------- ---------- 

how to use :

l = require 'mod_logfile2'
l.AddLog( 'test' )

l.init( 'new file.log' )
l.AddLog( 'test2' )



----------
Windows : 

if no permissions on current folder **
** e.g. (limited user)
> cd "C:\Program Files"
> lua

x = dofile( 'c:/Apache24-x86/htdocs/mod_logfile2.lua')
x.AddLog( 'test3' )

C:\Users\**current user name**\AppData\Local\VirtualStore\Program Files>

These can be removed. 

The Virtual Store is where Vista compliant programs typically store files that 
need global write/access permissions such as data, .ini, and configuration files. 
This is part of the Virtualization model in Vista. 



----------
* Debian :
* if user have on permission, will error.

/usr/local/openresty/nginx/html

library : 
/usr/lib/x86_64-linux-gnu/lua#

root@debiansg:/usr/bin# whereis lua
lua: 
/usr/bin/lua 
/usr/bin/lua5.1 
/usr/bin/lua5.3 
/usr/lib/x86_64-linux-gnu/lua 
/usr/local/bin/lua 
/usr/local/lib/lua 
/usr/share/lua 
/usr/share/man/man1/lua.1.gz

root@debiansg:/usr/bin#


package.cpath ="/usr/lib/x86_64-linux-gnu/lua/5.2/?.so;" .. package.cpath
package.path = "/usr/share/lua/5.2/?.lua;" .. package.path


Using bash on Linux, you can set the paths by adding these lines to the end of ~/.bashrc file. For example:

## final ;; ensure that default path will be appended by Lua
##export LUA_PATH="<path-to-add>;;"
## export LUA_CPATH="./?.so;/usr/local/lib/lua/5.3/?.so;/usr/local/share/lua/5.3/?.so;<path-to-add>"
export LUA_PATH="/usr/share/lua/5.3/?.lua;;"
export LUA_CPATH="./?.so;/usr/local/lib/lua/5.3/?.so;/usr/local/share/lua/5.3/?.so;/usr/lib/x86_64-linux-gnu/lua/5.3/?.so"

Lua 5.3.5  Copyright (C) 1994-2018 Lua.org, PUC-Rio

> print( package.path)
/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua

> print( package.cpath)
/usr/local/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so


/usr/share/lua/5.3/socket.lua 
/usr/lib/x86_64-linux-gnu/lua/5.3/socket/*.so


]]--
