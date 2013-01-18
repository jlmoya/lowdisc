// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

function lowdisc_demotmsnets()

mprintf("Present the (t,m,s)-nets and (t,s)-sequences properties \n")
mprintf("of low discrepancy sequences.")

// References
//
// "Sur le calcul et la majoration de la discrepance a l’origine", 
// These, Eric Thiemard, Lausanne, EPFL, 2000
// Section 4.6 "Les(t,s)-suites et les(t,m,s)-reseaux.
// and Fig 4.7
//
// "Random number generation and quasi-Monte Carlo methods", 
// H. Niederreiter, CBMS-NSF Series in Applied Mathematics, No. 63, 
// SIAM, Philadelphia, 1992.
// 
// "Monte-Carlo methods in Financial Engineering", 
// Paul Glasserman, Springer, 2003
// See Section 5.1.4 "Nets and sequences", 
// and Fig. 5.3, page 292

//
// Applications of Scrambled Low Discrepancy Sequences to Exotic Options
// KS Tan, PP Boyle
// International AFIR Colloquium Proceedings, Australia, 1997

// Definition: Elementary interval in one dimension
// Let b be the base, with b>=2. 
// An elementary interval in base b is an interval [a/b^d,(a+1)/b^d]
// with integers a and d such that d>=0 and 0<= a < b^d.

// Definition: Elementary interval in base b in s dimensions
// Let b be the base, with b>=2. 
// An elementary interval in base b is an interval 
// [a_i/b^d_i,(a_i+1)/b^d_i]
// with integers a_i and d such that d>=0 and 0<= a_i < b^d_i, 
// for i=1,2,...,s.

// Corollary: Volume of an elementary interval in base b
// The volume of E is 1/b^{d_1+d_2+...+d_s}.

// Definition: (t,m,s)-net in base b
// Let b>=2, s>=1 and 0<=t<=m be integers. 
// Then a point set with b^m points in [0,1]^s is a (t,m,s)-net 
// in base b if every elementary interval in base b 
// with volume 1/b^{m-t} contains exactly b^t points.

// Corollary: (0,m,s)-net in base b
// Let b>=2, s>=1 be integers. 
// Then a point set with b^m points in [0,1]^s is a (0,m,s)-net 
// in base b if every elementary interval in base b 
// with volume 1/b^m contains exactly one point.

// Definition : (t,s)-sequence in base b
// Let b>=2, s>=1 and t>=0 be integers.
// Then the infinite sequence x_0, x_1, ... of points in [0,1]^s 
// is a (t,s) sequence in base b if, 
// for all k>=0 and m>=t, the point set x_{kb^m},x_{kb^m+1},...,x_{(k+1)b^m} 
// is a (t,m,s)-net in base b.

// Comment: Smaller t provides a greater uniformity.

// Comment: A smaller base b is preferable because the 
// uniformity properties of (t,m,s)-nets and (t,s)-sequences are exhibited
// in sets of b^m elementary intervals. 

// Theorem:
// * Van der Corput in base b are (0,1)-nets in base b.
// * Halton sequences are not (t,s)-nets: the base b is not 
//   the same for all dimensions.
// * Sobol sequence is a (t,s)-sequence in base 2 with t=O(slogs).
//   Sobol sequence use the same base b=2 for all dimensions.
// * The Faure sequences are (0,s)-sequences in base b. 
//   Therefore, the Faure sequences are (0,m,s)-nets in 
//   base b, for any m>=1.
//   Therefore, Faure sequences achieve the lowest possible 
//   value of t, but with increasing b (the smallest prime larger than s).
// * Niederreiter sequences are (0,s)-nets defined for any base b, 
//   where b is a power ofa prime.

// Quality parameters t of binary (t,s)-sequences
// s    1 2 3 4 5 6 7  8  9  10 11 12 13 14
// Sob  0 0 1 3 5 8 11 15 19 23 27 31 35 40
// Nie  0 0 1 3 5 8 11 14 18 22 26 30 34 38


// ////////////////////////////////////////////////
// 
// Halton
//

mprintf("Halton\n")

// Get the points 0,1,...,11 (insert zero)
[ u , evalf ] = lowdisc_ldgen ( 11 , 2 , "haltonf" , %t );
u = [0,0;u];
//
h = scf();
plot(u(:,1),u(:,2),"bo")
lowdisc_plotelembox([2 3],[2 1])
h.children.title.text="Halton, Volume=1/12, 12 Points";
//
h = scf();
plot(u(:,1),u(:,2),"bo")
lowdisc_plotelembox([2 3],[1 1])
h.children.title.text="Halton, Volume=1/6, 12 Points";

// ////////////////////////////////////////////////
// 
// Faure
//

mprintf("Faure\n")

// Get the points 0,1,...,15 (insert zero)
[ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 , "fauref" , %t );
u = [0,0;u];

// Faure is (0,3,2)-net in base 2
h = scf();
plot(u(1:8,1),u(1:8,2),"bo")
plot(u(9:16,1),u(9:16,2),"g*")
legend(["Points 1-8","Points 9-16"]);
lowdisc_plotelembox(2,[3 0]);
h.children.title.text="Faure, Volume=1/8, 16 Points";

// Faure is (0,3,2)-net in base 2
h = scf();
plot(u(1:8,1),u(1:8,2),"bo")
plot(u(9:16,1),u(9:16,2),"g*")
legend(["Points 1-8","Points 9-16"]);
lowdisc_plotelembox(2,[2 1]);
h.children.title.text="Faure, Volume=1/8, 16 Points";


// Plot elementary intervals with Faure points (insert zero)
// Plot elementary intervals with volume 2^3:
// 2 points by box.
[ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 , "fauref" , %t );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,3,u);
//
// Plot elementary intervals with Faure points (insert zero)
// Plot elementary intervals with volume 2^4
// 1 point by box.
[ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 , "fauref" , %t );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,4,u);

//////////////////////////////////////////////////
// 
// Niederreiter, base 2
//

mprintf("Niederreiter, base 2\n")

// Plot elementary intervals with Niederreiter points (insert zero)
// Plot elementary intervals with volume 2^4:
// 2 points by elementary interval.
// Niederreiter is a (0,5,2)-net in base 2
[ u , evalf ] = lowdisc_ldgen ( 2^5-1 , 2 , "niederreiter-base-2" , %t );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,4,u);

// Plot elementary intervals with Niederreiter points (insert zero)
// Plot elementary intervals with volume 2^3:
// 4 points by elementary interval.
// Niederreiter is a (0,5,2)-net in base 2
[ u , evalf ] = lowdisc_ldgen ( 2^5-1 , 2 , "niederreiter-base-2" , %t );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,3,u);

//////////////////////////////////////////////////
// 
// Sobol
//

mprintf("Sobol\n")


// Sobol is a (0,4,2)-net in base 2.
// Get 2^4=16 points (insert zero)
// Plot boxes with volume 2^4.
// There is 1 point by box.
// Use 2^2 subdivisions for X1, 
// 2^2 subdivisions for X2.
[ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 , "sobolf" , %t );
u = [0,0;u];
h = scf();
plot(u(:,1),u(:,2),"bo")
legend(["Points 1-16"]);
lowdisc_plotelembox(2,[2 2]);
h.children.title.text="Sobol, Volume=1/16, 16 Points";

// Sobol is a (0,5,2)-net in base 2.
// Get 2^6 points (insert zero)
// Plot boxes with volume 2^5.
// There are two points by box.
// Use 2^3 subdivisions for X1, 
// 2^2 subdivisions for X2.
[ u , evalf ] = lowdisc_ldgen ( 2^6-1 , 2 , "sobolf" , %t );
u = [0,0;u];
h = scf();
plot(u(1:2^5,1),u(1:2^5,2),"bo")
plot(u(2^5+1:2^6,1),u(2^5+1:2^6,2),"g*")
legend(["Points 1-32","Points 33-64"]);
lowdisc_plotelembox(2,[3 2]);
h.children.title.text="Sobol, Volume=1/32, 64 Points";

//
// Load this script into the editor
//
filename = "tms_nets.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

endfunction 
lowdisc_demotmsnets();
clear lowdisc_demotmsnets
