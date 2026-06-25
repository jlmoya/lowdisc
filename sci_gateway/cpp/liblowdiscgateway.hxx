#ifndef __LIBLOWDISCGATEWAY_GW_HXX__
#define __LIBLOWDISCGATEWAY_GW_HXX__

#ifdef _MSC_VER
#ifdef LIBLOWDISCGATEWAY_GW_EXPORTS
#define LIBLOWDISCGATEWAY_GW_IMPEXP __declspec(dllexport)
#else
#define LIBLOWDISCGATEWAY_GW_IMPEXP __declspec(dllimport)
#endif
#else
#define LIBLOWDISCGATEWAY_GW_IMPEXP
#endif

extern "C" LIBLOWDISCGATEWAY_GW_IMPEXP int liblowdiscgateway(wchar_t* _pwstFuncName);



#endif /* __LIBLOWDISCGATEWAY_GW_HXX__ */
