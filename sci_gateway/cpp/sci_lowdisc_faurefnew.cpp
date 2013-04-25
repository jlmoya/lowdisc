// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
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
#include "faure.h" 
#include "lowdisc_faure_map.hxx" 


// token=_lowdisc_faurefnew ( dim , basis )
//   Start the Faure sequence.
// Parameters
//   dim : the number of dimensions (e.g. 1)
//   basis : a 1 x dim matrix of doubles, the largest prime number smaller or equal to dim (e.g. basis=7 if dim=6)

int sci_lowdisc_faurefnew (char *fname) {
	int dim;
	int ierr;
	int basis;
	Faure * seq;
	int token;
	
	CheckRhs(2,2) ;
	CheckLhs(0,1) ;
	//
	// Get Arg #1: dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Get Arg #2: basis
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &basis );
	if ( ierr==0 ) {
		return 0;
	}
	//
	// Start the Faure sequence
	seq = new Faure(dim,basis);
	token = lowdisc_faure_map_add(seq);
	//
	lowdisc_CreateLhsInteger ( 1 , token );
	return 0;
}
