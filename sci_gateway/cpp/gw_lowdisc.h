
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
	int sci_lowdisc_sobolf (char *fname);
	int sci_lowdisc_haltonseedset (char *fname);
	int sci_lowdisc_haltonstepset (char *fname);
	int sci_lowdisc_haltondimnumset (char *fname);
	int sci_lowdisc_haltonbaseset (char *fname);
	int sci_lowdisc_haltonf (char *fname);
	int sci_lowdisc_faureprimege (char *fname);
	int sci_lowdisc_fauref (char *fname);
	int sci_lowdisc_startup (char *fname);
//	int sci_lowdisc_reversehaltonf (char *fname);
//	int sci_lowdisc_niederf (char *fname);
}
#endif /* __SCI_GW_LOWDISC_H__ */
