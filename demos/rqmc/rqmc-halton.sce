// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function demo_haltonscrambling()
    s=2; // The dimension
    n=2^2*3^2; // The number of points

    scf();
    ///////////////////////////////////////////
    //
    // See a classic Halton sequence.
    // This is a (t,m,s)-net (in the extended sense, 
    // i.e. where the base changes with the dimension).
    //
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",s);
    [lds,u] = lowdisc_next (lds,n-1);
    lds = lowdisc_destroy(lds);
    u = [zeros(1,s);u]; // Insert zero
    subplot(2,2,1)
    lowdisc_plotelembox([2 3],[2 2],u)
    xtitle("Halton")
    ///////////////////////////////////////////
    //
    // See a Randomly Shifted-Halton sequence
    // This is {u+x} where 
    // u is the Halton sequence and 
    // x is a (single)random uniformly distributed point,
    // where the fractionnal part of z is denoted by {z}.
    // This is NOT a (t,m,s)-net.
    //
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",s);
    [lds,u] = lowdisc_next (lds,n-1);
    lds = lowdisc_destroy(lds);
    u = [zeros(1,s);u]; // Insert zero
    x=grand(1,2,"def"); // Random shift
    u=modulo(x(ones(n,1),:)+u,1);// RQMC
    subplot(2,2,2)
    lowdisc_plotelembox([2 3],[2 2],u)
    xtitle("Random Shift Halton")
    //
    ///////////////////////////////////////////
    //
    // See a RR2 Scrambled Halton sequence.
    // The RR2 scrambling maintains the (t,m,s)-net property.
    //
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",s);
    lds = lowdisc_configure(lds,"-scrambling","RR2");
    [lds,u] = lowdisc_next (lds,n-1);
    lds = lowdisc_destroy(lds);
    u = [zeros(1,s);u]; // Insert zero
    subplot(2,2,3)
    lowdisc_plotelembox([2 3],[2 2],u)
    xtitle("Scrambled (RR2) Halton")
    //
    ///////////////////////////////////////////
    //
    // See a Reverse Halton sequence
    //
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",s);
    lds = lowdisc_configure(lds,"-scrambling","Reverse");
    [lds,u] = lowdisc_next (lds,n-1);
    lds = lowdisc_destroy(lds);
    u = [zeros(1,s);u]; // Insert zero
    subplot(2,2,4)
    lowdisc_plotelembox([2 3],[2 2],u)
    xtitle("Scrambled (Reverse) Halton")

    filename = 'rqmc-halton.sce';
    demo_viewCode(filename);
endfunction 
demo_haltonscrambling();
clear demo_haltonscrambling


