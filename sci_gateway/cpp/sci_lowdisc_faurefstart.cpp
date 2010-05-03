
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
#include "faure.h" 


// _lowdisc_faurefstart ( dim )
// _lowdisc_faurefstart ( dim , basis )
//   Start the Fast Faure sequence.
// Parameters
//   dim: the dimension of the problem
//   basis: the basis of the sequence. 
//	   If basis is zero (default), then the basis is computed automatically from an internal prime table.
//	   If the basis is positive, then this basis is used.
//     This allows to increase the number of available dimensions
//     when the internal prime table is limited.
//     The basis must be the smallest prime greater than dim.
int sci_lowdisc_faurefstart (char *fname) {
	int dim;
	int basis;
	int ierr;

	CheckRhs(1,2) ;
	CheckLhs(0,1) ;
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	if ( Rhs==2 ) {
		ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &basis );
		if ( ierr==0 ) {
			return 0;
		}
	} 
	else
	{
		basis = 0;
	}
	faure_start ( dim , basis );
	lowdisc_CreateLhsInteger ( 1 , dim );
	return 0;
}
