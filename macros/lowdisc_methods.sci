// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function seqmat = lowdisc_methods ()
    // Returns available sequences.
    //
    // Calling Sequence
    //   seqmat = lowdisc_methods ()
    //
    // Parameters
    //   seqmat : a n-by-1 matrix of strings. Each string represents a sequence and is a valid argument method for the lowdisc_new function.
    //
    // Description
    //   This function allows to make a loop over all sequences.
    //
    // Examples
    //  // Get all the available sequences.
    //  seqmat = lowdisc_methods ()
    //
    //  // Get the speed, maximum dimension and 
    //  // maximum number of calls for all sequences
    //  seqmat = lowdisc_methods ();
    //  mprintf("%-20s %-10s %-10s %-10s\n", "Name" , ..
    //    "Speed" , "Max Dim" , "Max Call" );
    //  for seqname = seqmat'
    //    lds = lowdisc_new(seqname);
    //    speed = lowdisc_get(lds,"-speed");
    //    dimmax = lowdisc_get(lds,"-dimmax");
    //    nbsimmax = lowdisc_get(lds,"-nbsimmax");
    //    mprintf("%-20s %-10s  %-10d %-10d\n", seqname , ..
    //      speed , dimmax , nbsimmax );
    //    lds = lowdisc_destroy(lds);
    //  end
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    //

    seqmat = [
    "halton" 
    "faure" 
    "reversehalton" 
    "sobol"
    "niederreiter" 
    ];
endfunction

