// Copyright (C) 2013 - Michael Baudin
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
    //   method: a 1-by-1 matrix of strings, the low discrepancy sequence (default = "sobolf"). The method can be equal to : "halton", "faure", "reversehalton", "sobol", "niederreiter". See below for details. 
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
    //    To extend the number of dimensions, please configure the <literal>"-primeslist"</literal> option.
    //    The maximum dimension which can be obtained is equal to the number of 
    //    different primes in the prime table. 
    //    For the Halton sequence, the <literal>skip</literal> and 
    //    <literal>leap</literal> option is fast, that is, large 
    //    values of the <literal>skip</literal> or <literal>leap</literal> parameter do not reduce the performance.
    //    This fast algorithm is based on a compiled C source code. 
    //    The implementation is a modification of the C source code by John Burkardt.
    //    </listitem>
    //  <listitem>"faure" : the fast Faure sequence.
    //    This sequence is sensitive to the <literal>"-primeslist"</literal> option.
    //    By default, it is able to generate experiments in dimension at most 541.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    To extend the number of dimensions, please configure the <literal>"-primeslist"</literal> option.
    //    The maximum dimension which can be obtained is equal to the maximum 
    //    prime number in the prime table. 
    //    For the Faure sequence, the <literal>skip</literal> and 
    //    <literal>leap</literal> option is fast, that is, large 
    //    values of the <literal>skip</literal> or <literal>leap</literal> parameter do not reduce the performance.
    //    This fast algorithm is based on a compiled C source code. 
    //    The implementation is a modification of the C source code by John Burkardt.
    //    Original Fortran 77 version by Bennett Fox in "Algorithm 647: Implementation and Relative Efficiency of
    //    Quasirandom Sequence Generators".
    //    </listitem>
    //  <listitem>"reversehalton" : the fast Reverse Halton sequence of Vandewoestyne and Cools.
    //    This sequence is sensitive to the <literal>"-primeslist"</literal> option.
    //    By default, it is able to generate experiments in dimension at most 100.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    To extend the number of dimensions, please configure the <literal>"-primeslist"</literal> option.
    //    The maximum dimension which can be obtained is equal to the number of 
    //    different primes in the prime table. 
    //    For the Reverse Halton sequence, the <literal>skip</literal> and 
    //    <literal>leap</literal> option are fast, that is, large 
    //    values of the <literal>skip</literal> or <literal>leap</literal> parameter do not reduce the performance.
    //    This fast algorithm is based on a compiled C source code. 
    //    This implementation is based on the paper "Good permutations for deterministic scrambled
    //    Halton sequences in terms of L2-discrepancy" by B. Vandewoestyne and R. Cools.
    //    </listitem>
    //  <listitem>"sobol" : the fast Sobol sequence. 
    //    It is able to generate experiments in dimension at most 1111.
    //    This sequence is able to generate at most 2^30-1  = 1 073 741 823 experiments. 
    //    There is no way to extend the number of dimensions or the number of 
    //    experiments.
    //    The routine adapts the ideas of Antonov and Saleev, which make use of a Gray code 
    //    representation to construct the elements of the sequence recursively.
    //    For the Sobol sequence, the <literal>skip</literal> and 
    //    <literal>leap</literal> options are slow, that is, large 
    //    values of the <literal>skip</literal> or <literal>leap</literal> parameter leads to increased CPU time.
    //    This is because generating the new vector implies to update iteratively
    //    the lastq vector.
    //    This fast algorithm is based on a compiled C source code. 
    //    The implementation is a modification of the C source code by John Burkardt.
    //    Original Fortran 77 version by Bennett Fox in "Algorithm 647: Implementation and Relative Efficiency of
    //    Quasirandom Sequence Generators".
    //    </listitem>
    //  <listitem>"niederreiter" : The fast Niederreiter sequence in arbitrary base. 
    //    The maximum dimension for this sequence is 50.
    //    This sequence is able to generate at most 2^31 - 1  = 2 147 483 647 experiments.
    //    The base can be configured with the -base option. By default, the base is 2. 
    //    The base is expected to be a prime or a power of a prime. If the base is a power of a 
    //    prime, it must be one of the following :  4 = 2^2, 8 = 2^3, 9 = 3^2, 16 = 2^4, 25 = 5^2, 
    //    27 = 3^3, 32 = 2^5, 49 = 7^2.
    //    For the Niederreiter sequence, the <literal>skip</literal> and 
    //    <literal>leap</literal> option is slow, that is, large 
    //    values of the <literal>skip</literal> or <literal>leap</literal> parameter leads to increased CPU time.
    //    This is because generating the new vector implies to update iteratively
    //    the nextq vector.
    //    The library generates two temporary files gfarit and gfplys when the sequence is started up.
    //    This fast algorithm is based on a compiled C source code. 
    //    This is a C port of "Algorithm 738: Programs to generate Niederreiter's low-discrepancy
    //    sequences" (1994) by Paul Bratley, Bennett Fox, Harald Niederreiter. 
    //    The C port has been done by John Burkardt in 2005-2009. The library has 
    //    been updated to present a uniform API. 
    //    </listitem>
    //  </itemizedlist>
    //
    // Examples
    //   lds = lowdisc_new("faure");
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    // Copyright (C) 2010-2011 - DIGITEO - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_new" , rhs , 0:1 )
    apifun_checklhs ( "lowdisc_new" , lhs , 1 )
    //
    method = apifun_argindefault ( varargin , 1 , "sobolf" )
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
    case "reversehalton" then
        this.sequence     = ldrevhalf_new ()
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
    ])
    this.baseobj = ldbase_new ( "fast" )
    this.dimmax = 1111
    this.nbsimmax = 2^30 - 1
endfunction

function this = ldhaltonf_new ()

    this = tlist([
    "LDHLTNF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    "scrambling"
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
endfunction

function this = ldfauref_new ()

    this = tlist([
    "LDFAUREF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
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
endfunction

function this = ldrevhalf_new ()

    this = tlist([
    "LDRVHLF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    ])
    this.baseobj = ldbase_new ( "fast" )
    //
    // Configurable options
    // This makes the component available up to dimension 100
    this.primeslist = number_primes100 ( )
    //
    // Non Configurable options
    this.primessize = size(this.primeslist,2)
    this.nbsimmax = 2^31 - 1
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
    ])
    this.baseobj = ldbase_new ( "fast" )
    //
    // Configurable options
    this.base = 2
    this.gfaritfile = fullfile(TMPDIR,"gfarit.txt")
    this.gfplysfile = fullfile(TMPDIR,"gfplys.txt")
    this.dimmax = 50
    this.nbsimmax = 2^31 - 1
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
endfunction



