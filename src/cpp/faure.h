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

int *binomial_table ( int qs, int m, int n );
void faure ( int dim_num, int *seed, double quasi[] );
int i4_log_i4 ( int i4, int j4 );
int i4_min ( int i1, int i2 );
int i4_power ( int i, int j );
int prime ( int n );
int prime_ge ( int n );
void timestamp ( void );

__END_DECLS

#endif /* _LOWDISC_FAURE_D_H_ */

