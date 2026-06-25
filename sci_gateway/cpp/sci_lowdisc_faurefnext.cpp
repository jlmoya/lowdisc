// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
#include "stdlib.h"
#include "api_scilab.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "faure.h" 
#include "lowdisc_faure_map.hxx" 


// quasi = _lowdisc_faurefnext ( token,seed , imax , leap )
// Arguments
// token : a 1-by-1 matrix of doubles, integer value, the token
// seed: a 1-by-1 matrix of doubles, integer value
//       The index of the first element in the sequence
// imax: a 1-by-1 matrix of doubles, integer value
//       The number of elements to generate
// leap: a 1-by-1 matrix of doubles, integer value
//       The number of elements to ignore, between two consecutive elements.
// coordinate: a 1-by-1 matrix of boolean, 
//       If false, we must generate all coordinates.
//       If true, we must generate only the dimension-th coordinate.
// quasi: a imax-by-d matrix of doubles
//        The elements in the sequence.
//   quasi(i,:) is the i-th element, for i= 1, 2, ..., imax
//   quasi(:,j) is the j-th element, for j= 1, 2, ..., d,
//         where d is the dimension of the sequence.
//
// Description
//   Get the next imax elements of the Faure sequence.
// If leap = 0, then get the elements 
//   seed, seed+1, seed+2, etc...
// If leap = 1, then get the elements 
//   seed, seed+2, seed+4, etc...
//
int sci_lowdisc_faurefnext (char *fname, void *pvApiCtx_) {
	pvApiCtx = pvApiCtx_;
	int dim;
	int seed = 0;
	double * quasi = NULL;
	int ierr;
	int imax = 0;
	int leap = 0;
	int i, k;
	double * next = NULL;
	int token;
	Faure * seq;
	int coordinate;
	//
	CheckRhs(5,5) ;
	CheckLhs(0,1) ;
	// Arg #1: token
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &token );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Arg #2: seed
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &seed );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Arg #3: imax
	ierr = lowdisc_GetOneIntegerArgument ( fname , 3 , &imax );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Arg #4: leap
	ierr = lowdisc_GetOneIntegerArgument ( fname , 4 , &leap );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	//
	// Get Arg #5: coordinate (coordinate=1 if false).
	ierr = lowdisc_GetOneBooleanArgument ( fname , 5, &coordinate);
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Proceed...
	ierr=lowdisc_token2Faure(fname, 1, token, &seq);
	if (ierr==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	dim = seq->dimget ( );
	next = (double *)malloc(dim*sizeof(double));
	if (next==NULL)
	{
		Scierror(112, "%s: No more memory.\n",fname);
		return 0;
	}
	if (coordinate)
	{
		lowdisc_CreateLhsMatrix ( 1 , imax , 1, &quasi );
	}
	else 
	{
		lowdisc_CreateLhsMatrix ( 1 , imax , dim , &quasi );
	}
	// Call the Faure sequence
	for ( k = 0; k < imax; k++ )
	{
		seq->next ( &seed, next );
		if (coordinate)
		{
			*(quasi + k) = next[dim-1];
		}
		else
		{
			for(i=0; i<dim; i++) 
			{
				*(quasi + i * imax + k) = next[i];
			}
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
