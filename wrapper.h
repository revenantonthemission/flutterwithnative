#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

//#1
#ifdef __cplusplus
extern "C" {
#endif
    FFI_PLUGIN_EXPORT void* create_A();
    FFI_PLUGIN_EXPORT void release_A(void*);
    FFI_PLUGIN_EXPORT void set_Value(void*, int);
    FFI_PLUGIN_EXPORT int get_Value(void*);
    FFI_PLUGIN_EXPORT int refCount(void*);
#ifdef __cplusplus
}
#endif

//#2
#ifdef __cplusplus
extern "C" {
#endif  
    FFI_PLUGIN_EXPORT void* create_A_Container();
    FFI_PLUGIN_EXPORT void release_A_Container(void*);
    FFI_PLUGIN_EXPORT void storePtr(void*, void*);
    FFI_PLUGIN_EXPORT void* getPtr(void*, int);
#ifdef __cplusplus
}
#endif
