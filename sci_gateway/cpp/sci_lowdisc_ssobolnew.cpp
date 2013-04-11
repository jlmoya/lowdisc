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
#include "lowdisc_ssobol_map.hxx" 


// token = _lowdisc_ssobolnew ( dim , iflag )
//   Start the Scrambed Sobol sequence.
int sci_lowdisc_ssobolnew (char *fname) {
	int dimen;
	int ierr;
	int maxd=30;
	int iflag;
	int atmost=1073741823; // The maximum available.
	int taus; // We just ignore this value.
	Ssobol * seq;
	int token;

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
	seq = new Ssobol(dimen, atmost, iflag, maxd, &taus);
	token= lowdisc_ssobol_map_add ( seq );
	lowdisc_CreateLhsInteger ( 1 , token );
	return 0;
}
