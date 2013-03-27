// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function [ u , evalf ] = lowdisc_ldgen ( varargin )
    // Returns uniform numbers from a low discrepancy sequence.
    //
    // Calling Sequence
    //   u=lowdisc_ldgen(callf,n)
    //   u=lowdisc_ldgen(callf,n,ldseq)
    //   u=lowdisc_ldgen(callf,n,ldseq,strict)
    //   [u,evalf]=lowdisc_ldgen(...)
    //
    // Parameters
    //   callf : a 1-by-1 matrix of floating point integers, the number of calls to the function.
    //   n: a 1-by-1 matrix of floating point integers, the spatial dimension.
    //   ldseq : a 1-by-1 matrix of strings, the name of the sequence (default <literal>ldseq = "sobol"</literal>). The name can be equal to : <literal>"halton"</literal>, <literal>"faure"</literal>, <literal>"reversehalton"</literal>, <literal>"sobol"</literal>, <literal>"niederreiter"</literal>. See below for details.
    //   strict : a 1-by-1 matrix of boolean, set to %f to use potentially favorable parameters (default = %t).
    //   u : a evalf-by-n matrix of doubles, the uniform random numbers in <literal>[0,1]^n</literal>.
    //   evalf : a 1-by-1 matrix of floating point integers, the actual number of function evaluations. We have <literal>evalf==callf</literal> if strict is true and <literal>evalf >= callf</literal> if strict is false.
    //
    // Description
    // In dimension n, this function generates <literal>callf</literal> experiments with
    // the low discrepancy sequence <literal>ldseq</literal>.
    //
    // Returns the number of suggested function evaluations <literal>evalf</literal>
    // and the uniform numbers u in <literal>[0,1]^n</literal>.
    //
    // Depending on the value of <literal>strict</literal>, the function 
    // uses different values of <literal>evalf</literal>, <literal>skip</literal> 
    // and <literal>leap</literal>.
    //
    // If <literal>strict</literal> is true (the default), then 
    // <itemizedlist>
    //   <listitem>
    //     <para>
    //        the required number of simulations <literal>callf</literal> is used, 
    //        i.e. <literal>evalf=callf</literal>,
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        <literal>skip=0</literal>,
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        <literal>leap=0</literal>.
    //     </para>
    //   </listitem>
    // </itemizedlist>
    //
    // If <literal>strict</literal> is false, then 
    // <itemizedlist>
    //   <listitem>
    //     <para>
    //        a potentially favorable number of simulations <literal>evalf</literal> is used,
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        a potentially favorable value of <literal>skip</literal> is used,
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        a potentially favorable value of <literal>leap</literal> is used.
    //     </para>
    //   </listitem>
    // </itemizedlist>
    //
    // In general, using <literal>strict=%f</literal> 
    // may produce a set of points with greater quality. 
    // On the other hand, the value of <literal>evalf</literal> may be much larger 
    // than the value of <literal>callf</literal>, so that, in practice, 
    // it may be necessary to use <literal>strict=%t</literal>.
    //
    // If <literal>strict=%f</literal>, the actual behavior depends on the sequence.
    // <itemizedlist>
    //   <listitem>
    //     <para>
    //        Halton: we use the values computed by <literal>lowdisc_haltonsuggest</literal>.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        Faure: we use the values computed by <literal>lowdisc_fauresuggest</literal>.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        Sobol: we use <literal>evalf=2^ceil(log2(callf))</literal>, 
    //        <literal>skip=0</literal> and <literal>leap=0</literal>.
    //        We do not use <literal>lowdisc_sobolsuggest</literal> which may compute 
    //        excessively large number of simulations.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        Niederreiter: we use the values computed by <literal>lowdisc_niedersuggest</literal>.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        Reverse-Halton: we use <literal>evalf=callf</literal>, 
    //        <literal>skip=0</literal> and <literal>leap=0</literal>.
    //     </para>
    //   </listitem>
    // </itemizedlist>
    //
    // The sequences which are available are described in depth in 
    // the <literal>lowdisc_new</literal> function.
    //
    // Examples
    // // Generate 20 points from a 
    // // fast Sobol sequence in dimension 2
    // u=lowdisc_ldgen(20,2 )
    // // Plot them
    // scf();
    // plot(u(:,1),u(:,2),"bo")
    //
    // // Generate 20 points from a 
    // // fast Halton sequence in dimension 4
    // u=lowdisc_ldgen(20,4,"halton")
    //
    // // Generate 20 points from 
    // // the fast Faure sequence in dimension 4.
    // u=lowdisc_ldgen(20,4,"faure")
    //
    // // Generate more than 20 points with potentially 
    // // favorable parameters
    // [u,evalf]=lowdisc_ldgen(20,4,"faure",%f)
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_ldgen" , rhs , 2:4 )
    apifun_checklhs ( "lowdisc_ldgen" , lhs , 1:2 )
    //
    callf = varargin(1)
    n = varargin(2)
    ldseq = apifun_argindefault ( varargin , 3 , "sobol" )
    strict = apifun_argindefault ( varargin , 4 , %t )
    //
    // Check type
    apifun_checktype ( "lowdisc_ldgen" , callf , "callf" , 1 , "constant" )
    apifun_checktype ( "lowdisc_ldgen" , n , "n" , 2, "constant" )
    apifun_checktype ( "lowdisc_ldgen" , ldseq , "ldseq" , 3, "string" )
    apifun_checktype ( "lowdisc_ldgen" , strict , "strict" , 4, "boolean" )
    //
    // Check size
    apifun_checkscalar ( "lowdisc_ldgen" , callf , "callf" , 1 )
    apifun_checkscalar ( "lowdisc_ldgen" , n , "n" , 2 )
    apifun_checkscalar ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 )
    apifun_checkscalar ( "lowdisc_ldgen" , strict , "strict" , 4 )
    //
    // Check content
    apifun_checkflint ( "lowdisc_ldgen" , callf , "callf" , 1 )
    apifun_checkflint ( "lowdisc_ldgen" , n , "n" , 2 )
    availablemethods = lowdisc_methods ()
    apifun_checkoption ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 , availablemethods )
    //
    lds = lowdisc_new(ldseq);
    lds = lowdisc_configure(lds,"-dimension",n);
    select ldseq
    case "faure"
        base = lowdisc_get(lds,"-faureprime");
    case "halton"
        // Nothing to do
    case "niederreiter"
        base = lowdisc_niederbase ( n );
    case "reversehalton"
        // Nothing to do
    case "sobol"
        // Nothing to do
    else
        lds = lowdisc_destroy(lds);
        msg = msprintf(gettext("%s: Cannot compute base: Unexpected sequence %s.") , "lowdisc_ldgen" ,ldseq);
        error ( msg )
    end
    if ( strict ) then
        evalf = callf
        skip = 0
        leap = 0
    else
        if ( ldseq == "faure" ) then
            [evalf,skip,leap] = lowdisc_fauresuggest ( n , base , callf )
        elseif ( ldseq == "halton" ) then
            [evalf,skip,leap] = lowdisc_haltonsuggest ( n , callf )
        elseif ( ldseq == "niederreiter" ) then
            [evalf,skip,leap] = lowdisc_niedersuggest ( n , base , callf )
        elseif ( ldseq == "reversehalton" ) then
            // No parameter
            evalf = callf
            skip = 0
            leap = 0
        elseif ( ldseq == "sobol" ) then
            // Do not use lowdisc_sobolsuggest which suggests excessively 
            // large number of simulations.
            evalf = 2^ceil(log2(callf))
            skip = 0
            leap = 0
        else
            lds = lowdisc_destroy(lds);
            msg = msprintf(gettext("%s: Cannot compute [evalf,skip,leap] Unexpected sequence %s.") , "lowdisc_ldgen",ldseq);
            error ( msg )
        end
    end
    lds = lowdisc_configure(lds,"-skip",skip);
    lds = lowdisc_configure(lds,"-leap",leap);
    lds = lowdisc_startup (lds);
    [lds,u]=lowdisc_next(lds,evalf);
    lds = lowdisc_destroy(lds);
endfunction
