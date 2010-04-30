
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


// quasi = _lowdisc_haltonf ( dim )
//   Get the next element of the Halton sequence.
int sci_lowdisc_haltonf (char *fname) {
	int dim;
	double * quasi = NULL;
	int INCX;
	int INCY;
	double *pdblQuasi = NULL; //SCILAB return quasi
	int nRows;
	int nCols;
        int ierr;
	
	CheckRhs(1,1) ;
	CheckLhs(1,1) ;
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	// Call the Halton sequence
	quasi = dvector ( dim );
	halton ( quasi );
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &pdblQuasi );
	INCX = 1;
	INCY = 1;
	C2F(dcopy)(&dim,quasi,&INCX,pdblQuasi,&INCY);
	// Free the quasi vector
	free_dvector ( quasi );
	return 0;
}
