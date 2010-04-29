
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


//  _lowdisc_revhaltfdimset ( dim )
//   Set dimension of the reverse Halton sequence.
int sci_lowdisc_revhaltfdimset (char *fname) {
	int * dim;
	int ierr;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;

	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , dim );
	if ( ierr==0 ) {
		return 0;
	}
	reversehalton_dimset ( * dim );
	lowdisc_CreateLhsInteger ( 1 , * dim );
	return 0;
}
