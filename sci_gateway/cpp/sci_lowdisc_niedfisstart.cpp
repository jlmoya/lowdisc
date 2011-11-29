
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
#include "lowdisc_math.h" 
#include "niederreiter.h" 


// start = _lowdisc_niedfisstart ( )
//   Returns 1 if the sequence is started up, 0 if not.
// TODO : return a boolean instead of a double
int sci_lowdisc_niedfisstart (char *fname) {
	bool start;

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;

	start = niederreiter_isstart ( );
	if ( start )
	{
	  lowdisc_CreateLhsInteger ( 1 , 1 );
	} 
	else 
	{
	  lowdisc_CreateLhsInteger ( 1 , 0 );
	}
	return 0;
}
