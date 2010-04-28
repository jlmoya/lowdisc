// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html


#ifndef _LOWDISC_SHARED_H_
#define _LOWDISC_SHARED_H_

// If this function is non-NULL, it is used to print messages out.
// It can be configure with the public function "lowdisc_msgsetfunction".
extern void (* lowdisc_messagefunction)(char * message);

// If this function is non-NULL, it is used to when an error is generated.
// It can be configure with the public function "lowdisc_errorsetfunction".
extern void (* lowdisc_errorfunction)(char * message);

LOWDISC_IMPORTEXPORT void lowdisc_message ( char * message );
LOWDISC_IMPORTEXPORT void lowdisc_message ( const string & str );
LOWDISC_IMPORTEXPORT void lowdisc_error ( char * message );
LOWDISC_IMPORTEXPORT void lowdisc_error ( const string & str );

//
//  35 bit integer routines.
//
LOWDISC_IMPORTEXPORT int i4_max ( int i1, int i2 );
LOWDISC_IMPORTEXPORT int i4_min ( int i1, int i2 );
LOWDISC_IMPORTEXPORT int i4_power ( int i, int j );
LOWDISC_IMPORTEXPORT int prime ( int n );
LOWDISC_IMPORTEXPORT int i4_bit_hi1 ( int n );
LOWDISC_IMPORTEXPORT int i4_bit_lo0 ( int n );
LOWDISC_IMPORTEXPORT int i4_uniform ( int b, int c, int *seed );
LOWDISC_IMPORTEXPORT unsigned int i4_xor ( unsigned int i, unsigned int j );
//
//  32 bit real routines.
//
LOWDISC_IMPORTEXPORT float r4_abs ( float x );
LOWDISC_IMPORTEXPORT int r4_nint ( float x );
LOWDISC_IMPORTEXPORT float r4_uniform_01 ( int *seed );
//
//  64 bit real routines.
//
LOWDISC_IMPORTEXPORT int r8_nint ( double x );
LOWDISC_IMPORTEXPORT double r8_uniform_01 ( int *seed );
LOWDISC_IMPORTEXPORT double r8_epsilon ( void );
LOWDISC_IMPORTEXPORT double r8_abs ( double x );
LOWDISC_IMPORTEXPORT double r8_max ( double x, double y );
LOWDISC_IMPORTEXPORT double r8_sign ( double x );

//
//  64 bit integer routines.
//
LOWDISC_IMPORTEXPORT int i8_bit_hi1 ( long long int n );
LOWDISC_IMPORTEXPORT int i8_bit_lo0 ( long long int n );
LOWDISC_IMPORTEXPORT long long int i8_uniform ( long long int b, long long int c, int *seed );
LOWDISC_IMPORTEXPORT unsigned long long int i8_xor ( unsigned long long int i, unsigned long long int j );
LOWDISC_IMPORTEXPORT long long int i8_max ( long long int i1, long long int i2 );
LOWDISC_IMPORTEXPORT long long int i8_min ( long long int i1, long long int i2 );
//
//  Utilities.
//
LOWDISC_IMPORTEXPORT void timestamp ( void );
LOWDISC_IMPORTEXPORT char *timestring ( void );

#endif /* _LOWDISC_SHARED_H_ */


