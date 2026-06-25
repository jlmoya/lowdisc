// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
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
#include "sobol_i8.h"
#include "lowdisc_sobol_map.hxx" 


// quasi=_lowdisc_sobolfnext(token, seed, imax, leap, coordinate )
//
// Arguments
// token : a 1-by-1 matrix of doubles, integer value, token>=0, the current object.
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
//   Get the next element of the Sobol sequence.
// If leap = 0, then get the elements 
//   seed, seed+1, seed+2, etc...
// If leap = 1, then get the elements 
//   seed, seed+2, seed+4, etc...
//
int sci_lowdisc_sobolfnext (char *fname, void *pvApiCtx_) {
	pvApiCtx = pvApiCtx_;
	int dim;
	int seed = 0;
	// next : an array [0,1,...,dim-1]
	double * next = NULL;
	// next : an array [0,1,...,(dim-1)(imax-1)]
	// Organized column-by-column
	double *quasi = NULL; //SCILAB return quasi
	int i, k;
	int ierr;
	int imax = 0;
	int leap = 0;
	long long int longseed;
	int token;
	Sobol * seq;
	int iflag;
	int coordinate;

	CheckRhs(4,4) ;
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
	// Proceed...
	iflag=lowdisc_token2Sobol(fname, 1, token, &seq);
	if (iflag==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	dim = seq->dimget ( );
	coordinate = seq->coordinateget ( );
	if (coordinate)
	{
		next = (double *)malloc(sizeof(double));
	}
	else
	{
		next = (double *)malloc(dim*sizeof(double));
	}
	longseed = (long long int) seed;
	if (coordinate)
	{
		lowdisc_CreateLhsMatrix ( 1 , imax , 1, &quasi );
	}
	else 
	{
		lowdisc_CreateLhsMatrix ( 1 , imax , dim , &quasi );
	}
	for ( k = 0; k < imax; k++ )
	{
		// Call Sobol sequence
		seq->next ( & longseed, next );
		if (coordinate)
		{
			*(quasi + k) = next[0];
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
			longseed = longseed + leap;
		}
	}
	free(next);
	return 0;
}
