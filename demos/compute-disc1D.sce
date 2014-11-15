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
// Eric Thiemard, 2000, 
// Thèse, Ecole Polytechnique Fédérale de Lausanne
//
// B. Vandewoestyne and R. Cools, 
// "Good permutations for deterministic scrambled Halton 
// sequences in terms of L2-discrepancy", 
// Computational and Applied Mathematics 189, 2006.

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

function d=l2StarDiscr(x)
    // Compute the L2 star discrepancy (s dimensions).
    //
    // Calling Sequence
    //   d=l2StarDiscr(x)
    //
    // Parameters
    //   x : a n-by-s matrix of doubles, must be in [0,1], the points
    //   d : a 1-by-1 matrix of doubles, in [0,1], the L2 star discrepancy
    //
    // Description
    // Compute the L2 star discrepancy of the 1D point set x.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "l2StarDiscr" , rhs , 1 )
    apifun_checklhs ( "l2StarDiscr" , lhs , 1 )
    apifun_checktype ( "l2StarDiscr" , x , "x" , 1 , "constant" )
    apifun_checkrange("l2StarDiscr",x,"x",1,0.,1.)
    n = size(x,"r")
    s = size(x,"c")
    // Compute term 1
    d1 = 0.
    for i=1:n
        d1=d1+prod(1-x(i,:).^2)
    end
    // Compute term 2
    d2=0
    for i=1:n
        for j=1:n
            d2=d2+prod(1-max(x(i,:),x(j,:)))
        end
    end
    // Make the sum
    d=3**(-s) - d1/(n*2**(s-1)) + d2/n**2
    d=sqrt(d)
    // This function has not been tested yet.
    ERROR !
endfunction 

function mu=l2StarDiscrAverage(n,s)
    // Compute the average L2 star discrepancy.
    //
    // Calling Sequence
    //   mu=l2StarDiscrAverage(n,s)
    //
    // Parameters
    //   n : a 1-by-1 matrix of doubles, the number of points
    //   s : a 1-by-1 matrix of doubles, the number of dimensions
    //   mu : a 1-by-1 matrix of doubles, the expected value of the L2 star discrepancy
    //
    // Description
    // Compute the average L2 star discrepancy of a uniformly 
    // random point set of n points in s dimensions.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "l2StarDiscrAverage" , rhs , 2 )
    apifun_checklhs ( "l2StarDiscrAverage" , lhs , 1 )
    apifun_checktype ( "l2StarDiscrAverage" , n , "n" , 1 , "constant" )
    apifun_checktype ( "l2StarDiscrAverage" , s , "s" , 2 , "constant" )
    apifun_checkgreq("l2StarDiscrAverage",n,"n",1,1.)
    apifun_checkgreq("l2StarDiscrAverage",s,"s",2,1.)
    apifun_checkscalar("l2StarDiscrAverage",n,"n",1)
    apifun_checkscalar("l2StarDiscrAverage",s,"s",2)
    mu=((2**(-s)+3**(-s))/n)**0.5
    // This function has not been tested yet.
    ERROR !
endfunction 

function mu=l2DiscrAverage(n,s)
    // Compute the average L2 discrepancy.
    //
    // Calling Sequence
    //   mu=l2StarDiscrAverage(n,s)
    //
    // Parameters
    //   n : a 1-by-1 matrix of doubles, the number of points
    //   s : a 1-by-1 matrix of doubles, the number of dimensions
    //   mu : a 1-by-1 matrix of doubles, the expected value of the L2 discrepancy
    //
    // Description
    // Compute the average L2 discrepancy of a uniformly 
    // random point set of n points in s dimensions.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "l2DiscrAverage" , rhs , 2 )
    apifun_checklhs ( "l2DiscrAverage" , lhs , 1 )
    apifun_checktype ( "l2DiscrAverage" , n , "n" , 1 , "constant" )
    apifun_checktype ( "l2DiscrAverage" , s , "s" , 2 , "constant" )
    apifun_checkgreq("l2DiscrAverage",n,"n",1,1.)
    apifun_checkgreq("l2DiscrAverage",s,"s",2,1.)
    apifun_checkscalar("l2DiscrAverage",n,"n",1)
    apifun_checkscalar("l2DiscrAverage",s,"s",2)
    mu=(6**(-s)*(1-2**(-s))/n)**0.5
    // This function has not been tested yet.
    ERROR !
endfunction 

function d=l2Discr(x)
    // Compute the L2 discrepancy (s dimensions).
    //
    // Calling Sequence
    //   d=l2Discr(x)
    //
    // Parameters
    //   x : a n-by-s matrix of doubles, must be in [0,1], the points
    //   d : a 1-by-1 matrix of doubles, in [0,1], the L2 discrepancy
    //
    // Description
    // Compute the L2 discrepancy of the 1D point set x.
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    //
    [lhs, rhs] = argn()
    apifun_checkrhs ( "l2Discr" , rhs , 1 )
    apifun_checklhs ( "l2Discr" , lhs , 1 )
    apifun_checktype ( "l2Discr" , x , "x" , 1 , "constant" )
    apifun_checkrange("l2Discr",x,"x",1,0.,1.)
    n = size(x,"r")
    s = size(x,"c")
    // Compute term 1
    d1 = 0.
    for i=1:n
        d1=d1+prod((1-x(i,:)).*x(i,:))
    end
    // Compute term 2
    d2=0
    for i=1:n
        for j=1:n
            xmax=1-max(x(i,:),x(j,:))
            xmin=min(x(i,:),x(j,:))
            d2=d2+prod(xmax.*xmin)
        end
    end
    // Make the sum
    d=12**(-s) - d1/(n*2**(s-1)) + d2/n**2
    d=sqrt(d)
    // This function has not been tested yet.
    ERROR !
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
    plot(x,zeros(x),"bx")
    h.children.data_bounds(:,1)=[0;1];
    n=size(x,"*")
    u=starDiscr1DSet(n)
    plot(u,zeros(u),"ro")
    legend(["Point Set","Optimal Point Set"])
    str=msprintf("Star Discrepancy:%f, N=%d points",d,n)
    xtitle(str,"X")
endfunction


//
// Print discrepancy of a point set
disp("Print discrepancy of a point set")
x = [0.1,0.2,0.3,0.7]
disp("x=")
disp(x)
mprintf("D*(x)=%f\n",starDiscr1D(x))
mprintf("D(x)=%f\n",discr1D(x))
//
// Print discrepancy of a random point set
disp("Print discrepancy of a random point set")
x=grand(10,1,"def");
disp("x=")
disp(x)
mprintf("D*(x)=%f\n",starDiscr1D(x))
mprintf("D(x)=%f\n",discr1D(x))

//
// Plot discrepancy of a point set
disp("Plot discrepancy of a point set")
x = [0.1,0.2,0.3,0.7]
plotStarDiscr1D(x)
//
// Plot discrepancy of a random point set
disp("Plot discrepancy of a random point set")
x=grand(10,1,"def");
plotStarDiscr1D(x)
//
// Plot discrepancy of Van Der Corput point set
disp("Plot discrepancy of Van Der Corput point set")
x=lowdisc_ldgen(7,1);
plotStarDiscr1D(x)

//
// Compute discrepancy of random point sets
// Compare with Van Der Corput sequence
disp("Compute discrepancy of random point sets")
disp("Compare with Van Der Corput sequence")
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

for n=logspace(1,nmax,10)
    n=int(n)
    for i=1:5
        //
        // Plot discrepancy of Van Der Corput sequence of N points
        [lds,x] = lowdisc_next (lds,n);
        d=starDiscr1D(x);
        plot(n,d,"g+")
        //
        // Random points
        x=grand(n,1,"def");
        d=starDiscr1D(x);
        plot(n,d,"bo")
    end
end
lds = lowdisc_destroy(lds);
legend(["$1/\sqrt{n}$","$c\log(n)/n$","Van Der Corput","Random"]);
h.children.data_bounds(:,1)=[5;10**(nmax+0.5)];
////
//// Compute the L2 star discrepancy
//x = [
//    0.0601642    0.9892722  
//    0.0213182    0.3442620  
//    0.8527724    0.3569147  
//    0.5417670    0.1203201  
//    0.9478999    0.5555390  
//    0.7633010    0.5505934  
//    0.8708863    0.9021710  
//    0.1263894    0.2506578  
//    0.7834409    0.6627451  
//    0.3419156    0.1218432  
//];
//disp("x=")
//disp(x)
//mprintf("D2*(x)=%f\n",l2StarDiscr(x))
//mprintf("D2(x)=%f\n",l2Discr(x))
//
//h=scf();
//n=20;
//s=1;
//mprintf("E(D2*(n,s)**2)=%f\n",l2StarDiscrAverage(n,s))
//mprintf("E(D2*(n,s)**2)=%f\n",l2DiscrAverage(n,s))
//
//for i=1:20
//    //
//    // Random points
//    x=grand(n,s,"def");
//    mprintf("D2*(x)=%f, D2(x)=%f\n",l2StarDiscr(x),l2Discr(x))
//    plot(0,l2StarDiscr(x)**2,"r*")
//    plot(1,l2Discr(x)**2,"bo")
//end
//h.children.data_bounds(:,1)=[-1;2];
//
//
