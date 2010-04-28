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



// HALTON computes the next element in a leaped Halton subsequence.
void halton ( double r[] );

// HALTON_SEQUENCE computes N elements in an DIM_NUM-dimensional Halton sequence.
void halton_sequence ( int n, double r[] );

// HALTON_BASE_GET gets the base vector for a leaped Halton subsequence.
int *halton_base_get ( void );

// HALTON_BASE_SET sets the base vector for a leaped Halton subsequence.
void halton_base_set ( int base[] );

// HALTON_LEAP_GET gets the leap vector for a leaped Halton subsequence.
int *halton_leap_get ( void );

// HALTON_LEAP_SET sets the leap vector for a leaped Halton subsequence.
void halton_leap_set ( int leap[] );

// HALTON_DIM_NUM_GET gets the spatial dimension for a leaped Halton subsequence.
int halton_dim_num_get ( void );

// HALTON_DIM_NUM_SET sets the spatial dimension for a leaped Halton subsequence.
void halton_dim_num_set ( int dim_num );

// HALTON_SEED_GET gets the seed vector for a leaped Halton subsequence.
int *halton_seed_get ( void );

// HALTON_SEED_SET sets the seed vector for a leaped Halton subsequence.
void halton_seed_set ( int seed[] );

// HALTON_STEP_GET gets the step for the leaped Halton subsequence.
int halton_step_get ( void );

// HALTON_STEP_SET sets the step for a leaped Halton subsequence.
void halton_step_set ( int step );


__END_DECLS


#endif /* _LOWDISC_HALTON_D_H_ */

