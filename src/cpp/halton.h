// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

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

// halton_start starts the sequence
void halton_start ( int dim_num , int base[] , int seed[] , int leap[] );

// halton_stop stops the sequence
void halton_stop ( );

// HALTON computes the next element in a leaped Halton subsequence.
void halton ( int step , double r[] );

// HALTON_DIM_NUM_GET gets the spatial dimension for a leaped Halton subsequence.
int halton_dim_num_get ( void );

// HALTON_BASE_GET gets the base vector for a leaped Halton subsequence.
void halton_base_get ( int base[] );

// HALTON_LEAP_GET gets the leap vector for a leaped Halton subsequence.
void halton_leap_get ( int leap[] );

// HALTON_SEED_GET gets the seed vector for a leaped Halton subsequence.
void halton_seed_get ( int seed[] );

// HALTON_STEP_GET gets the step for the leaped Halton subsequence.
int halton_step_get ( void );

// halton_isstart : Returns true if the sequence is already started up;
bool halton_isstart ( );

__END_DECLS


#endif /* _LOWDISC_HALTON_D_H_ */

