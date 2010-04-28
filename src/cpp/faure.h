// 2009 - DIGITEO - Michael Baudin
#ifndef _LOWDISC_FAURE_D_H_
#define _LOWDISC_FAURE_D_H_

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

void faure ( int dim_num, int *seed, double quasi[] );

__END_DECLS

#endif /* _LOWDISC_FAURE_D_H_ */

