
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


// quasi = _lowdisc_haltonf ( step )
//   Get the next element of the Halton sequence.
// TODO : rename as _lowdisc_haltonfnext
int sci_lowdisc_haltonf (char *fname) {
	int step;
	int dim;
	double * quasi = NULL;
	int nRows;
	int nCols;
	int ierr;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	//
	// Get step
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &step );
	if ( ierr==0 ) {
		return 0;
	}
	dim = halton_dim_num_get();
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &quasi );
	halton ( step , quasi );
	return 0;
}
