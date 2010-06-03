
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin

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
	int sci_lowdisc_sobolfdimget (char *fname);
	int sci_lowdisc_sobolfisstart (char *fname);
	//
	// Fast Halton Sequence
	int sci_lowdisc_haltonfnext (char *fname);
	int sci_lowdisc_haltonfstart (char *fname);
	int sci_lowdisc_haltonfstop (char *fname);
	int sci_lowdisc_haltonfdimget (char *fname);
	int sci_lowdisc_haltonfbaseget (char *fname);
	int sci_lowdisc_haltonfseedget (char *fname);
	int sci_lowdisc_haltonfleapget (char *fname);
	int sci_lowdisc_haltonfisstart (char *fname);
	//
	// Fast Faure sequence
	int sci_lowdisc_faurefstart (char *fname);
	int sci_lowdisc_faurefstop (char *fname);
	int sci_lowdisc_faurefnext (char *fname);
	int sci_lowdisc_faurefdimget (char *fname);
	int sci_lowdisc_faurefbaseget (char *fname);
	int sci_lowdisc_faurefisstart (char *fname);
	//
	// Fast Reverse Halton
	int sci_lowdisc_revhaltfstart (char *fname);
	int sci_lowdisc_revhaltfstop (char *fname);
	int sci_lowdisc_revhaltfnext (char *fname);
	int sci_lowdisc_revhaltfdimget (char *fname);
	int sci_lowdisc_revhaltfbaseget (char *fname);
	int sci_lowdisc_revhaltfisstart (char *fname);
	//
	// Fast Niederreiter
	int sci_lowdisc_niedfstart (char *fname);
	int sci_lowdisc_niedfstop (char *fname);
	int sci_lowdisc_niedfnext (char *fname);
	int sci_lowdisc_niedfbaseget (char *fname);
	int sci_lowdisc_niedfdimget (char *fname);
	int sci_lowdisc_niedfskipget (char *fname);
	int sci_lowdisc_niedfisstart (char *fname);
}
#endif /* __SCI_GW_LOWDISC_H__ */
