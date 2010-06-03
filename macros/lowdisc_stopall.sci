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
  //   might be handy in case of interactive plouf and may allow
  //   to reset all "lost" sequences.
  //
  // Examples
  //   lowdisc_stopall ( )
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

