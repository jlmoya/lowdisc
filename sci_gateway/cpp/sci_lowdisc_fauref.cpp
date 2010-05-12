
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
#include "faure.h" 


// quasi = _lowdisc_fauref ( seed )
//   Get the next element of the Faure sequence.
// TODO : rename as _lowdisc_faurefnext
int sci_lowdisc_fauref (char *fname) {
	int dim;
	int seed = 0;
	double * quasi = NULL;
	int nRows;
	int nCols;
	int ierr;
	//
	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	//
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &seed );
	if ( ierr==0 ) {
		return 0;
	}
	dim = faure_dimget ( );
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &quasi );
	// Call the Faure sequence
	faure ( &seed, quasi );
	return 0;
}
