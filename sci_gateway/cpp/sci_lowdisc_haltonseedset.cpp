
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

// _lowdisc_haltonseedset ( seed )
//   Set the seed of the Halton sequence.
// Arguments
int sci_lowdisc_haltonseedset (char *fname) {
	int * seed = NULL;
	int nRows, nCols;
	double * valueVector = NULL;
	int dim;
	int ierr;
	
	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	ierr = lowdisc_AssertVariableType ( fname , 1 , sci_matrix );
	if ( ierr == 0 ) {
		return 0;
	}
	GetRhsVarMatrixDouble ( 1 , &nRows, &nCols, &valueVector);
	ierr = lowdisc_AssertNumberOfRows ( fname , 1 , 1 , nRows );
	if ( ierr == 0 ) {
		return 0;
	}
	dim = nCols;
	// Transfer the double array into an array of integers
	seed = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		ierr = lowdisc_Double2IntegerArgument ( fname , 1 , valueVector[k] , seed+k );
		if ( ierr == 0 ) {
			return 0;
		}
	}
	// Set the seed
	halton_seed_set ( seed );
	// Free the seed
	free_ivector ( seed );
	return 0;
}
