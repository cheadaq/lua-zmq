--
-- Premake script (http://premake.github.io)
--

solution 'luazmq'
    configurations {'Debug', 'Release'}
    targetdir 'bin'

    filter 'configurations:Debug'
        defines     'DEBUG'
        symbols     'On'

    filter 'configurations:Release'
        defines     'NDEBUG'
        symbols     'On'
        optimize    'On'

     filter 'action:vs*'
        defines
        {
            'WIN32',
            '_WIN32_WINNT=0x0600',
            '_CRT_SECURE_NO_WARNINGS',
            'NOMINMAX',
            'inline=__inline',
        }

    filter 'system:windows'
        defines 'LUA_BUILD_AS_DLL'

    filter 'system:linux'
        defines 'LUA_USE_LINUX'

    project 'lua53'
        targetname  'lua53'
        language    'C'
        kind        'SharedLib'
        location    'build'

        includedirs 'deps/lua/src'
        files
        {
            'deps/lua/src/*.h',
            'deps/lua/src/*.c',
        }
        removefiles
        {
            'deps/lua/src/lua.c',
            'deps/lua/src/luac.c',
        }

    project 'luazmq'
        targetname  'luazmq'
        language    'C'
        kind        'SharedLib'
        location    'build'

        defines     'LUA_LIB'
        includedirs
        {
            'deps/lua/src',
            'deps/zmq/include'
        }
        files       'src/*.c'
        links       'lua53'

        filter 'system:linux'
            links  {'m', 'zmq', 'sodium'}

        filter 'system:windows'
            libdirs 'deps/zmq/lib'
            links  {'libzmq'}

