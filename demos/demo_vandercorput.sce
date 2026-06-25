// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_demosvdc()
    //
    mprintf("Print Van Der Corput sequence in base 2.\n")
    b=2;
    n=b^4;
    u=lowdisc_ldgen(n,1,"halton");
    for k=1:n
        d=number_tobary(k,b);
        dstr=strcat(string(d),"");
        drev=strcat(string(d($:-1:1)),"");
        mprintf("k=%d=(%s)_%d, r=(0.%s)_%d=%f\n",..
        k,dstr,b,drev,b,u(k,1))
    end
    //
    mprintf("Print Van Der Corput sequence in base 3.\n")
    b=3;
    n=b^3;
    u=lowdisc_ldgen(n,2,"halton");
    for k=1:n
        d=number_tobary(k,b);
        dstr=strcat(string(d),"");
        drev=strcat(string(d($:-1:1)),"");
        mprintf("k=%d=(%s)_%d, r=(0.%s)_%d=%f\n",..
        k,dstr,b,drev,b,u(k,2))
    end
    //
    mprintf("Print Van Der Corput sequence in base 5.\n")
    b=5;
    n=b^3;
    u=lowdisc_ldgen(n,3,"halton");
    for k=1:n
        d=number_tobary(k,b);
        dstr=strcat(string(d),"");
        drev=strcat(string(d($:-1:1)),"");
        mprintf("k=%d=(%s)_%d, r=(0.%s)_%d=%f\n",..
        k,dstr,b,drev,b,u(k,3))
    end

    //
    // Plot Van Der Corput sequence in base 2.
    //
    scf();
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",1);

    k=1;
    base=2;
    imax=5;
    for i=1:5
        npoints=(base-1)*base^(i-1);
        [lds,u]=lowdisc_next(lds,npoints);
        plot(u',i,"bo")
        xstring(u',i,string(k:k+npoints-1))
        k=k+npoints;
    end
    lds = lowdisc_destroy (lds);
    a = gca();
    a.data_bounds=[
    0 0
    1 imax+1
    ];
    xtitle("Van Der Corput Sequence (base 2)",..
    "X","Block Index")
    //
    // Plot Van Der Corput sequence in base 3.
    //
    scf();
    base=3;
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",2);

    k=1;
    imax=3;
    for i=1:imax
        npoints=(base-1)*base^(i-1);
        [lds,u]=lowdisc_next(lds,npoints);
        plot(u(:,2)',i,"bo")
        xstring(u(:,2)',i,string(k:k+npoints-1))
        k=k+npoints;
    end
    lds = lowdisc_destroy (lds);
    a = gca();
    a.data_bounds=[
    0 0
    1 imax+1
    ];
    xtitle("Van Der Corput Sequence (base 3)",..
    "X","Block Index")
    //
    // Plot Van Der Corput sequence in base 5.
    //
    base=5;
    scf();
    lds = lowdisc_new("halton");
    lds = lowdisc_configure(lds,"-dimension",3);

    k=1;
    imax=2;
    for i=1:imax
        npoints=(base-1)*base^(i-1);
        [lds,u]=lowdisc_next(lds,npoints);
        plot(u(:,3)',i,"bo")
        xstring(u(:,3)',i,string(k:k+npoints-1))
        k=k+npoints;
    end
    lds = lowdisc_destroy (lds);
    a = gca();
    a.data_bounds=[
    0 0
    1 imax+1
    ];
    xtitle("Van Der Corput Sequence (base 5)",..
    "X","Block Index")
endfunction 
lowdisc_demosvdc();
clear lowdisc_demosvdc;
