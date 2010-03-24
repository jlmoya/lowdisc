
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

// _lowdisc_haltonseedset ( dim , seed )
//   Set the seed of the Halton sequence.
// Arguments
//   dim : the number of variables
//   seed : a row matrix of positive integers
int sci_lowdisc_haltonseedset (char *fname) {
	int * seed = NULL;
	int nRows, nCols;
	double * valueVector = NULL;
	int dim;
	
	CheckRhs(2,2) ;
	CheckLhs(1,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	lowdisc_AssertVarType ( fname , 2 , sci_matrix );
	GetRhsVarMatrixDouble ( 2 , &nRows, &nCols, &valueVector);
	lowdisc_AssertNumberOfRows ( fname , 2 , 1 , nRows );
	lowdisc_AssertNumberOfColumns ( fname , 2 , dim , nCols );
	// Transfer the double array into an array of integers
	seed = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		lowdisc_Double2IntegerArgument ( fname , 1 , valueVector[k] , seed+k );
	}
	// Set the seed
	halton_seed_set ( seed );
	// Free the seed
	free_ivector ( seed );
	return 0;
}
