// 2009 - DIGITEO - Michael Baudin
#ifndef _LOWDISC_NIEDER_D_H_
#define _LOWDISC_NIEDER_D_H_

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

void calcc ( void );
void calcv ( int px[], int b[], int v[], int v_max );
void golo ( double quasi[] );
int i4_characteristic ( int q );
int i4_max ( int i1, int i2 );
int i4_min ( int i1, int i2 );
int i4_power ( int i, int j );
void inlo ( int dim, int base, int skip );
void niederreiter ( int dim_num, int base, int *seed, double r[] );
void niederreiter_generate ( int dim_num, int n, int base, int *seed, 
  double r[] );
void niederreiter_write ( int dim_num, int n, int base, int skip, double r[], 
  char *output_filename );
int *plymul ( int pa[], int pb[] );
double r8_epsilon ( void );
void setfld ( int q );
void timestamp ( void );
char *timestring ( void );

__END_DECLS


#endif /* _LOWDISC_NIEDER_D_H_ */

