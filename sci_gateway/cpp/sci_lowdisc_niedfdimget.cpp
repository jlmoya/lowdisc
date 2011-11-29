
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
#include "gw_lowdisc.h"
}

/* ==================================================================== */


#include "gw_lowdisc_support.h" 
#include "niederreiter.h" 


// dim = _lowdisc_niedfdimget ( )
//   Get the dimension of the Niederreiter sequence.
// Arguments
//   dim : a positive integer, the number of parameters
int sci_lowdisc_niedfdimget (char *fname) {
	int dim;
	//
	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	//
	dim = niederreiter_dim_num_get ( );
	//
	lowdisc_CreateLhsInteger ( 1 , dim );
	return 0;
}
