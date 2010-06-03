
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
#include "niederreiter.h" 


// quasi = _lowdisc_niedfnext ( )
//   Get the next element of the Niederreiter sequence.
int sci_lowdisc_niedfnext (char *fname) {
	int dim;
	double * quasi = NULL;
	int nRows;
	int nCols;
	int ierr;
	//
	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	//
	dim = niederreiter_dim_num_get();
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &quasi );
	niederreiter ( quasi );
	return 0;
}
