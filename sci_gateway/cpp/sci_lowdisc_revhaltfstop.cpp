
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
#include "reversehalton.h" 
#include "lowdisc_math.h" 


// _lowdisc_revhaltfstop ( )
//   Shutdown the Reverse Halton sequence.
//
int sci_lowdisc_revhaltfstop (char *fname) {

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	reversehalton_stop ( );
	lowdisc_CreateLhsInteger ( 1 , 0 );

	return 0;
}
