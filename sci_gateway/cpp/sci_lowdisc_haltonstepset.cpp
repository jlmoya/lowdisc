
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
#include "halton.h" 


// _lowdisc_haltonstepset ( step )
//   Set the step of the Halton sequence.
// Arguments
//   step : a positive integer, the step
//     If step = 1, the usual Halton sequence.
//     If step = 2, the element #1, #3, #5, etc...
int sci_lowdisc_haltonstepset (char *fname) {
	int step;
	
	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &step );
	// Set the step
	halton_step_set ( step );
	return 0;
}
