
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
#include "sobol_i4.h"


// dim = _lowdisc_sobolfdimget ( )
//   Get the dimension of the Sobol sequence.
int sci_lowdisc_sobolfdimget (char *fname) {
	int dim;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	dim = i4_sobol_dimget ( );
	lowdisc_CreateLhsInteger ( 1 , dim );
	return 0;
}
