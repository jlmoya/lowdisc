#include <wchar.h>
#include "liblowdiscgateway.hxx"
extern "C"
{
#include "liblowdiscgateway.h"
#include "addfunction.h"
}

#define MODULE_NAME L"liblowdiscgateway"

int liblowdiscgateway(wchar_t* _pwstFuncName)
{
    if(wcscmp(_pwstFuncName, L"_lowdisc_startup") == 0){ addCStackFunction(L"_lowdisc_startup", &sci_lowdisc_startup, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_shutdown") == 0){ addCStackFunction(L"_lowdisc_shutdown", &sci_lowdisc_shutdown, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_sobolfnext") == 0){ addCStackFunction(L"_lowdisc_sobolfnext", &sci_lowdisc_sobolfnext, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_sobolfnew") == 0){ addCStackFunction(L"_lowdisc_sobolfnew", &sci_lowdisc_sobolfnew, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_sobolfdestroy") == 0){ addCStackFunction(L"_lowdisc_sobolfdestroy", &sci_lowdisc_sobolfdestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_sobolftokens") == 0){ addCStackFunction(L"_lowdisc_sobolftokens", &sci_lowdisc_sobolftokens, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_haltonfnext") == 0){ addCStackFunction(L"_lowdisc_haltonfnext", &sci_lowdisc_haltonfnext, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_haltonfnew") == 0){ addCStackFunction(L"_lowdisc_haltonfnew", &sci_lowdisc_haltonfnew, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_haltonfdestroy") == 0){ addCStackFunction(L"_lowdisc_haltonfdestroy", &sci_lowdisc_haltonfdestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_haltonftokens") == 0){ addCStackFunction(L"_lowdisc_haltonftokens", &sci_lowdisc_haltonftokens, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_faurefnext") == 0){ addCStackFunction(L"_lowdisc_faurefnext", &sci_lowdisc_faurefnext, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_faurefnew") == 0){ addCStackFunction(L"_lowdisc_faurefnew", &sci_lowdisc_faurefnew, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_faurefdestroy") == 0){ addCStackFunction(L"_lowdisc_faurefdestroy", &sci_lowdisc_faurefdestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_faureftokens") == 0){ addCStackFunction(L"_lowdisc_faureftokens", &sci_lowdisc_faureftokens, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_niedfnext") == 0){ addCStackFunction(L"_lowdisc_niedfnext", &sci_lowdisc_niedfnext, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_niedfnew") == 0){ addCStackFunction(L"_lowdisc_niedfnew", &sci_lowdisc_niedfnew, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_niedfdestroy") == 0){ addCStackFunction(L"_lowdisc_niedfdestroy", &sci_lowdisc_niedfdestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_niedftokens") == 0){ addCStackFunction(L"_lowdisc_niedftokens", &sci_lowdisc_niedftokens, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_ssobolnext") == 0){ addCStackFunction(L"_lowdisc_ssobolnext", &sci_lowdisc_ssobolnext, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_ssobolnew") == 0){ addCStackFunction(L"_lowdisc_ssobolnew", &sci_lowdisc_ssobolnew, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_ssoboldestroy") == 0){ addCStackFunction(L"_lowdisc_ssoboldestroy", &sci_lowdisc_ssoboldestroy, MODULE_NAME); }
    if(wcscmp(_pwstFuncName, L"_lowdisc_ssoboltokens") == 0){ addCStackFunction(L"_lowdisc_ssoboltokens", &sci_lowdisc_ssoboltokens, MODULE_NAME); }

    return 1;
}
