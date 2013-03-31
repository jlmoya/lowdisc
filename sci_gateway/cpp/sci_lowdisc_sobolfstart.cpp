// Copyright (C) 2013 - Michael Baudin
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
#include "sobol_i8.h"


// _lowdisc_sobolfstart ( dim )
//   Start the Sobol sequence.
int sci_lowdisc_sobolfstart (char *fname) {
	int dim;
	int ierr;

	CheckRhs(1,1);
	CheckLhs(0,1);
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dim );
	if ( ierr==0 ) {
		return 0;
	}
	i8_sobol_start ( dim );
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
