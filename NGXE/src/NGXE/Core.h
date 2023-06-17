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

#define BIT(X) (1 << X)


#ifdef NGXE_ENABLE_ASSERTS
	#define NGXE_ASSERT(x, ...) { if(!(x)) { NGXE_ERROR("Assertion Failed: {0}", __VA_ARGS__); __debugbreak(); } }
	#define NGXE_CORE_ASSERT(x, ...) { if(!(x)) { NGXE_CORE_ERROR("Assertion Failed: {0}", __VA_ARGS__); __debugbreak(); } }
#else
	#define NGXE_ASSERT(x, ...)
	#define NGXE_CORE_ASSERT(x, ...)
#endif