
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


// _lowdisc_revhaltfbaseset ( base )
//   Set the base of the reverse Halton sequence.
int sci_lowdisc_revhaltfbaseset (char *fname) {
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
	reversehalton_baseset ( base );
	// Free the base
	free_ivector ( base );
	return 0;
}
