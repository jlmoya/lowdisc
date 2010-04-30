
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
#include "sobol_i4.h"


// _lowdisc_sobolfstart ( dim )
//   Start the Sobol sequence.
int sci_lowdisc_sobolfstart (char *fname) {
	int dim;

	CheckRhs(1,1);
	CheckLhs(0,1);
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	i4_sobol_start ( dim );
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
