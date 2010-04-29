// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_REVERSEHALTON_D_H_
#define _LOWDISC_REVERSEHALTON_D_H_

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

// reversehalton computes the next element in a reverse Halton sequence.
void reversehalton ( int iter, double next[] );

// reversehalton_baseset sets the base vector for a reverse Halton sequence.
void reversehalton_baseset ( int newbase[] );

// reversehalton_baseset sets the base vector for a reverse Halton sequence.
void reversehalton_baseget ( int * base );

// reversehalton_dimget gets the spatial dimension for a reverse Halton sequence.
int reversehalton_dimget ( void );

// reversehalton_dimset sets the spatial dimension for a reverse Halton sequence.
void reversehalton_dimset ( int dim_num );


__END_DECLS


#endif /* _LOWDISC_REVERSEHALTON_D_H_ */