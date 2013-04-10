// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
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
#include "ssobol.h"


// _lowdisc_ssobolfstart ( dim , iflag )
//   Start the Scrambed Sobol sequence.
int sci_lowdisc_ssobolfstart (char *fname) {
	int dimen;
	int ierr;
	int maxd=30;
	int iflag;
	int atmost=1073741823; // The maximum available.
	int taus; // We just ignore this value.

	CheckRhs(2,2);
	CheckLhs(0,1);
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dimen );
	if ( ierr==0 ) {
		return 0;
	}
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &iflag );
	if ( ierr==0 ) {
		return 0;
	}
	ssobol_startup(dimen, atmost, iflag, maxd, &taus);
	lowdisc_CreateLhsInteger ( 1 , 0 );
	return 0;
}
