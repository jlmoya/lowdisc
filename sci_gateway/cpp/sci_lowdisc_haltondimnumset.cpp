
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


// _lowdisc_haltondimnumset ( dim )
//   Set the dimension of the Halton sequence.
// Arguments
//   dim : a positive integer, the number of parameters
int sci_lowdisc_haltondimnumset (char *fname) {
	int dim;
	
	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	// Set the dimension
	halton_dim_num_set ( dim );
	return 0;
}
