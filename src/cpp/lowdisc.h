// 2009 - INRIA - Michael Baudin
#ifndef _LOWDISC_H_
#define _LOWDISC_H_

#ifdef _MSC_VER
	#if LIBLOWDISC_EXPORTS 
		#define LOWDISC_IMPORTEXPORT __declspec (dllexport)
	#else
		#define LOWDISC_IMPORTEXPORT __declspec (dllimport)
	#endif
#else
	#define LOWDISC_IMPORTEXPORT
#endif

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

__BEGIN_DECLS

// lowdisc_errorsetfunction --
//   Configure the error function.
LOWDISC_IMPORTEXPORT void lowdisc_errorsetfunction ( void (* f)(char * message) );

// lowdisc_msgsetfunction --
//   Configure the message function
LOWDISC_IMPORTEXPORT void lowdisc_msgsetfunction ( void (* f)(char * message));


__END_DECLS

#endif /* _LOWDISC_H_ */


