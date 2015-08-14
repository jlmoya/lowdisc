
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

extern "C" {
#include "Scierror.h"
#include "localization.h"
#include "sciprint.h"
#include "liblowdiscgateway.h"
#include "api_scilab.h"
}

#include "sci_lowdisc_startup.hxx" 

/* ==================================================================== */

// lowdisc_shutdown ( )
//   shutdown the Low Discrepancy library
int sci_lowdisc_shutdown (char *fname, void* pvApiCtx) {

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	if (sci_lowdisc_startup_flag==1) {
		// Nothing to do for now
		sci_lowdisc_startup_flag = 0;
	}
	return 0;
}
