
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
#include "halton.h" 

// leap = _lowdisc_haltonfleapget (  )
//   Get the leap of the Halton sequence.
// Arguments
int sci_lowdisc_haltonfleapget (char *fname) {
	int nRows, nCols;
	double * leap = NULL;
	int * ileap = NULL;
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	// Get the dimension
	dim = halton_dim_num_get ( );
	// Create an integer array to store the leap.
	ileap = ivector ( dim );
	// Get the integer leap
	halton_leap_get ( ileap );
	// Create a Scilab variable
	nRows=1;
	nCols=dim;
	lowdisc_CreateLhsMatrix(1, nRows, nCols, &leap);
	// Copy the integer values into doubles
	for(int k = 0; k < dim; k++) {
		leap[k] = ileap[k];
	}
	// Free the leap
	free_ivector ( ileap );

	return 0;
}
