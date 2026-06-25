// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
#include "api_scilab.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "ssobol.h"
#include "lowdisc_ssobol_map.hxx" 


// _lowdisc_ssoboldestroy (token)
//   Stop the Scrambed Sobol sequence.
int sci_lowdisc_ssoboldestroy(char *fname, void *pvApiCtx_) 
{
	pvApiCtx = pvApiCtx_;

	int token;
	Ssobol * seq;
	int ierr;
	int iflag;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;

	// Arg #1: token
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &token );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	iflag=lowdisc_token2Ssobol(fname, 1, token, &seq);
	if (iflag==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	delete seq;
	lowdisc_ssobol_map_remove(token);
	lowdisc_CreateLhsInteger ( 1 , token );
	return 0;
}
