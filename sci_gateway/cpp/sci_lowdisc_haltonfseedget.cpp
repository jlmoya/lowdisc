
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

// seed = _lowdisc_haltonfseedget (  )
//   Get the seed of the Halton sequence.
// Arguments
int sci_lowdisc_haltonfseedget (char *fname) {
	int nRows, nCols;
	double * seed = NULL;
	int * iseed = NULL;
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	// Get the dimension
	dim = halton_dim_num_get ( );
	// Create an integer array to store the seed.
	iseed = ivector ( dim );
	// Get the integer seed
	halton_seed_get ( iseed );
	// Create a Scilab variable
	nRows=1;
	nCols=dim;
	lowdisc_CreateLhsMatrix(1, nRows, nCols, &seed);
	// Copy the integer values into doubles
	for(int k = 0; k < dim; k++) {
		seed[k] = iseed[k];
	}
	// Free the seed
	free_ivector ( iseed );

	return 0;
}
