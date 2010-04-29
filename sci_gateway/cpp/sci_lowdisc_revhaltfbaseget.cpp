
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
#include "lowdisc_math.h" 


// base = _lowdisc_revhaltfbaseget ( )
//   Returns the base of the reverse Halton sequence.
int sci_lowdisc_revhaltfbaseget (char *fname) {
	int nRows, nCols;
	double * base = NULL;
	int * ibase = NULL;
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(1,1) ;

	// Get the dimension
	dim = reversehalton_dimget ( );
	// Create an integer array to store the base.
	ibase = ivector ( dim );
	// Get the integer base
	reversehalton_baseget ( ibase );
	// Create a Scilab variable
	nRows=1;
	nCols=dim;
	lowdisc_CreateLhsMatrix(1, nRows, nCols, &base);
	// Copy the integer values into doubles
	for(int k = 0; k < dim; k++) {
		base[k] = ibase[k];
	}
	// Free the base
	free_ivector ( ibase );

	return 0;
}
