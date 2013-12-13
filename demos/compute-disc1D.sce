// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

// Description
// Shows how to compute the discrepancy of a set of N 
// points in 1D.
//
// The star discrepancy is the discrepancy with 
// intervals anchored at the origin :
//
// P=prod_{j=1,...,s} [0,beta_j]
//
// The discrepancy is the discrepancy with 
// general intervals :
//
// P=prod_{j=1,...,s} [alpha_j,beta_j]
//
// References
// Sur le calcul et la majoration de la discrépance à l'origine. 
// 2000
// Eric Thiemard
// Thèse
// Ecole Polytechnique Fédérale de Lausanne

function d=starDiscr1D(x)
    // Compute the 1D star discrepancy.
    //
    // Calling Sequence
    //   d=starDiscr1D(x)
    //
    // Parameters
    //   x : a n-by-1 matrix of doubles, must be in [0,1], the points
    //   d : a 1-by-1 matrix of doubles, in [0,1], the star discrepancy
    //
    // Description
    // Compute the star discrepancy of the 1D point set x.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "starDiscr1D" , rhs , 1 )
    apifun_checklhs ( "starDiscr1D" , lhs , 1 )
    apifun_checktype ( "starDiscr1D" , x , "x" , 1 , "constant" )
    apifun_checkrange("starDiscr1D",x,"x",1,0.,1.)
    apifun_checkvector("starDiscr1D" , x , "x" , 1)
    x=x(:)
    n = size(x,"*")
    i=(1:n)'
    x=gsort(x,"g","i")
    u=(2*i-1)/(2*n)
    d = 1. /(2*n) + max(abs(x-u))
endfunction 

function d=discr1D(x)
    // Compute the 1D discrepancy.
    //
    // Calling Sequence
    //   d=discr1D(x)
    //
    // Parameters
    //   x : a n-by-1 matrix of doubles, must be in [0,1], the points
    //   d : a 1-by-1 matrix of doubles, in [0,1], the discrepancy
    //
    // Description
    // Compute the discrepancy of the 1D point set x.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "discr1D" , rhs , 1 )
    apifun_checklhs ( "discr1D" , lhs , 1 )
    apifun_checktype ( "discr1D" , x , "x" , 1 , "constant" )
    apifun_checkrange("discr1D",x,"x",1,0.,1.)
    apifun_checkvector("discr1D" , x , "x" , 1)
    x=x(:)
    n = size(x,"*")
    i=(1:n)'
    x=gsort(x,"g","i")
    u=i/n
    d = 1/n + max(u-x) - min(u-x)
endfunction 

function d=squaredDiscr(x)
    // Compute the squared discrepancy (s dimensions).
    //
    // Calling Sequence
    //   d=squaredDiscr(x)
    //
    // Parameters
    //   x : a n-by-s matrix of doubles, must be in [0,1], the points
    //   d : a 1-by-1 matrix of doubles, in [0,1], the squared discrepancy
    //
    // Description
    // Compute the star discrepancy of the 1D point set x.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "starDiscr1D" , rhs , 1 )
    apifun_checklhs ( "starDiscr1D" , lhs , 1 )
    apifun_checktype ( "starDiscr1D" , x , "x" , 1 , "constant" )
    apifun_checkrange("starDiscr1D",x,"x",1,0.,1.)
    apifun_checkvector("starDiscr1D" , x , "x" , 1)
    x=x(:)
    n = size(x,"*")
    i=(1:n)'
    x=gsort(x,"g","i")
    u=(2*i-1)/(2*n)
    d = 1. /(2*n) + max(abs(x-u))
endfunction 

function x=starDiscr1DSet(n)
    // Returns the 1D point set with minimum star discrepancy.
    //
    // Calling Sequence
    //   d=starDiscr1DSet(n)
    //
    // Parameters
    //   n : a 1-by-1 matrix of doubles, the number of points
    //   x : a n-by-1 matrix of doubles, in [0,1], the points
    //
    // Description
    // Compute the 1D point set with minimum 
    // star discrepancy.
    // The points are :
    //
    // x(i)=(2*i-1)/(2n)
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "starDiscr1DSet" , rhs , 1 )
    apifun_checklhs ( "starDiscr1DSet" , lhs , 1 )
    apifun_checktype ( "starDiscr1DSet" , n , "n" , 1 , "constant" )
    apifun_checkscalar( "starDiscr1DSet" , n , "n" , 1)
    apifun_checkgreq("starDiscr1DSet",n,"n",1,1)
    apifun_checkflint("starDiscr1DSet",n,"n",1)
    i=(1:n)'
    x=(2*i-1)/(2*n)
endfunction 

function plotStarDiscr1D(x)
    // Plots the 1D star discrepancy of a point set.
    //
    // Calling Sequence
    //   plotStarDiscr1D(x)
    //
    // Parameters
    //   x : a n-by-1 matrix of doubles, must be in [0,1], the points
    //
    // Description
    // Plots the star discrepancy of the 1D point set x 
    // and the point set versus the optimal point set.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs("plotStarDiscr1D" , rhs , 1 )
    apifun_checklhs("plotStarDiscr1D" , lhs , 1 )
    apifun_checktype ( "plotStarDiscr1D" , x , "x" , 1 , "constant" )
    apifun_checkvector("plotStarDiscr1D" , x , "x" , 1)
    apifun_checkrange("plotStarDiscr1D",x,"x",1,0.,1.)
    //
    d=starDiscr1D(x)
    h=scf();
    plot(x,0.,"bx")
    h.children.data_bounds(:,1)=[0;1];
    n=size(x,"*")
    u=starDiscr1DSet(n)
    plot(u,0.,"ro")
    legend(["Point Set","Optimal Point Set"])
    str=msprintf("Star Discrepancy:%f, N=%d points",d,n)
    xtitle(str,"X")
endfunction


//
// Print discrepancy of a point set
x = [0.1,0.2,0.3,0.7]
disp("x=")
disp(x)
mprintf("D*(x)=%f\n",starDiscr1D(x))
mprintf("D(x)=%f\n",discr1D(x))
//
// Print discrepancy of a random point set
x=grand(10,1,"def");
disp("x=")
disp(x)
mprintf("D*(x)=%f\n",starDiscr1D(x))
mprintf("D(x)=%f\n",discr1D(x))

//
// Plot discrepancy of a point set
x = [0.1,0.2,0.3,0.7]
plotStarDiscr1D(x)
//
// Plot discrepancy of a random point set
x=grand(10,1,"def");
plotStarDiscr1D(x)
//
// Plot discrepancy of Van Der Corput point set
x=lowdisc_ldgen(7,1);
plotStarDiscr1D(x)

//
// Compute discrepancy of random point sets
h=scf();
nmax=5;
xtitle("Star Discrepancy of 1D Random Point Set","N","Star Discrepancy")
n=logspace(1,nmax,10);
plot(n,n.^(-0.5),"r-")
b=2;
c=1/(3*log(b));
plot(n,(c*log(n))./n,"g-")
h.children.log_flags="lln";
lds = lowdisc_new("halton");
lds = lowdisc_startup (lds);
for n=logspace(1,nmax,10)
    n=int(n)
    for i=1:20
        //
        // Plot discrepancy of Van Der Corput sequence of N points
        [lds,x] = lowdisc_next (lds,n);
        d=starDiscr1D(x);
        plot(n,d,"g+")
        //
        // Random points
        x=grand(n,1,"def");
        d=starDiscr1D(x);
        mprintf("n=%d, d=%f\n",n,d)
        plot(n,d,"bo")
    end
end
lds = lowdisc_destroy(lds);
legend(["$1/\sqrt{n}$","$c\log(n)/n$","Van Der Corput","Random"]);
h.children.data_bounds(:,1)=[5;10**(nmax+0.5)];
