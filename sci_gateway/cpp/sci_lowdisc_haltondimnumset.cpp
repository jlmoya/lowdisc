
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
#include "halton.h" 


// _lowdisc_haltondimnumset ( dim )
//   Set the dimension of the Halton sequence.
// Arguments
//   dim : a positive integer, the number of parameters
int sci_lowdisc_haltondimnumset (char *fname) {
	int dim;
        int ierr;
	
	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	// Set the dimension
	halton_dim_num_set ( dim );
	return 0;
}
