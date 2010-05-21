
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


// _lowdisc_niedfstart ( dim , base , skip , gfaritfile , gfplysfile )
//   Start the Niederreiter sequence.
// Parameters
//   dim : 1 x 1 matrix of doubles, the number of dimensions (e.g. 1)
//   base : 1 x 1 matrix of doubles, the base (e.g. 2). The base should be a prime, or a power of a prime.
//   skip : 1 x 1 matrix of doubles, the number of elements to skip (e.g. 0). 
//   gfaritfile : the data file to write, a tables of addition and multiplication (Handle a field of prime-power order).
//   gfplysfile : the data file to write, a table of irreducible polynomials.
//
int sci_lowdisc_niedfstart (char *fname) {
	int dim;
	int base;
	int skip;
	int ierr;
	char ** gfaritdata = NULL;
	char * gfaritfile;
	char ** gfplysdata = NULL;
	char * gfplysfile;
	int nCols;
	int nRows;
	
	CheckRhs(5,5) ;
	CheckLhs(0,1) ;
	//
	// Get dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get base
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &base );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get skip
	ierr = lowdisc_GetOneIntegerArgument ( fname , 3 , &skip );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get gfaritfile
	ierr = lowdisc_AssertVariableType(fname , 4 , sci_strings );
	if ( ierr==0 ) {
		return 0;
	}
	GetRhsVar( 4, MATRIX_OF_STRING_DATATYPE, &nRows,   &nCols,   &gfaritdata);
	ierr = lowdisc_AssertNumberOfRows ( fname , 4 , nRows , 1 );
	if ( ierr==0 ) {
		return 0;
	}
	ierr = lowdisc_AssertNumberOfColumns ( fname , 4 , nCols , 1 );
	if ( ierr==0 ) {
		return 0;
	}
	gfaritfile = gfaritdata[0];
	//
	// Get gfplysfile
	ierr = lowdisc_AssertVariableType(fname , 5 , sci_strings );
	if ( ierr==0 ) {
		return 0;
	}
	GetRhsVar( 5, MATRIX_OF_STRING_DATATYPE, &nRows,   &nCols,   &gfplysdata);
	ierr = lowdisc_AssertNumberOfRows ( fname , 5 , nRows , 1 );
	if ( ierr==0 ) {
		return 0;
	}
	ierr = lowdisc_AssertNumberOfColumns ( fname , 5 , nCols , 1 );
	if ( ierr==0 ) {
		return 0;
	}
	gfplysfile = gfplysdata[0];
	//
	// Start the sequence
	niederreiter_start ( dim, base, skip , gfaritfile , gfplysfile );
	//
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
