
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin

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

// base = _lowdisc_niedfbaseget (  )
//   Get the basis of the Niederreiter sequence.
// Arguments
//   base : a 1 x 1 matrix of floating point integer
int sci_lowdisc_niedfbaseget (char *fname) {
	int base;
	//
	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	//
	base = niederreiter_base_get ( );
	//
	lowdisc_CreateLhsInteger ( 1 , base );
	return 0;
}
