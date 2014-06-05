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
// token = _lowdisc_ssobolnew ( dim , iflag , seeds )
//   Start the Scrambed Sobol sequence.
int sci_lowdisc_ssobolnew (char *fname) {
	int dimen;
	int ierr;
	int maxd=30;
	int iflag;
	int atmost=1073741823; // The maximum available.
	Ssobol * seq;
	int token;
	int nRows;
	int nCols;
	double *seeds = NULL;
	int isok;

	CheckRhs(2,3);
	CheckLhs(0,1);
	// Arg #1 : dimen
	ierr = lowdisc_GetOneIntegerArgument ( fname , 1 , &dimen );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	// Arg #2 : iflag
	ierr = lowdisc_GetOneIntegerArgument ( fname , 2 , &iflag );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	//
	// Get Arg #2: base
	ierr = lowdisc_AssertVariableType(fname , 2 , sci_matrix );
	if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
		return 0;
	}
	if ( Rhs == 2 ) 
	{
		// token = _lowdisc_ssobolnew ( dim , iflag )
		seq = new Ssobol(dimen, atmost, iflag, maxd,&isok);
	}
	else
	{
		// token = _lowdisc_ssobolnew ( dim , iflag , seeds )
		// Arg #3 : seeds
		GetRhsVarMatrixDouble ( 3 , &nRows, &nCols, &seeds);
		if (nRows==24)
		{
			ierr = lowdisc_AssertNumberOfColumns ( fname , 3 , 1 , nCols );
			if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
				return 0;
			}
		}
		else
		{
			ierr = lowdisc_AssertNumberOfRows ( fname , 3 , 1 , nRows );
			if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
				return 0;
			}
			ierr = lowdisc_AssertNumberOfColumns ( fname , 3 , 24 , nCols );
			if ( ierr==LOWDISC_GWSUPPORT_ERROR ) {
				return 0;
			}
		}
		seq = new Ssobol(dimen, atmost, iflag, maxd, seeds,&isok);
	}
	// Add the token
	if (isok==1)
	{
		token= lowdisc_ssobol_map_add ( seq );
		lowdisc_CreateLhsInteger ( 1 , token );
	}
	else
	{
		lowdisc_CreateLhsInteger ( 1 , -1 );
	}
	return 0;
}
