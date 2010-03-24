
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin

extern "C" {
#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "halton.h" 


// _lowdisc_starthaltonf ( dim , seed )
//   Startup the Halton sequence.
int sci_lowdisc_starthaltonf (char *fname) {
	int dim;
	int * seed = NULL;
	int nRows;
	int nCols;
	int * base = NULL;

	CheckRhs(2,2) ;
	CheckLhs(2,2) ;
	nisp_GetOneInteger ( fname , 1 , &dim );
	GetRhsVarMatrixDouble ( 2 , &nRows, &nCols, &seed );
	lowdisc_AssertNumberOfRows ( fname , 2 , 1 , nRows );
	lowdisc_AssertNumberOfCols ( fname , 2 , dim , nRows );
	// Call the Halton sequence
      	halton_dim_num_set ( dim );
      	step = 0;
      	halton_step_set ( 0 );
      	halton_seed_set ( seed );
      	base = ivector ( dim );
      	for ( int i = 0; i < dim; i++ )
      	{
        		base[i] = lowdisc_primes ( i );
      	}
      	halton_base_set ( base );
      	free_ivector ( base );
	// Returns dim
        	lowdisc_CreateLhsDouble ( 1 , (double) dim );
	return 0;
}
