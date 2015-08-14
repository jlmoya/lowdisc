// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
//#include "stack-c.h"
#include "api_scilab.h" 
#include "Scierror.h"
#include "localization.h"
#include "liblowdiscgateway.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "faure.h"
#include "lowdisc_faure_map.hxx" 


// _lowdisc_faurefdestroy (token)
// token : a 1-by-1 matrix of doubles, integer value, 
//         token>=0, the current object.
//   Destroy current sequence.
int sci_lowdisc_faurefdestroy (char *fname, void * pvApiCtx) 
{
	int token;
	Faure * seq;
	int ierr;
	int iflag;
	//CheckInputArgument(pvApiCtx,1,1); 
	//CheckOutnputArgument(pvApiCtx,1,1);	
	CheckRhs(1,1) ;
	CheckLhs(0,1) ;

	// Arg #1: token
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &token, pvApiCtx );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	//
	iflag=lowdisc_token2Faure(fname, 1, token, &seq);
	if (iflag==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	delete seq;
	lowdisc_faure_map_remove(token);
	lowdisc_CreateLhsInteger ( 1 , token, pvApiCtx);
	return 0;
}
