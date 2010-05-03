
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


// _lowdisc_haltonfstart ( dim , base , seed , leap )
//   Start the Halton sequence.
// Parameters
//   dim : the number of dimensions (e.g. 1)
//   base : a 1 x dim matrix of doubles, a list of successive prime numbers (e.g. (0,0,0,0) for automatic setup or (2,3,5,7) for user-defined setup)
//   seed : a 1 x dim matrix of doubles, the Halton sequence element corresponding to STEP = 0 (e.g. (0,0,0,0) for default setup)
//   leap : a 1 x dim matrix of doubles, the succesive jumps in the Halton sequence. (e.g. (1,1,1,1) for default setup)
//
//      If base(i) = 0 then the prime number #i is automatically set.
//	    If base(i) > 1 then the base is directly used.
//	    If base(i) <0 or base(i) = 1, this is an error.

int sci_lowdisc_haltonfstart (char *fname) {
	int dim;
	double * quasi = NULL;
	int nRows;
	int nCols;
	int ierr;
	double *dbase = NULL;
	int * base = NULL;
	double *dseed = NULL;
	int * seed = NULL;
	double *dleap = NULL;
	int * leap = NULL;
	
	CheckRhs(4,5) ;
	CheckLhs(0,1) ;
	//
	// Get dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get base
	ierr = lowdisc_AssertVariableType(fname , 2 , sci_matrix );
	if ( ierr==0 ) {
		return 0;
	}
	GetRhsVarMatrixDouble ( 2 , &nRows, &nCols, &dbase);
	ierr = lowdisc_AssertNumberOfRows ( fname , 2 , 1 , nRows );
	if ( ierr==0 ) {
		return 0;
	}
	ierr = lowdisc_AssertNumberOfColumns ( fname , 2 , dim , nCols );
	if ( ierr==0 ) {
		return 0;
	}
	// Transfer the double array into an array of integers
	base = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		ierr = lowdisc_Double2IntegerArgument ( fname , 2 , dbase[k] , base+k );
		if ( ierr==0 ) {
			return 0;
		}
	}
	//
	// Get seed
	ierr = lowdisc_AssertVariableType ( fname , 3 , sci_matrix );
	if ( ierr == 0 ) {
		return 0;
	}
	GetRhsVarMatrixDouble ( 3 , &nRows, &nCols, &dseed);
	ierr = lowdisc_AssertNumberOfRows ( fname , 3 , 1 , nRows );
	if ( ierr == 0 ) {
		return 0;
	}
	ierr = lowdisc_AssertNumberOfColumns ( fname , 3 , dim , nCols );
	if ( ierr==0 ) {
		return 0;
	}
	// Transfer the double array into an array of integers
	seed = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		ierr = lowdisc_Double2IntegerArgument ( fname , 3 , dseed[k] , seed+k );
		if ( ierr == 0 ) {
			return 0;
		}
	}
	//
	// Get leap
	ierr = lowdisc_AssertVariableType ( fname , 4 , sci_matrix );
	if ( ierr == 0 ) {
		return 0;
	}
	GetRhsVarMatrixDouble ( 4 , &nRows, &nCols, &dleap);
	ierr = lowdisc_AssertNumberOfRows ( fname , 4 , 1 , nRows );
	if ( ierr == 0 ) {
		return 0;
	}
	ierr = lowdisc_AssertNumberOfColumns ( fname , 4 , dim , nCols );
	if ( ierr==0 ) {
		return 0;
	}
	// Transfer the double array into an array of integers
	leap = ivector ( dim );
	for(int k = 0; k < dim; k++) {
		ierr = lowdisc_Double2IntegerArgument ( fname , 4 , dleap[k] , leap+k );
		if ( ierr == 0 ) {
			return 0;
		}
	}
	//
	// Start the Halton sequence
	halton_start ( dim , base , seed, leap );
	//
	// Free the vectors
	free_ivector ( base );
	free_ivector ( seed );
	free_ivector ( leap );
	//
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
