// 2009 - INRIA - Michael Baudin
#ifndef _LOWDISC_BLAS1_D_H_
#define _LOWDISC_BLAS1_D_H_

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

LOWDISC_IMPORTEXPORT double dasum ( int n, double x[], int incx );
LOWDISC_IMPORTEXPORT void daxpy ( int n, double da, double dx[], int incx, double dy[], int incy );
LOWDISC_IMPORTEXPORT void dcopy ( int n, double dx[], int incx, double dy[], int incy );
LOWDISC_IMPORTEXPORT double ddot ( int n, double dx[], int incx, double dy[], int incy );
LOWDISC_IMPORTEXPORT double dmach ( int job );
LOWDISC_IMPORTEXPORT double dnrm2 ( int n, double x[], int incx );
LOWDISC_IMPORTEXPORT void drot ( int n, double x[], int incx, double y[], int incy, double c, double s );
LOWDISC_IMPORTEXPORT void drotg ( double *sa, double *sb, double *c, double *s );
LOWDISC_IMPORTEXPORT void dscal ( int n, double sa, double x[], int incx );
LOWDISC_IMPORTEXPORT void dswap ( int n, double x[], int incx, double y[], int incy );
LOWDISC_IMPORTEXPORT int idamax ( int n, double dx[], int incx );
LOWDISC_IMPORTEXPORT bool lsame ( char ca, char cb );
LOWDISC_IMPORTEXPORT void xerbla ( char *srname, int info );

__END_DECLS

#endif /* _LOWDISC_BLAS1_D_H_ */


