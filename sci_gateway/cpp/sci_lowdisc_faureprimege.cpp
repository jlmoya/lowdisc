
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
#include "faure.h" 


// qs = _lowdisc_faureprimege ( dim )
//   Returns the prime number used by the Faure sequence.
// Aguments
//   dim : the number of variables
int sci_lowdisc_faureprimege (char *fname) {
	int dim;
	int qs;

	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	// Call the Faure sequence
	qs = prime_ge ( dim );
	// Returns qs
	lowdisc_CreateLhsInteger ( 1 , qs );
	return 0;
}
