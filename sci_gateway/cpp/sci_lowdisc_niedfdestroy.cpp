
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
//#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
#include "liblowdiscgateway.h"
#include "api_scilab.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "niederreiter.h" 
#include "lowdisc_nied_map.hxx" 

// _lowdisc_niedfdestroy (token)
//   Stop the Niederreiter sequence.
int sci_lowdisc_niedfdestroy (char *fname, void * pvApiCtx) 
{
	Niederreiter * seq;
	int token;
	int ierr;
	int iflag;
	
	//
	CheckRhs(1,1) ;
	CheckLhs(0,1) ;
	//
	// Arg #1: token
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &token, pvApiCtx );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	iflag=lowdisc_token2Niederreiter(fname, 1, token, &seq);
	if (iflag==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	delete seq;
	lowdisc_nied_map_remove(token);
	lowdisc_CreateLhsInteger ( 1 , token, pvApiCtx);
	return 0;
}
