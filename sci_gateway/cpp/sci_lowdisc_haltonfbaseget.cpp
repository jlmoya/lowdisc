
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

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

// base = _lowdisc_haltonfbaseget (  )
//   Get the basis of the Halton sequence.
// Arguments
//   base : a matrix of positive integers, the basis
//     This is usually a matrix of the first dim primes.
int sci_lowdisc_haltonfbaseget (char *fname) {
	int nRows, nCols;
	double * base = NULL;
	int * ibase = NULL;
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	// Get the dimension
	dim = halton_dim_num_get ( );
	// Create an integer array to store the base.
	ibase = ivector ( dim );
	// Get the integer base
	halton_base_get ( ibase );
	// Create a Scilab variable
	nRows=1;
	nCols=dim;
	lowdisc_CreateLhsMatrix(1, nRows, nCols, &base);
	// Copy the integer values into doubles
	for(int k = 0; k < dim; k++) {
		base[k] = ibase[k];
	}
	// Free the base
	free_ivector ( ibase );

	return 0;
}
