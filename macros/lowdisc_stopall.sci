// Copyright (C) 2013 - Michael Baudin
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
    //   // We create a Niederreiter sequence.
    //   lds = lowdisc_new("niederreiter");
    //   lds = lowdisc_startup (lds);
    //   // We create a Niederreiter sequence again.
    //   lds = lowdisc_new("niederreiter");
    //   lds = lowdisc_startup (lds);
    //   // This creates the error message : 
    //   // "Low Discrepancy Module Error ! Startup is already done."
    //   // It would suffice to call lowdisc_destroy(lds). 
    //   // But we can use a more brutal function, which resets all sequences.
    //   lowdisc_stopall ( );
    //   // Now it works again.
    //   lds = lowdisc_new("niederreiter");
    //   lds = lowdisc_startup (lds);
    //   lds = lowdisc_destroy(lds);
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin

    //
    // Faure
    //
    start = _lowdisc_faureftokens();
    for seq=seqmat
        _lowdisc_faurefdestroy(seq)
    end
    //
    // Sobol
    //
    seqmat = _lowdisc_sobolftokens ( )
    for seq=seqmat
        _lowdisc_sobolfdestroy(seq)
    end
    //
    // Halton
    //
    seqmat=_lowdisc_haltonftokens()
    for seq=seqmat
        _lowdisc_haltonfdestroy(seq)
    end
    //
    // Niederreiter
    //
    start = _lowdisc_niedfisstart ( );
    if ( start == 1 ) then
        _lowdisc_niedfstop ( );
    end
    //
    // Scrambled Sobol
    //
    seqmat=_lowdisc_ssoboltokens()
    for seq=seqmat
        _lowdisc_ssoboldestroy(seq)
    end

endfunction

