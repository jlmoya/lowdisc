
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
#include "faure.h" 


// qs = _lowdisc_faurefbaseget ( )
//   Returns the prime number used by the Faure sequence.
int sci_lowdisc_faurefbaseget (char *fname) {
	int qs;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	qs = faure_baseget ( );
	lowdisc_CreateLhsInteger ( 1 , qs );
	return 0;
}
