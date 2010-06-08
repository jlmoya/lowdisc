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
  //   seqmat : a n x 1 matrix of strings. Each string represents a sequence and is a valid argument method for the lowdisc_new function.
  //
  // Description
  //   This function allows to make a loop over all sequences.
  //
  // Examples
  //
  //  seqmat = lowdisc_methods ()
  //
  //  // Get the maximum dimension for all sequences
  //  seqmat = lowdisc_methods ();
  //  for seqname = seqmat'
  //    lds = lowdisc_new(seqname);
  //    dimmax = lowdisc_get(lds,"-dimmax");
  //    mprintf("Sequence = %-20s, Maximum Dimension = %5d\n", seqname , dimmax );
  //    lds = lowdisc_destroy(lds);
  //  end
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

  seqmat = [
   "halton" 
   "haltonf" 
   "faure" 
   "fauref" 
   "reversehalton"
   "reversehaltonf" 
   "sobol"
   "sobolf"
   "niederreiter-base-2" 
   "niederreiterf" 
   ];
endfunction

