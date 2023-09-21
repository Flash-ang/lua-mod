-- Copyright (C) TC Ang (flash_ang)
# lua-mod
* lua module, use under nginx

# mod_logfile2
lua write log into file.

- example log file : 

20230816 18:13:15.688 : app start 



# mod_sess
lua server session.

features :

* add message / debug info into custom log file.
* set http header cookie.
* save session variables into file.
* load session variables from file.
* get session from cookie
* random generate session "LUA_SESSION_ID" and add into cookie if does not exists.
* set session from query string.

requirement :

* set in nginx config "lua_shared_dict runningNumber 10m;"

todo :
1. set header & cookie for LUA_SESSION_ID (new or existing). [Done]
2. from LUA_SESSION_ID get variables from file. [Done]
3. show session variables. [Done]

NOTE : SET HEADER FIRST BEFORE OUTPUT TO USER !!!

Bug Fixed : 
* Fixed query string "?SESSION" value is true. will regenerate session.
* Fixed query string "?SESSION=" value is empty space. will regenerate session.
* Fixed non-alphanumeric session_id. will regenerate session.
* Update Set session_id to UPPER case for compatible with windows file system.
