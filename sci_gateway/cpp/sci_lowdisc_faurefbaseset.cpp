
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
#include "faure.h" 


// _lowdisc_faurefbaseset ( qs )
//   Set the prime number used by the Faure sequence.
// Aguments
//   qs : the new prime base
int sci_lowdisc_faurefbaseset (char *fname) {
	int qs;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &qs );
	faure_baseset ( qs );
	lowdisc_CreateLhsInteger ( 1 , qs );
	return 0;
}
