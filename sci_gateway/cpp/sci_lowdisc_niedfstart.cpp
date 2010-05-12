
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin

extern "C" {
#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "niederreiter.h" 


// _lowdisc_niedfstart ( dim , base , skip )
//   Start the Niederreiter sequence.
// Parameters
//   dim : 1 x 1 matrix of doubles, the number of dimensions (e.g. 1)
//   base : 1 x 1 matrix of doubles, the base (e.g. 2). The base should be a prime, or a power of a prime.
//   skip : 1 x 1 matrix of doubles, the number of elements to skip (e.g. 0). 
//
int sci_lowdisc_niedfstart (char *fname) {
	int dim;
	int base;
	int skip;
	int ierr;
	
	CheckRhs(3,3) ;
	CheckLhs(0,1) ;
	//
	// Get dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get base
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &base );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get skip
	ierr = lowdisc_GetOneIntegerArgument ( fname , 3 , &skip );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Start the Halton sequence
	niederreiter_start ( dim, base, skip );
	//
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
