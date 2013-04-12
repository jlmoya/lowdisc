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
        this.sequence     = ldrevhalf_destroy ( this.sequence )
    case "niederreiter" then
        this.sequence     = ldniedf_destroy ( this.sequence )
    case "sobol" then
        this.sequence     = ldsobolf_destroy ( this.sequence )
    case "faure" then
        this.sequence     = ldfauref_destroy ( this.sequence )
    case "halton" then
        this.sequence     = ldhaltonf_destroy ( this.sequence )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_destroy" , this.method);
        error(errmsg);
    end
endfunction

function this = ldsobolf_destroy (this)
    if ( _lowdisc_sobolfisstart() ) then
        _lowdisc_sobolfstop ( );
    end
    // Delegate to ldbase
    this.baseobj = ldbase_destroy ( this.baseobj )
endfunction

function this = ldfauref_destroy (this)
    if ( _lowdisc_faurefisstart() ) then
        _lowdisc_faurefstop ( )
    end
    // Delegate to ldbase
    this.baseobj = ldbase_destroy ( this.baseobj )  
endfunction

function this = ldrevhalf_destroy (this)
    if ( _lowdisc_revhaltfisstart() ) then
        _lowdisc_revhaltfstop ( );
    end
    // Delegate to ldbase
    this.baseobj = ldbase_destroy ( this.baseobj )
endfunction

function this = ldhaltonf_destroy (this)
    if ( _lowdisc_haltonfisstart() ) then
        _lowdisc_haltonfstop ( )
    end
    // Delegate to ldbase
    this.baseobj = ldbase_destroy ( this.baseobj )
endfunction

function this = ldniedf_destroy (this)
    if ( _lowdisc_niedfisstart() ) then
        _lowdisc_niedfstop ( )
    end
    // Delegate to ldbase
    this.baseobj = ldbase_destroy ( this.baseobj )

endfunction

function this = ldbase_destroy (this)
    this.startedup = %f;
endfunction
