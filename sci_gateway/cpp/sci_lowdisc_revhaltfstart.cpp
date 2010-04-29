
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


// _lowdisc_revhaltfstart ( dim , base )
//   Startup the Reverse Halton sequence.
// Parameters
//   dim: the dimension of the sequence
//   base: array of size dim, the base of the sequence
//
int sci_lowdisc_revhaltfstart (char *fname) {
	int nRows, nCols;
	double * valueVector = NULL;
	int * base = NULL;
	int dim;
	int ierr;

	CheckRhs(2,2) ;
	CheckLhs(1,1) ;
	// Get dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	// Get base
	ierr = lowdisc_AssertVariableType(fname , 2 , sci_matrix );
	if ( ierr==0 ) {
		return 0;
	}
	GetRhsVarMatrixDouble ( 2 , &nRows, &nCols, &valueVector);
	ierr = lowdisc_AssertNumberOfRows ( fname , 2 , 1 , nRows );
	if ( ierr==0 ) {
		return 0;
	}
	dim = reversehalton_dimget ( );
	ierr = lowdisc_AssertNumberOfColumns ( fname , 1 , dim , nCols );
	if ( ierr==0 ) {
		return 0;
	}
	// Transfer the double array into an array of integers
	base = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		ierr = lowdisc_Double2IntegerArgument ( fname , 1 , valueVector[k] , base+k );
		if ( ierr==0 ) {
			return 0;
		}
	}
	// Startup Reverse Halton
	reversehalton_startup ( dim , base );
	// Free the base
	free_ivector ( base );
	return 0;
}
