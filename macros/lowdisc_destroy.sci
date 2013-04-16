// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the 
// GNU LGPL license.

function this = lowdisc_destroy (this)
    // Destroy the current object.
    //
    // Calling Sequence
    //   this = lowdisc_destroy (this)
    //
    // Parameters
    //   this: the current object
    //
    // Description
    //   This function requires to take the current object both as an input
    //   and an output argument.
    //
    // Examples
    //   lds = lowdisc_new("faure");
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    // Authors
    //   Copyright (C) 2013 - Michael Baudin
    //   Copyright (C) 2008-2009 - INRIA - Michael Baudin
    //   Copyright (C) 2010 - DIGITEO - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_destroy" , rhs , 1:1 )
    apifun_checklhs ( "lowdisc_destroy" , lhs , 0:1 )
    //
    apifun_checktype ( "lowdisc_destroy" , this , "this" , 1 , "LOWDISC" )
    //
    select this.method
    case "reversehalton" then
        this     = ldrevhalf_destroy ( this )
    case "niederreiter" then
        this     = ldniedf_destroy ( this )
    case "sobol" then
        this     = ldsobolf_destroy ( this )
    case "faure" then
        this     = ldfauref_destroy ( this )
    case "halton" then
        this     = ldhaltonf_destroy ( this )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_destroy" , this.method);
        error(errmsg);
    end
    // Delegate to ldbase
    this.sequence.baseobj = ldbase_destroy ( this.sequence.baseobj )
endfunction

function this = ldsobolf_destroy (this)
    scrambling = lowdisc_cget ( this , "-scrambling" )
    if (scrambling=="") then
        if ( _lowdisc_sobolfisstart() ) then
            _lowdisc_sobolfstop ( );
        end
    else
        if (this.sequence.token<>-1) then
            _lowdisc_ssoboldestroy ( this.sequence.token )
        end
    end
endfunction

function this = ldfauref_destroy (this)
    if ( _lowdisc_faurefisstart() ) then
        _lowdisc_faurefstop ( )
    end
endfunction

function this = ldrevhalf_destroy (this)
    if ( _lowdisc_revhaltfisstart() ) then
        _lowdisc_revhaltfstop ( );
    end
endfunction

function this = ldhaltonf_destroy (this)
    if ( _lowdisc_haltonfisstart() ) then
        _lowdisc_haltonfstop ( )
    end
endfunction

function this = ldniedf_destroy (this)
    if ( _lowdisc_niedfisstart() ) then
        _lowdisc_niedfstop ( )
    end
endfunction

function this = ldbase_destroy (this)
    this.startedup = %f;
endfunction
