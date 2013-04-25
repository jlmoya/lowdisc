// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_H_
#define _LOWDISC_H_

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

// lowdisc_errorsetfunction --
//   Configure the error function.
LOWDISC_IMPORTEXPORT void lowdisc_errorsetfunction ( void (* f)(char * message) );

// lowdisc_msgsetfunction --
//   Configure the message function
LOWDISC_IMPORTEXPORT void lowdisc_msgsetfunction ( void (* f)(char * message));

//    PRIME_GE returns the smallest prime greater than or equal to N.
//
//  Examples:
//
//    N     PRIME_GE
//
//    -10    2
//      1    2
//      2    2
//      3    3
//      4    5
//      5    5
//      6    7
//      7    7
//      8   11
//      9   11
//     10   11
//
//  Modified:
//
//    09 March 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number to be bounded.
//
//    Output, int PRIME_GE, the smallest prime number that is greater
//    than or equal to N.  However, if N is larger than the
//    largest prime stored, then PRIME_GE is returned as -1.
//
LOWDISC_IMPORTEXPORT int lowdisc_prime_ge ( int n );

__END_DECLS

#endif /* _LOWDISC_H_ */


