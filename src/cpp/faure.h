// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

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

// faure_startup startup the sequence.
void faure_startup ( int dim_num , int basis );

// faure_shutdown shutdown the sequence.
void faure_shutdown ( );

// FAURE generates a new quasirandom Faure vector with each call.
void faure ( int dim_num, int *seed, double quasi[] );

// faure_baseget returns the base used by the Faure sequence (after startup and before first call).
int faure_baseget ( );


__END_DECLS

#endif /* _LOWDISC_FAURE_D_H_ */

