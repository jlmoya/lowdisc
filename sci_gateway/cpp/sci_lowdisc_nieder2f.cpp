
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


// [ quasi , seed ] = _lowdisc_niederf ( dim , base , seed )
//   Get the next element of the Niederreiter 
//   Arbitrary Base sequence.
int sci_lowdisc_niederf (char *fname) {
	int seed;
	int dim;
	int base;
	int INCX;
	int INCY;
	double *pdblQuasi = NULL; //SCILAB return quasi
	double *pdblSeed = NULL; //SCILAB return seed
	double dseed;
	int nRows;
	int nCols;

	CheckRhs(3,3) ;
	CheckLhs(2,2) ;
	nisp_GetOneInteger ( fname , 1 , &dim );
	nisp_GetOneInteger ( fname , 2 , &base );
	nisp_GetOneInteger ( fname , 3 , &seed );
	// Call the Niederreiter sequence
	quasi = dvector ( dim );
	niederreiter ( dim_num, base, &seed, quasi );
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
