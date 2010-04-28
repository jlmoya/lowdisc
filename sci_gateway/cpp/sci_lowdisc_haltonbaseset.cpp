
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

// _lowdisc_haltonbaseset ( base )
//   Set the basis of the Halton sequence.
// Arguments
//   base : a matrix of positive integers, the basis
//     This is usually a matrix of the first dim primes.
int sci_lowdisc_haltonbaseset (char *fname) {
	int nRows, nCols;
	double * valueVector = NULL;
	int * base = NULL;
	int dim;

	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	lowdisc_AssertVarType(fname , 1 , sci_matrix );
	GetRhsVarMatrixDouble ( 1 , &nRows, &nCols, &valueVector);
	lowdisc_AssertNumberOfRows ( fname , 1 , 1 , nRows );
	dim = nCols;
	lowdisc_AssertNumberOfColumns ( fname , 1 , dim , nCols );
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
