// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function lowdisc_stopall ( )
  // Stop all fast sequences.
  //
  // Calling Sequence
  //   lowdisc_stopall ( )
  //
  // Description
  //   This function allows to stop all fast sequences. This 
  //   might be handy in case of interactive error of the user and may allow
  //   to reset all "lost" sequences.
  //
  // Examples
  //   lowdisc_stopall ( )
  //
  //   // Example of what can go wrong...
  //   // We create a Fast Reverse Halton sequence.
  //   lds = lowdisc_new("reversehaltonf");
  //   lds = lowdisc_startup (lds);
  //   // We create a Fast Reverse Halton sequence again.
  //   lds = lowdisc_new("reversehaltonf");
  //   lds = lowdisc_startup (lds);
  //   // This creates the error message : 
  //   // "Low Discrepancy Module Error ! revhal_startup is already done."
  //   // It would suffice to call lowdisc_destroy(lds). 
  //   // But we can use a more brutal function, which resets all sequences.
  //   lowdisc_stopall ( );
  //   // Now it works again.
  //   lds = lowdisc_new("reversehaltonf");
  //   lds = lowdisc_startup (lds);
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2010 - DIGITEO

  //
  // Fast Faure
  //
  start = _lowdisc_faurefisstart ( );
  if ( start == 1 ) then
    _lowdisc_faurefstop ( );
  end
  //
  // Fast Sobol
  //
  start = _lowdisc_sobolfisstart ( );
  if ( start == 1 ) then
    _lowdisc_sobolfstop ( );
  end
  //
  // Fast Reverse Halton
  //
  start = _lowdisc_revhaltfisstart ( );
  if ( start == 1 ) then
    _lowdisc_revhaltfstop ( );
  end
  //
  // Fast Halton
  //
  start = _lowdisc_haltonfisstart ( );
  if ( start == 1 ) then
    _lowdisc_haltonfstop ( );
  end
  //
  // Fast Niederreiter
  //
  start = _lowdisc_niedfisstart ( );
  if ( start == 1 ) then
    _lowdisc_niedfstop ( );
  end

endfunction

