// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = lowdisc_new ( varargin )
    // Create a new object.
    //
    // Calling Sequence
    //   this = lowdisc_new ( )
    //   this = lowdisc_new ( method )
    //
    // Parameters
    //   this: the current object
    //   method: a 1-by-1 matrix of strings, the low discrepancy sequence (default = "sobol"). The method can be equal to : "halton", "faure", "sobol", "niederreiter". See below for details. 
    //
    // Description
    //   This function creates a new low discrepancy object.
    //
    //  The following is the list of possible values for method.
    //  <itemizedlist>
    //  <listitem>"halton" : the fast Halton sequence. 
    //    This sequence is sensitive to the <literal>"-primeslist"</literal> option.
    //    By default, it is able to generate experiments in dimension at most 100.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    To extend the number of dimensions, please configure the 
    //    <literal>"-primeslist"</literal> option.
    //    To enable scrambling, please configure the <literal>"-scrambling"</literal> 
    //    option.
    //    The maximum dimension which can be obtained is equal to the number of 
    //    different primes in the prime table. 
    //    </listitem>
    //  <listitem>"faure" : the fast Faure sequence.
    //    This sequence is sensitive to the <literal>"-primeslist"</literal> option.
    //    By default, it is able to generate experiments in dimension at most 541.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    To extend the number of dimensions, please configure the 
    //    <literal>"-primeslist"</literal> option.
    //    The maximum dimension which can be obtained is equal to the maximum 
    //    prime number in the prime table. 
    //    </listitem>
    //  <listitem>"sobol" : the fast Sobol sequence. 
    //    Without scrambling, it is able to generate experiments in dimension 
    //    at most 1111.
    //    With scrambling, the maximum number of dimensions is 40. 
    //    This sequence is able to generate at most 2^30-1  = 1 073 741 823 
    //    experiments. 
    //    There is no way to extend the number of dimensions or the number of 
    //    experiments.
    //    </listitem>
    //  <listitem>"niederreiter" : The fast Niederreiter sequence in arbitrary base. 
    //    The maximum dimension for this sequence is 50.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    The base can be configured with the <literal>"-base"</literal> option. 
    //    By default, the base is 2. 
    //    The base is expected to be a prime or a power of a prime, e.g. :
    //    <screen>
    //    4 = 2^2, 
    //    8 = 2^3, 
    //    9 = 3^2, 
    //    16 = 2^4, 
    //    25 = 5^2, 
    //    27 = 3^3, 
    //    32 = 2^5, 
    //    49 = 7^2.
    //    </screen>
    //    </listitem>
    //  </itemizedlist>
    //
    // Examples
    //   lds = lowdisc_new("faure");
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    // Authors
    // Copyright (C) 2013 - 2014 - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    // Copyright (C) 2010-2011 - DIGITEO - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_new" , rhs , 0:1 )
    apifun_checklhs ( "lowdisc_new" , lhs , 1 )
    //
    method = apifun_argindefault ( varargin , 1 , "sobol" )
    //
    apifun_checktype ( "lowdisc_new" , method , "method" , 1 , "string" )
    apifun_checkscalar ( "lowdisc_new" , method , "method" , 1 )
    //
    this = tlist([
    "LOWDISC"
    "method"
    "sequence"
    ])
    this.method = method
    select this.method
    case "niederreiter" then
        this.sequence     = ldniedf_new ()
    case "sobol" then
        this.sequence     = ldsobolf_new ()
    case "faure" then
        this.sequence     = ldfauref_new ()
    case "halton" then
        this.sequence     = ldhaltonf_new ()
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_new" , this.method);
        error(errmsg);
    end
endfunction

function this = ldsobolf_new ()
    this = tlist([
    "LDSOBOLF"
    "baseobj"
    "dimmax"
    "nbsimmax"
    "scrambling"
    "token"
    "seeds"
    ])
    this.baseobj = ldbase_new ( "fast" )
    this.dimmax = 1111
    this.nbsimmax = 2^30 - 1
    this.scrambling = ""
    this.token = -1
    this.seeds= []
endfunction

function this = ldhaltonf_new ()
    this = tlist([
    "LDHLTNF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    "scrambling"
    "token"
    ])
    this.baseobj = ldbase_new ( "fast" )
    //
    // Configurable options
    // This makes the component available up to dimension 100
    this.primeslist = number_primes100 ( )
    // By default, there is no scrambling
    this.scrambling=""
    //
    // Non Configurable options
    this.primessize = size(this.primeslist,2)
    this.nbsimmax = 2^31 - 1
    this.token = -1
endfunction

function this = ldfauref_new ()
    this = tlist([
    "LDFAUREF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    "token"
    ])
    //
    // Configurable options
    this.baseobj = ldbase_new ( "fast" )
    // This makes the component available up to dimension 100
    this.primeslist = number_primes100 ( )
    //
    // Non Configurable options
    this.primessize = size(this.primeslist,2)
    this.nbsimmax = 2^31 - 1
    this.token = -1
endfunction

function this = ldniedf_new ()
    // Create a new Fast Niederreiter Arbitrary Base object.
    //

    this = tlist([
    "LDNIEDF"
    "baseobj"
    "base"
    "gfaritfile"
    "gfplysfile"
    "dimmax"
    "nbsimmax"
    "token"
    ])
    this.baseobj = ldbase_new ( "fast" )
    //
    // Configurable options
    this.base = 2
    this.gfaritfile = fullfile(TMPDIR,"gfarit.txt")
    this.gfplysfile = fullfile(TMPDIR,"gfplys.txt")
    this.dimmax = 50
    this.nbsimmax = 2^31 - 1
    this.token = -1
endfunction

function this = ldbase_new ( speed )
    [lhs, rhs] = argn()
    apifun_checkrhs ( "ldbase_new" , rhs , 1:1 )
    apifun_checklhs ( "ldbase_new" , lhs , 1 )
    //
    apifun_checktype ( "ldbase_configure" , speed , "speed" , 1 , "string" )
    apifun_checkscalar ( "ldbase_configure" , speed , "speed" , 1 )
    apifun_checkoption ( "ldbase_configure" , speed , "speed" , 1 , ["fast" "slow"] )
    //
    this = tlist([
    "LDBASE"
    "verbose"
    "dimension"
    "index"
    "startedup"
    "skip"
    "leap"
    "speed"
    "coordinate"
    ])
    //
    // Configurable options
    this.verbose=%f
    this.dimension=1
    this.index=0
    this.skip = 0
    this.leap = 0
    this.startedup = %f
    this.speed = speed
    this.coordinate=%f
endfunction



