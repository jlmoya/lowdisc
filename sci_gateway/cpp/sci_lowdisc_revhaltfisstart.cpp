
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
#include "reversehalton.h" 
#include "lowdisc_math.h" 


// start = _lowdisc_revhaltfisstart ( )
//   Returns 1 if the sequence is started up, 0 if not.
//
int sci_lowdisc_revhaltfisstart (char *fname) {
	bool start;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	start = reversehalton_isstart ( );
	if ( start )
	{
	  lowdisc_CreateLhsInteger ( 1 , 1 );
	} 
	else 
	{
	  lowdisc_CreateLhsInteger ( 1 , 0 );
	}

	return 0;
}
