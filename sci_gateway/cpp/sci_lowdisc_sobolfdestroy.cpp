// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
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
#include "sobol_i8.h"
#include "lowdisc_sobol_map.hxx" 


// _lowdisc_sobolfdestroy (token)
// token : a 1-by-1 matrix of doubles, integer value, 
//         token>=0, the current object.
//   Destroy current sequence.
int sci_lowdisc_sobolfdestroy (char *fname, void *pvApiCtx_) 
{
	pvApiCtx = pvApiCtx_;
	int token;
	Sobol * seq;
	int ierr;
	int iflag;

	CheckRhs(1,1) ;
	CheckLhs(0,1) ;

	// Arg #1: token
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &token );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	//
	iflag=lowdisc_token2Sobol(fname, 1, token, &seq);
	if (iflag==LOWDISC_GWSUPPORT_ERROR)
	{
		return 0;
	}
	delete seq;
	lowdisc_sobol_map_remove(token);
	lowdisc_CreateLhsInteger ( 1 , token );
	return 0;
}
