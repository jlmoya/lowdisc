// Copyright (C) 2006-2009 - CEA - Jean-Marc Martinez
// Copyright (C) 2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_MATH_H_
#define _LOWDISC_MATH_H_

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

int * ivector(int n);
int ** imatrix(int l, int c);
void free_ivector(int * v);
void free_imatrix(int ** mat, int l);

double **dmatrix(int,int);
double *dvector(int);
void free_dmatrix(double **,int);
void free_dvector(double *);

__END_DECLS

#endif /* _LOWDISC_MATH_H_ */

