// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
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
#include "sobol_i8.h"
#include "lowdisc_sobol_map.hxx" 


// token=_lowdisc_sobolfnew ( dim, coordinate)
//   coordinate: a 1-by-1 matrix of boolean, 
//       If false, we must generate all coordinates.
//       If true, we must generate only the dimension-th coordinate.
//   Create a new Sobol sequence.
int sci_lowdisc_sobolfnew (char *fname) {
	int dim;
	int ierr;
	Sobol * seq;
	int token;
	int coordinate;

	CheckRhs(2,2);
	CheckLhs(0,1);
	//
	// Get Arg #1 : dim
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	//
	// Get Arg #2: coordinate (coordinate=1 if false).
	ierr = lowdisc_GetOneBooleanArgument ( fname , 2, &coordinate);
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Create the sequence
	seq = new Sobol ( dim, coordinate );
	token = lowdisc_sobol_map_add(seq);
	lowdisc_CreateLhsInteger ( 1 , token );
	return 0;
}
