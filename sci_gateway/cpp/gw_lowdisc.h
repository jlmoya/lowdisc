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
	int sci_lowdisc_startup (char *fname, void *pvApiCtx);
	int sci_lowdisc_shutdown (char *fname, void *pvApiCtx);
	//
	// Fast Sobol sequence
	int sci_lowdisc_sobolfnext (char *fname, void *pvApiCtx);
	int sci_lowdisc_sobolfnew (char *fname, void *pvApiCtx);
	int sci_lowdisc_sobolfdestroy (char *fname, void *pvApiCtx);
	int sci_lowdisc_sobolftokens (char *fname, void *pvApiCtx);
	//
	// Fast Halton Sequence
	int sci_lowdisc_haltonfnext (char *fname, void *pvApiCtx);
	int sci_lowdisc_haltonfnew (char *fname, void *pvApiCtx);
	int sci_lowdisc_haltonfdestroy (char *fname, void *pvApiCtx);
	int sci_lowdisc_haltonftokens (char *fname, void *pvApiCtx);
	//
	// Fast Faure sequence
	int sci_lowdisc_faurefnew (char *fname, void *pvApiCtx);
	int sci_lowdisc_faurefdestroy (char *fname, void *pvApiCtx);
	int sci_lowdisc_faurefnext (char *fname, void *pvApiCtx);
	int sci_lowdisc_faureftokens (char *fname, void *pvApiCtx);
	//
	// Fast Niederreiter
	int sci_lowdisc_niedfnew (char *fname, void *pvApiCtx);
	int sci_lowdisc_niedfdestroy (char *fname, void *pvApiCtx);
	int sci_lowdisc_niedfnext (char *fname, void *pvApiCtx);
	int sci_lowdisc_niedftokens (char *fname, void *pvApiCtx);
	//
	// Fast Scrambled Sobol sequence
	int sci_lowdisc_ssobolnext (char *fname, void *pvApiCtx);
	int sci_lowdisc_ssobolnew (char *fname, void *pvApiCtx);
	int sci_lowdisc_ssoboldestroy (char *fname, void *pvApiCtx);
	int sci_lowdisc_ssoboltokens (char *fname, void *pvApiCtx);

}
#endif /* __SCI_GW_LOWDISC_H__ */
