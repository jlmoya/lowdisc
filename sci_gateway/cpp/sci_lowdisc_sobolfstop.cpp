
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
#include "sobol_i4.h"


// _lowdisc_sobolfstop ( )
//   Stop the Sobol sequence.
int sci_lowdisc_sobolfstop (char *fname) {

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	i4_sobol_stop ( );
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
