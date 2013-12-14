// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function u=lowdisc_ldgen( varargin )
    // Returns uniform numbers from a low discrepancy sequence.
    //
    // Calling Sequence
    //   u=lowdisc_ldgen(callf,n)
    //   u=lowdisc_ldgen(callf,n,ldseq)
    //
    // Parameters
    //   callf : a 1-by-1 matrix of floating point integers, the number of calls to the function.
    //   n: a 1-by-1 matrix of floating point integers, the spatial dimension.
    //   ldseq : a 1-by-1 matrix of strings, the name of the sequence (default <literal>ldseq = "sobol"</literal>). The name can be equal to : <literal>"halton"</literal>, <literal>"halton-leaped"</literal>, <literal>"halton-scrambled"</literal>, <literal>"halton-reverse"</literal>, <literal>"faure"</literal>, <literal>"sobol"</literal>, <literal>"niederreiter"</literal>. See below for details.
    //   u : a callf-by-n matrix of doubles, the uniform random numbers in <literal>[0,1]^n</literal>.
    //
    // Description
    // In dimension n, this function generates <literal>callf</literal> experiments with
    // the low discrepancy sequence <literal>ldseq</literal>.
    //
    // Returns the numbers u in <literal>[0,1]^n</literal>.
    //
    // <itemizedlist>
    //   <listitem>
    //     <para>
    //        "halton": the Halton sequence.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "halton-leaped": a leaped Halton sequence. 
    //        For dimension less or equal to 999, the leap value is p-1, 
    //        where p is the (dim+1)-th prime number. 
    //        If not we return leap = 0.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "halton-scrambled": a scrambled Halton sequence, 
    //        with the permutation used in Kocis and Whiten (RR2).
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "faure": the Faure sequence.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "halton-reverse": the Reverse Halton sequence 
    //        of Vandewoestyne and Cools.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "faure": the Faure sequence.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "sobol": the Sobol sequence.
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //        "niederreiter": the Niederreiter sequence with optimal base.
    //     </para>
    //   </listitem>
    // </itemizedlist>
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
    // // See all projections of a 4D sequence.
    // u = lowdisc_ldgen ( 100 , 4 );
    // scf();
    // plotmatrix ( u )
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_ldgen" , rhs , 2:3 )
    apifun_checklhs ( "lowdisc_ldgen" , lhs , 1:1 )
    //
    callf = varargin(1)
    n = varargin(2)
    ldseq = apifun_argindefault ( varargin , 3 , "sobol" )
    //
    // Check type
    apifun_checktype ( "lowdisc_ldgen" , callf , "callf" , 1 , "constant" )
    apifun_checktype ( "lowdisc_ldgen" , n , "n" , 2, "constant" )
    apifun_checktype ( "lowdisc_ldgen" , ldseq , "ldseq" , 3, "string" )
    //
    // Check size
    apifun_checkscalar ( "lowdisc_ldgen" , callf , "callf" , 1 )
    apifun_checkscalar ( "lowdisc_ldgen" , n , "n" , 2 )
    apifun_checkscalar ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 )
    //
    // Check content
    apifun_checkflint ( "lowdisc_ldgen" , callf , "callf" , 1 )
    apifun_checkflint ( "lowdisc_ldgen" , n , "n" , 2 )
    availablemethods = [
    "halton" 
    "halton-reverse" 
    "halton-leaped" 
    "halton-scrambled" 
    "faure" 
    "sobol"
    "niederreiter" 
    ]
    apifun_checkoption ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 , availablemethods )
    //
    select ldseq
    case "faure"
        lds = lowdisc_new("faure");
    case "halton"
        lds = lowdisc_new("halton");
    case "halton-leaped"
        lds = lowdisc_new("halton");
        [evalf,skip,leap] = lowdisc_haltonsuggest ( n , callf )
        lds = lowdisc_configure(lds,"-skip",skip);
        lds = lowdisc_configure(lds,"-leap",leap);
    case "halton-scrambled"
        lds = lowdisc_new("halton");
        lds = lowdisc_configure(lds,"-scrambling","RR2");
    case "niederreiter"
        lds = lowdisc_new("niederreiter");
        base = lowdisc_niederbase ( n )
        lds = lowdisc_configure(lds,"-base",base);
    case "halton-reverse"
        lds = lowdisc_new("halton");
        lds = lowdisc_configure(lds,"-scrambling","Reverse");
    case "sobol"
        lds = lowdisc_new("sobol");
    else
        lds = lowdisc_destroy(lds);
        msg = msprintf(gettext("%s: Cannot compute base: Unexpected sequence %s.") , "lowdisc_ldgen" ,ldseq);
        error ( msg )
    end
    lds = lowdisc_configure(lds,"-dimension",n);
    [lds,u]=lowdisc_next(lds,callf);
    lds = lowdisc_destroy(lds);
endfunction
