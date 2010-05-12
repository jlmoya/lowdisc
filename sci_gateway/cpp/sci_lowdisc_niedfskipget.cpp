
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
#include "niederreiter.h" 


// skip = _lowdisc_niedfskipget ( )
//   Get the skip of the Niederreiter sequence.
// Arguments
//   skip : a positive integer, the number of elements ignored at the begining of the sequence
int sci_lowdisc_niedfskipget (char *fname) {
	int skip;
	//
	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	//
	skip = niederreiter_skip_get ( );
	//
	lowdisc_CreateLhsInteger ( 1 , skip );
	return 0;
}
