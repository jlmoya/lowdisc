// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

//
// gw_lowdisc.h
//   Header for the LOWDISC gateway.
//
#ifndef __SCI_GW_LOWDISC_H__
#define __SCI_GW_LOWDISC_H__

extern "C" {

	// Functions providing interfaces to Scilab functions
	//
	// Start/Stop the whole library
	int sci_lowdisc_startup (char *fname);
	int sci_lowdisc_shutdown (char *fname);
	//
	// Fast Sobol sequence
	int sci_lowdisc_sobolfnext (char *fname);
	int sci_lowdisc_sobolfstart (char *fname);
	int sci_lowdisc_sobolfstop (char *fname);
	int sci_lowdisc_sobolfisstart (char *fname);
	//
	// Fast Halton Sequence
	int sci_lowdisc_haltonfnext (char *fname);
	int sci_lowdisc_haltonfnew (char *fname);
	int sci_lowdisc_haltonfdestroy (char *fname);
	int sci_lowdisc_haltonftokens (char *fname);
	//
	// Fast Faure sequence
	int sci_lowdisc_faurefstart (char *fname);
	int sci_lowdisc_faurefstop (char *fname);
	int sci_lowdisc_faurefnext (char *fname);
	int sci_lowdisc_faurefisstart (char *fname);
	//
	// Fast Reverse Halton
	int sci_lowdisc_revhaltfstart (char *fname);
	int sci_lowdisc_revhaltfstop (char *fname);
	int sci_lowdisc_revhaltfnext (char *fname);
	int sci_lowdisc_revhaltfisstart (char *fname);
	//
	// Fast Niederreiter
	int sci_lowdisc_niedfstart (char *fname);
	int sci_lowdisc_niedfstop (char *fname);
	int sci_lowdisc_niedfnext (char *fname);
	int sci_lowdisc_niedfisstart (char *fname);
	//
	// Fast Scrambled Sobol sequence
	int sci_lowdisc_ssobolnext (char *fname);
	int sci_lowdisc_ssobolnew (char *fname);
	int sci_lowdisc_ssoboldestroy (char *fname);
	int sci_lowdisc_ssoboltokens (char *fname);

}
#endif /* __SCI_GW_LOWDISC_H__ */
