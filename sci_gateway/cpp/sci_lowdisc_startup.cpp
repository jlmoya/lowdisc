
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
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

/* ==================================================================== */

#include "sci_lowdisc_startup.hxx" 
#include "lowdisc.h"

int sci_lowdisc_startup_flag = 0;

// sci_lowdisc_errorfunction --
//   The error callback used by the Low Discrepancy Library.
//   Redirect the message to Scilab's error function.
void sci_lowdisc_errorfunction ( char * message ) {
	Scierror(999,_("Lowdisc: Error at the library level:\n%s\n") , message );
}

// sci_lowdisc_messagefunction --
//   The error callback used by the Low Discrepancy Library.
//   Redirect the message to Scilab's error function.
void sci_lowdisc_messagefunction ( char * message ) {
	sciprint( message );
}

// lowdisc_startup ( )
//   startup the Low Discrepancy library
int sci_lowdisc_startup (char *fname, void * pvApiCtx) {

	CheckRhs(0,0) ;
	CheckLhs(0,1) ;
	// Connect the Lowdisc message function to Scilab's print
	if (sci_lowdisc_startup_flag==0) {
		lowdisc_msgsetfunction ( sci_lowdisc_messagefunction );
		lowdisc_errorsetfunction ( sci_lowdisc_errorfunction );
		sci_lowdisc_startup_flag = 1;
	}
	return 0;
}
