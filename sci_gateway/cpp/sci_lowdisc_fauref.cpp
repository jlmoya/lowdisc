
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
#include "faure.h" 


// [ quasi , seed ] = _lowdisc_fauref ( dim , seed )
//   Get the next element of the Faure sequence.
int sci_lowdisc_fauref (char *fname) {
	int dim;
	int seed = 0;
	double * quasi = NULL;
	int INCX;
	int INCY;
	double *pdblQuasi = NULL; //SCILAB return quasi
	double *pdblSeed = NULL; //SCILAB return seed
	double dseed;
	int nRows;
	int nCols;

	CheckRhs(2,2) ;
	CheckLhs(2,2) ;
	lowdisc_GetOneInteger ( fname , 1 , &dim );
	lowdisc_GetOneInteger ( fname , 2 , &seed );
	// Call the Faure sequence
	quasi = dvector ( dim );
	faure ( dim, &seed, quasi );
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &pdblQuasi );
	INCX = 1;
	INCY = 1;
	C2F(dcopy)(&dim,quasi,&INCX,pdblQuasi,&INCY);
	// Return seed
	dseed = (double) seed;
	lowdisc_CreateLhsDouble ( 2 , dseed );
	// Free the quasi vector
	free_dvector ( quasi );
	return 0;
}
