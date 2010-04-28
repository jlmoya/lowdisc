
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


// quasi = _lowdisc_reversehaltonf ( )
//   Get the next element of the reverse Halton sequence.
int sci_lowdisc_reversehaltonf (char *fname) {
	int seedint;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	return 0;
}
