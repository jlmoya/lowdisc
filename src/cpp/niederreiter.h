// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

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

// Starts the sequence
void niederreiter_start ( int dim_num, int base, int skip );

// Stop the sequence
void niederreiter_stop ( );

//    NIEDERREITER returns an element of a Niederreiter sequence for base BASE.
void niederreiter ( double r[] );

// Returns the number of dimensions in the sequence
int niederreiter_dim_num_get ( );

// Returns the base of the sequence
int niederreiter_base_get ( );

// Returns the skip of the sequence
int niederreiter_skip_get ( );

// Returns true if the sequence is started up
bool niederreiter_isstart ( );

__END_DECLS


#endif /* _LOWDISC_NIEDER_D_H_ */

