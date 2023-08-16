-- Copyright (C) TC Ang (flash_ang)

# mod_sess
lua server session.

features :

* add message / debug info into custom log file.
* set http header cookie.
* save session variables into file.
* load session variables from file.
* get settings from cookie, random generate cookie "LUA_SESSION_ID" if does not exists.
* set session from query string.

requirement :

* set in nginx config "lua_shared_dict runningNumber 10m;"

todo :
1. set header & cookie for LUA_SESSION_ID (new or existing). [Done]
2. from LUA_SESSION_ID get variables from file. [Done]
3. show session variables. [Done]

NOTE : SET HEADER FIRST BEFORE OUTPUT TO USER !!!

Bug Fixed : 
Fixed query string "?SESSION" value is true. will regenerate session.
Fixed query string "?SESSION=" value is empty space. will regenerate session.
Fixed non-alphanumeric session_id. will regenerate session.
Update Set session_id to UPPER case for compatible with windows file system.
