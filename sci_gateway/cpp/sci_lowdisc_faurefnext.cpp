
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - Digiteo - Michael Baudin

extern "C" {
#include "stdlib.h"
#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "faure.h" 


// quasi = _lowdisc_faurefnext ( seed , imax , leap )
// Arguments
// seed: a 1-by-1 matrix of doubles, integer value
//       The index of the first element in the sequence
// imax: a 1-by-1 matrix of doubles, integer value
//       The number of elements to generate
// leap: a 1-by-1 matrix of doubles, integer value
//       The number of elements to ignore, between two consecutive elements.
// quasi: a imax-by-d matrix of doubles
//        The elements in the sequence.
//   quasi(i,:) is the i-th element, for i= 1, 2, ..., imax
//   quasi(:,j) is the j-th element, for j= 1, 2, ..., d,
//         where d is the dimension of the sequence.
//
// Description
//   Get the next n elements of the Faure sequence.
// If leap = 0, then get the elements 
//   seed, seed+1, seed+2, etc...
// If leap = 1, then get the elements 
//   seed, seed+2, seed+4, etc...
//
int sci_lowdisc_faurefnext (char *fname) {
	int dim;
	int seed = 0;
	double * quasi = NULL;
	int ierr;
	int imax = 0;
	int leap = 0;
	int i, k;
	double * next = NULL;
	//
	CheckRhs(3,3) ;
	CheckLhs(0,1) ;
	// Arg #1: seed
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &seed );
	if ( ierr==0 ) {
		return 0;
	}
	// Arg #2: imax
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &imax );
	if ( ierr==0 ) {
		return 0;
	}
	// Arg #3: leap
	ierr = lowdisc_GetOneIntegerArgument ( fname , 3 , &leap );
	if ( ierr==0 ) {
		return 0;
	}
	// Proceed...
	dim = faure_dimget ( );
	next = (double *)malloc(dim*sizeof(double));
	if (next==NULL)
	{
		Scierror(112, "%s: No more memory.\n",fname);
		return 0;
	}
	lowdisc_CreateLhsMatrix ( 1 , imax , dim , &quasi );
	// Call the Faure sequence
	for ( k = 0; k < imax; k++ )
	{
		faure ( &seed, next );
		for(i=0; i<dim; i++) 
		{
			*(quasi + i * imax + k) = next[i];
		}
		if ( leap > 0 ) 
		{
			// Leap over (i.e. ignore) as many elements as required
			// Directly set the index.
			seed = seed + leap;
		}
	}
	free(next);
	return 0;
}
