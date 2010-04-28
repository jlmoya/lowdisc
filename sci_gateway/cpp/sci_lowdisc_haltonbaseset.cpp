
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
#include "halton.h" 

// _lowdisc_haltonbaseset ( dim , base )
//   Set the basis of the Halton sequence.
// Arguments
//   dim : the number of variables
//   base : a matrix of positive integers, the basis
//     This is usually a matrix of the first dim primes.
int sci_lowdisc_haltonbaseset (char *fname) {
	int nRows, nCols;
	double * valueVector = NULL;
	int * base = NULL;
	int dim;

	CheckRhs(2,2) ;
	CheckLhs(1,1) ;
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	lowdisc_AssertVarType(fname , 2 , sci_matrix );
	GetRhsVarMatrixDouble ( 2 , &nRows, &nCols, &valueVector);
	lowdisc_AssertNumberOfRows ( fname , 2 , 1 , nRows );
	lowdisc_AssertNumberOfColumns ( fname , 2 , dim , nCols );
	// Transfer the double array into an array of integers
	base = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		lowdisc_Double2IntegerArgument ( fname , 1 , valueVector[k] , base+k );
	}
	// Set the base
	halton_base_set ( base );
	// Free the base
	free_ivector ( base );
	return 0;
}
