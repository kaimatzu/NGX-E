#pragma once

#ifdef NGXE_PLATFORM_WINDOWS
    #ifdef NGXE_BUILD_DLL
        #define NGXE_API __declspec(dllexport)
    #else
        #define NGXE_API __declspec(dllimport)
    #endif
#else
    #error Windows support only for now!
#endif