#pragma once

#ifdef NGEX_PLATFORM_WINDOWS
    #ifdef NGEX_BUILD_DLL
        #define NGEX_API __declspec(dllexport)
    #else
        #define NGEX_API __declspec(dllimport)
    #endif
#else
    // #error Windows support only for now!
#endif