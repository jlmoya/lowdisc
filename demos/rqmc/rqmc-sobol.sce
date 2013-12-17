// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function demo_sobolscrambling()
    s=2; // The dimension
    n=2^4; // The number of points

    scf();
    ///////////////////////////////////////////
    //
    // See a classic Sobol sequence.
    // This is a (t,s)-sequence in base 2.
    //
    lds = lowdisc_new("sobol");
    lds = lowdisc_configure(lds,"-dimension",s);
    [lds,u] = lowdisc_next (lds,n-1);
    lds = lowdisc_destroy(lds);
    u = [zeros(1,s);u]; // Insert zero
    subplot(2,2,1)
    lowdisc_plotelembox([2 2],[2 2],u)
    xtitle("Sobol")
    ///////////////////////////////////////////
    //
    // See a Owen Scrambled Sobol sequence
    // This is a (t,s)-sequence in base 2.
    //
    lds = lowdisc_new("sobol");
    lds = lowdisc_configure(lds,"-dimension",s);
    lds = lowdisc_configure(lds,"-scrambling","Owen");
    [lds,u] = lowdisc_next (lds,n);
    lds = lowdisc_destroy(lds);
    subplot(2,2,2)
    lowdisc_plotelembox([2 2],[2 2],u)
    xtitle("Scrambled (Owen) Sobol")
    //
    ///////////////////////////////////////////
    //
    // See a Faure-Tezuka Scrambled Sobol sequence.
    // This is a (t,s)-sequence in base 2.
    //
    lds = lowdisc_new("sobol");
    lds = lowdisc_configure(lds,"-dimension",s);
    lds = lowdisc_configure(lds,"-scrambling","Faure-Tezuka");
    [lds,u] = lowdisc_next (lds,n);
    lds = lowdisc_destroy(lds);
    subplot(2,2,3)
    lowdisc_plotelembox([2 2],[2 2],u)
    xtitle("Scrambled (Faure-Tezuka) Sobol")
    //
    ///////////////////////////////////////////
    //
    // See a Owen-Faure-Tezuka Scrambled Sobol sequence
    // This is a (t,s)-sequence in base 2.
    //
    lds = lowdisc_new("sobol");
    lds = lowdisc_configure(lds,"-dimension",s);
    lds = lowdisc_configure(lds,"-scrambling","Owen-Faure-Tezuka");
    [lds,u] = lowdisc_next (lds,n);
    lds = lowdisc_destroy(lds);
    subplot(2,2,4)
    lowdisc_plotelembox([2 2],[2 2],u)
    xtitle("Scrambled (Owen-Faure-Tezuka) Sobol")

    filename = 'rqmc-sobol.sce';
    demo_viewCode(filename);
endfunction
demo_sobolscrambling();
clear demo_sobolscrambling;
