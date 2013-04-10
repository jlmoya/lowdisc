// Copyright (C) 2013 - Michael Baudin
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
#include "ssobol.h"


// _lowdisc_ssobolfstop ( )
//   Stop the Scrambed Sobol sequence.
int sci_lowdisc_ssobolfstop (char *fname) {

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	ssobol_stop ( );
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
