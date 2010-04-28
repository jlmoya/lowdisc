// 2009 - DIGITEO - Michael Baudin
#ifndef _LOWDISC_HALTON_D_H_
#define _LOWDISC_HALTON_D_H_

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



void halton ( double r[] );
int *halton_base_get ( void );
void halton_base_set ( int base[] );
int *halton_leap_get ( void );
void halton_leap_set ( int leap[] );
int halton_dim_num_get ( void );
void halton_dim_num_set ( int dim_num );
int *halton_seed_get ( void );
void halton_seed_set ( int seed[] );
void halton_sequence ( int n, double r[] );
int halton_step_get ( void );
void halton_step_set ( int step );


__END_DECLS


#endif /* _LOWDISC_HALTON_D_H_ */

