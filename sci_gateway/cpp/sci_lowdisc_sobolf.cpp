
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
#include "sobol_i4.h"


// quasi = _lowdisc_sobolf ( seed )
//   Get the next element of the Sobol sequence.
// TODO : rename as _lowdisc_sobolfnext
int sci_lowdisc_sobolf (char *fname) {
	int dim;
	int seed = 0;
	float * fquasi = NULL;
	double *pdblQuasi = NULL; //SCILAB return quasi
	int nRows;
	int nCols;
	int i;
	int ierr;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &seed );
	if ( ierr==0 ) {
		return 0;
	}
	dim = i4_sobol_dimget ( );
	// Call the Sobol sequence
	fquasi = fvector ( dim );
	i4_sobol ( & seed , fquasi );
	// Returns quasi
	nRows = 1;
	nCols = dim;
	lowdisc_CreateLhsMatrix ( 1 , nRows , nCols , &pdblQuasi );
	for ( i = 0; i < dim; i++ )
	{
		pdblQuasi[i] = (double) fquasi[i];
	}
	// Free the quasi vector
	free_fvector ( fquasi );
	return 0;
}
