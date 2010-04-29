
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
#include "reversehalton.h" 


// dim = _lowdisc_revhaltfdimget ( )
//   Returns dimension of the reverse Halton sequence.
int sci_lowdisc_revhaltfdimget (char *fname) {
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(1,1) ;

	dim = reversehalton_dimget ( );
	lowdisc_CreateLhsInteger ( 1 , dim );
	return 0;
}
