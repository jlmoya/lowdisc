// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
#include "stdlib.h"
//#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
//#include "gw_lowdisc.h"
#include "liblowdiscgateway.h"
#include "api_scilab.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "lowdisc_math.h" 
#include "sobol_i8.h"
#include "lowdisc_sobol_map.hxx" 


// tokens = _lowdisc_sobolftokens ( )
//   Returns the sobol tokens.
int sci_lowdisc_sobolftokens (char *fname, void * pvApiCtx)
{
	int size;
	int * tokens = NULL;
	double * doubletokens = NULL;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	size = lowdisc_sobol_map_size ();
	if (size > 0) {
		tokens = (int *) malloc (size * sizeof (int));
		doubletokens = (double *) malloc (size * sizeof (double));
	}
	lowdisc_sobol_map_tokens (tokens);
	// Returns the matrix of tokens as the result
	lowdisc_CreateLhsMatrix ( 1 , 1 , size , &doubletokens,pvApiCtx );
	for(int i = 0; i < size; i++) {
		doubletokens[i] = (double)tokens[i];
	}
	if (size > 0) {
		free(tokens);
		tokens = NULL;
	}
	LhsVar(1) = Rhs+1;
	return 0;
}
/* ==================================================================== */

