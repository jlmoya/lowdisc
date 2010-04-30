// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_SOBOL_D_H_
#define _LOWDISC_SOBOL_D_H_

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

//
//  32 bit integer routines.
//

// i4_sobol_start  : Startup the Sobol sequence.
void i4_sobol_start ( int dim_num );

// i4_sobol_stop : Stop the Sobol sequence.
void i4_sobol_stop ( );

//    I4_SOBOL generates a new quasirandom Sobol vector with each call.
//    This routine is able to generate 2^30 - 1  = 1 073 741 823 experiments
//    in dimension 1111.
void i4_sobol ( int *seed, float quasi[ ] );

// i4_sobol_dimget : Returns the dimension.
int i4_sobol_dimget ( );

__END_DECLS

#endif /* _LOWDISC_SOBOL_D_H_ */

