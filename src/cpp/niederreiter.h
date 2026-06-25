// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_NIEDER_D_H_
#define _LOWDISC_NIEDER_D_H_

#ifdef _MSC_VER
#if LIBLOWDISC_EXPORTS 
#define LOWDISC_IMPORTEXPORT __declspec (dllexport)
#else
#define LOWDISC_IMPORTEXPORT __declspec (dllimport)
#endif
#else
#define LOWDISC_IMPORTEXPORT
#endif

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

__BEGIN_DECLS

	#include <stdio.h>

	//! Class of Niederreiter Sequence
class LOWDISC_IMPORTEXPORT Niederreiter {
public:

	// Constructor
	//   Startup the Niederreiter sequence.
	//   TODO : allocate the memory instead of static arrays
	//
	//  Parameters:
	//
	//    Input, int DIM_NUM, the spatial dimension.
	//
	//    Input, int BASE, the base to use for the Niederreiter sequence.
	//    The base should be a prime, or a power of a prime.
	//
	//    skip : the number of elements to skip in the sequence
	//
	//    gfaritfile : the gfarit.txt file to use
	//
	//    gfplysfile : the gfplys.txt file to use
	//
	Niederreiter ( int dim_num, int base, int skip , char * gfaritfile , char * gfplysfile );

	// Destructor
	//   Stop the Niederreiter sequence.
	//   TODO : de-allocate the memory (obviously after the first fix : allocate the memory).
	//
	~Niederreiter ( );

	// next --
	// returns an element of a Niederreiter sequence for base BASE.
	//
	//  Parameters:
	//
	//    Input/output, int *SEED, a seed for the random number generator.
	//
	//    Output, double quasi[DIM_NUM], the element of the sequence.
	//
	void next ( double r[] );

	// Returns the number of dimensions in the sequence
	int dim_num_get ( );

	// Returns the base of the sequence
	int base_get ( );

	// Returns the skip of the sequence
	int skip_get ( );

	// Returns true if the sequence is started up
	bool isstart ( );
private:

	//
	//  Purpose:
	//
	//    CALCC calculates the value of the constants C(I,J,R).
	//
	//  Discussion:
	//
	//    This routine calculates the values of the constants C(I,J,R).
	//    As far as possible, we use Niederreiter's notation.
	//    We calculate the values of C for each I in turn.
	//    When all the values of C have been calculated, we return
	//    this array to the calling program.
	//
	//    Irreducible polynomials are read from file "gfplys.txt"
	//    This file should have been created earlier by running the
	//    GFPLYS program.
	//
	//    Polynomials stored as arrays have the coefficient of degree n 
	//    in POLY(N), and the degree of the polynomial in POLY(-1).  
	//    The parameter DEG is just to remind us of this last fact.  
	//    A polynomial which is identically 0 is given degree -1.
	//
	// Parameters
	//    gfplysfile : the file to read (e.g. "gfplys.txt")
	//    ierr = 0 in case of error, 1 if OK.
	//
	//  Local Parameters:
	//
	//    Local, int MAXE; we need nieder_DIM_MAX irreducible polynomials over GF(Q).
	//    MAXE is the highest degree among these.
	//
	//    Local, int V_MAX, the maximum index used in V.
	//
	//    Local, int NPOLS, the number of precalculated irreducible polynomials.
	//
	int calcc ( char * gfplysfile );


	//
	//  Purpose:
	//
	//    CALCV calculates the constants V(J,R).
	//
	//  Discussion:
	//
	//    This program calculates the values of the constants V(J,R) as
	//    described in Bratley, Fox and Niederreiter, section 3.3.  It 
	//    is called from either CALCC or CALCC2.  The values transmitted 
	//    through common /FIELD/ determine which field we are working in.
	//
	//    Polynomials stored as arrays have the coefficient of degree n 
	//    in POLY(N), and the degree of the polynomial in POLY(-1).  The 
	//    parameter DEG is just to remind us of this last fact.  A polynomial 
	//    which is identically 0 is given degree -1.
	//
	//  Parameters:
	//
	//    Input, int PX[MAXDEG+2], the appropriate irreducible polynomial 
	//    for the dimension currently being considered.  The degree of PX will 
	//    be called E.
	//
	//    Input/output, int B[nieder_DEG_MAX+2].  On input, B is the polynomial 
	//    defined in section 2.3 of BFN.  The degree of B implicitly defines 
	//    the parameter J of section 3.3, by degree(B) = E*(J-1).  On output, 
	//    B has been multiplied by PX, so its degree is now E*J.
	//
	//    Input, int V[V_MAX+1], contains the values required.
	//
	//    Input, int V_MAX, the dimension of the array V.
	//
	//  Local Parameters:
	//
	//    Local, int ARBIT, indicates where the user can place
	//    an arbitrary element of the field of order Q.  For the code,
	//    this means 0 <= ARBIT < Q.  Within these limits, the user can 
	//    do what he likes.  ARBIT could be declared as a function 
	//    that returned a different arbitrary value each time it is referenced.
	//
	//    Local, int BIGM, is the M used in section 3.3.  It differs from 
	//    the [little] m used in section 2.3, denoted here by M.
	//
	//    Local, int NONZER shows where the user must put an arbitrary 
	//    non-zero element of the same field.  For the code, this means 
	//    0 < NONZER < Q.  Within these limits, the user can do what he likes.  
	//
	void calcv ( int px[], int b[], int v[], int v_max );

	//  Purpose:
	//
	//    GOLO generates a new quasi-random vector on each call.
	//
	//  Discussion:
	//
	//    Before the first call to this routine, a call must be made
	//    to subroutine INLO to carry out some initializations.
	//
	//    Polynomials stored as arrays have the coefficient of degree n 
	//    in POLY(N), and the degree of the polynomial in POLY(-1).  
	//    The parameter DEG is just to remind us of this last fact.  
	//    A polynomial which is identically 0 is given degree -1.
	//
	//  Parameters:
	//
	//    Output, double QUASI[], the next vector in the sequence.
	//
	void golo ( double quasi[] );

	//  Purpose:
	//
	//    I4_CHARACTERISTIC gives the characteristic for an integer.
	//
	//  Discussion:
	//
	//    For any positive integer Q, the characteristic is:
	//
	//    Q, if Q is a prime;
	//    P, if Q = P^N for some prime P and some integer N;
	//    0, otherwise, that is, if Q is negative, 0, 1, or the product
	//       of more than one distinct prime.
	//
	//  Parameters:
	//
	//    Input, int Q, the value to be tested.
	//
	//    Output, int I4_CHARACTERISTIC, the characteristic of Q.
	//
	int i4_characteristic ( int q );


	//
	//  Purpose:
	//
	//    FIND seeks the value N in the range TAB(I) to TAB(TAB_MAX).
	//
	//  Discussion:
	//
	//    The vector TAB does not have to be sorted or have any other
	//    special properties.
	//
	//  Parameters:
	//
	//    Input, int N, the value being sought.
	//
	//    Input, int TAB[], the table to be searched.
	//
	//    Input, int I, TAB_MAX, the first and last entries of
	//    TAB to be examined.
	//
	//    Output, int FIND, is the index ( between I and TAB_MAX) of the 
	//    entry in TAB that is equal to N, or else -1 if no such value
	//    was found.
	//
	int find ( int n, int tab[], int i, int tab_max );
	//
	//  Purpose:
	//
	//    INLO calculates the values of C(I,J,R).
	//
	//  Discussion:
	//
	//    This subroutine calculates the values of Niederreiter's
	//    C(I,J,R) and performs other initialization necessary
	//    before calling GOLO.
	//
	//    Polynomials stored as arrays have the coefficient of degree n 
	//    in POLY(N), and the degree of the polynomial in POLY(-1).  
	//    The parameter DEG is just to remind us of this last fact.  
	//    A polynomial which is identically 0 is given degree -1.
	//
	//  Parameters:
	//
	//    Input, int DIM, the dimension of the sequence to be generated.
	//    The value of DIM is copied into DIMEN in the common block.
	//
	//    Input, int BASE, the prime or prime-power base to be used.
	//
	//    Input, int SKIP, the number of values to throw away at the 
	//    beginning of the sequence.
	//
	//    ierr = 0 in case of error, 1 if OK.
	//
	//  Local Parameters:
	//
	//    Local, int NBITS, the number of bits in a fixed-point integer, not
	//    counting the sign.
	//
	int inlo ( int dim, int base, int skip , char * gfaritfile , char * gfplysfile );


	//
	//  Purpose:
	//
	//    PLYMUL multiplies one polynomial by another.
	//
	//  Discussion:
	//
	//    Polynomial coefficients are elements of the field of order Q.
	//
	//  Parameters:
	//
	//    Input, int PA[nieder_DEG_MAX+2], the first polynomial.
	//
	//    Input, int PB[nieder_DEG_MAX+2], the second polynomial.
	//
	//    Output, int PLYMUL[nieder_DEG_MAX+2], the product polynomial.
	//
	int *plymul ( int pa[], int pb[] );


	//
	//  Purpose: 
	//
	//    SETFLD sets up the arithmetic tables for a finite field.
	//
	//  Discussion:
	//
	//    This subroutine sets up addition, multiplication, and
	//    subtraction tables for the finite field of order QIN.
	//
	//    A polynomial with coefficients A(*) in the field of order Q
	//    can also be stored in an integer I, with
	//
	//      I = AN*Q**N + ... + A0.
	//
	//  Parameters
	//    gfaritfile : the file to read, e.g. "gfarit.txt"
	//    ierr = 0 in case of error, 1 if OK.
	//
	//  Parameters:
	//
	//    Input, int Q_INIT, the order of the field.
	//
	int setfld ( int q , char * gfaritfile );


	//
	//  Purpose:
	//
	//    GFTAB computes and writes data for a particular field size Q_INIT.
	//
	//  Discussion:
	//
	//    A polynomial with coefficients A(*) in the field of order Q
	//    can also be stored in an integer I, with
	//
	//      I = AN*Q**N + ... + A0.
	//
	//    Polynomials stored as arrays have the
	//    coefficient of degree n in POLY(N), and the degree of the
	//    polynomial in POLY(-1).  The parameter DEG is just to remind
	//    us of this last fact.  A polynomial which is identically 0
	//    is given degree -1.
	//
	//    IRRPLY holds irreducible polynomials for constructing
	//    prime-power fields.  IRRPLY(-2,I) says which field this
	//    row is used for, and then the rest of the row is a
	//    polynomial (with the degree in IRRPLY(-1,I) as usual).
	//    The chosen irreducible poly is copied into MODPLY for use.
	//
	//  Parameters:
	//
	//    Input, ofstream &OUTPUT, a reference to the output stream.
	//
	//    Input, int Q_INIT, the order of the field for which the
	//    addition and multiplication tables are needed.
	//
	//    ierr: 0 in case of problem, 1 if OK.
	//
	int gftab ( FILE * output, int q_init , char * gfaritfile );

	//
	//  Purpose:
	//
	//    ITOP converts an integer to a polynomial in the field of order P.
	//
	//  Discussion:
	//
	//    A nonnegative integer IN can be decomposed into a polynomial in
	//    powers of Q, with coefficients between 0 and Q-1, by setting:
	//
	//      J = 0
	//      do while ( 0 < IN )
	//        POLY(J) = mod ( IN, Q )
	//        J = J + 1
	//        IN = IN / Q
	//      end do
	//   A polynomial can also be stored in an integer I, with
	//        I = AN*Q**N + ... + A0.
	//   Routines ITOP and PTOI convert between these two formats.
	//
	//  Parameters:
	//
	//    Input, int IN, the (nonnegative) integer containing the 
	//    polynomial information.
	//
	//    Input, int P, the order of the field.
	//
	//    Output, int ITOP[DEG_MAX+2], the polynomial information.
	//    ITOP[0] contains the degree of the polynomial.  ITOP[I+1] contains
	//    the coefficient of degree I.  Each coefficient is an element of
	//    the field of order P; in other words, each coefficient is
	//    between 0 and P-1.
	//
	// MB, 21/05/2010 : weird, in Burkardt's gfplys.C itop has 1 input arg, in gfarit.C itop has 2 input args, in TOMS/GFARIT and TOMS/GFPLSYS ITOP has 2 input args
	// MB, 21/05/2010 : weird, in Burkardt's this is p, in TOMS this is q
	int *itop ( int in );

	//
	//  Purpose:
	//
	//    PTOI converts a polynomial in the field of order Q to an integer.
	//
	//  Discussion:
	//
	//    A polynomial with coefficients A(*) in the field of order Q
	//    can also be stored in an integer I, with
	//
	//      I = AN*Q**N + ... + A0.
	//
	//  Parameters:
	//
	//    Input, int POLY[DEG_MAX+2], the polynomial information.
	//    POLY[0] contains the degree of the polynomial.  POLY[I] contains
	//    the coefficient of degree I-1.  Each coefficient is an element of
	//    the field of order Q; in other words, each coefficient is
	//    between 0 and Q-1.
	//
	//    Input, int Q, the order of the field.
	//
	//    Output, int PTOI, the (nonnegative) integer containing the 
	//    polynomial information.
	//
	// MB, 21/05/2010 : same comment as in ptoi 2 args in Burkardt's instead of 1 in TOMS
	//
	int ptoi ( int poly[] );


	//
	//  Purpose:
	//
	//    PLYADD adds two polynomials.
	//
	//  Discussion:
	//
	//    POLY[0] contains the degree of the polynomial.  POLY[I+1] contains
	//    the coefficient of degree I.  Each coefficient is an element of
	//    the field of order Q; in other words, each coefficient is
	//    between 0 and Q-1.
	//
	//  Parameters:
	//
	//    Input, int PA[DEG_MAX+2], the first polynomial.
	//
	//    Input, int PB[DEG_MAX+2], the second polynomial.
	//
	//    Output, int PLYADD[DEG_MAX+2], the sum polynomial.
	//
	int *plyadd ( int pa[], int pb[] );

	//
	//  Purpose:
	//
	//    PLYDIV divides one polynomial by another.
	//
	//  Discussion:
	//
	//    Polynomial coefficients are elements of the field of order Q.
	//
	//  Parameters:
	//
	//    Input, int PA[DEG_MAX+2], the first polynomial.
	//
	//    Input, int PB[DEG_MAX+2], the second polynomial.
	//
	//    Output, int PQ[DEG_MAX+2], the quotient polynomial.
	//
	//    Output, int PR[DEG_MAX+2], the remainder polynomial.
	//
	//    ierr = 0 in case of error, 1 if OK.
	int plydiv ( int pa[], int pb[], int pq[], int pr[] );

	//
	//  Purpose:
	//
	//    IRRED computes and writes out a set of irreducible polynomials.
	//
	//  Discussion:
	//
	//    We find the irreducible polynomials using a sieve.  
	//
	//    Polynomials stored as arrays have the coefficient of degree n in 
	//    POLY(N), and the degree of the polynomial in POLY(-1).  The parameter
	//    DEG is just to remind us of this last fact.  A polynomial which is
	//    identically 0 is given degree -1.
	//
	//  Parameters:
	//
	//    Input, ofstream &OUTPUT, a reference to the output stream.
	//
	//    Input, int Q_INIT, the order of the field.
	//
	//    ierr = 0 in case of error, 1 if OK.
	//
	//  Local Parameters:
	//
	//    Local, int SIEVE_MAX, the size of the sieve.  
	//
	//    Array MONPOL holds monic polynomials.
	//
	//    Array SIEVE says whether the polynomial is still OK.
	//
	//    Local, int NPOLS, the number of irreducible polynomials to
	//    be calculated for a given field.
	//
	int irred ( FILE * output, int q_init , char * gfaritfile );

	//
	//  Purpose:
	//
	//    MAIN is the main program for GFARIT.
	//
	//  Discussion:
	//
	//    GFARIT writes the arithmetic tables called "gfarit.txt".
	//
	//    The program calculates addition and multiplication tables
	//    for arithmetic in finite fields, and writes them out to
	//    the file "gfarit.txt".  Tables are only calculated for fields
	//    of prime-power order Q, the other cases being trivial.
	//
	//    For each value of Q, the file contains first Q, then the
	//    addition table, and lastly the multiplication table.
	//
	//    After "gfarit.txt" has been set up, run GFPLYS to set up 
	//    the file "gfplys.txt".  That operation requires reading 
	//    "gfarit.txt".  
	//
	//    The files "gfarit.txt" and "gfplys.txt" should be saved 
	//    for future use.  
	//
	//    Thus, a user needs to run GFARIT and GFPLYS just once,
	//    before running the set of programs associated with GENIN.  
	//
	//  Parameters
	//    gfaritfile : the file to write, e.g. "gfarit.txt"
	//    ierr: 0 in case of error, 1 if OK.
	//
	int GFARIT ( char * gfaritfile );

	//
	//  Purpose:
	//
	//    MAIN is the main program for GFPLYS.
	//
	//  Discussion:
	//
	//    GFPLYS writes out data about irreducible polynomials.
	//
	//    The program calculates irreducible polynomials for various
	//    finite fields, and writes them out to the file "gfplys.txt".
	//
	//    Finite field arithmetic is carried out with the help of
	//    precalculated addition and multiplication tables found on
	//    the file "gfarit.txt".  This file should have been computed
	//    and written by the program GFARIT.
	//
	//    The format of the irreducible polynomials on the output file is
	//
	//      Q
	//      d1   a(1)  a(2) ... a(d1)
	//      d2   b(1)  b(2) ... b(d2)
	//      ...
	//
	//    where 
	//
	//      Q is the order of the field, 
	//      d1 is the degree of the first irreducible polynomial, 
	//      a(1), a(2), ..., a(d1) are its coefficients.
	//
	//    Polynomials stored as arrays have the coefficient of degree N in 
	//    POLY(N), and the degree of the polynomial in POLY(-1).  The parameter
	//    DEG is just to remind us of this last fact.  A polynomial which is
	//    identically 0 is given degree -1.
	//
	//  Parameters
	//    gfaritfile : e.g. gfarit.txt
	//    gfplysfile, output file : the name of the file to write, e.g. "gfplys.txt"
	//    ierr = 0 in case of error, 1 if OK.
	//
	int GFPLYS ( char * gfaritfile , char * gfplysfile );
	//
	//  GLOBAL DATA "/FIELD/"
	//
	//    The following GLOBAL data, used by many functions,
	//    gives the order Q of a field, its characteristic P, and its
	//    addition, multiplication, and subtraction tables.
	//
	//    Global, int nieder_DEG_MAX, the maximum degree of the polynomials
	//    to be considered.
	//
	//    Global, int P, the characteristic of the field.
	//
	//    Global, int Q, the order of the field.
	//
	//    Global, int nieder_Q_MAX, the order of the largest field to
	//    be handled.
	//
	//    Global, int ADD[nieder_Q_MAX][nieder_Q_MAX], the field addition table. 
	//
	//    Global, int MUL[nieder_Q_MAX][nieder_Q_MAX], the field multiplication table. 
	//
	//    Global, int SUB[nieder_Q_MAX][nieder_Q_MAX], the field subtraction table.
	//
	int nieder_P;
	int nieder_Q;
	static const int nieder_DEG_MAX = 50;
	static const int nieder_Q_MAX = 50;
	int nieder_add[nieder_Q_MAX][nieder_Q_MAX];
	int nieder_mul[nieder_Q_MAX][nieder_Q_MAX];
	int nieder_sub[nieder_Q_MAX][nieder_Q_MAX];
	//
	//  GLOBAL DATA "/COMM/"
	//
	//    Global, int C[nieder_DIM_MAX,nieder_FIG_MAX,0:nieder_FIG_MAX-1], the values of 
	//    Niederreiter's C(I,J,R).
	//
	//    Global, int COUNT[0:nieder_FIG_MAX-1], the index of the current item 
	//    in the sequence, expressed as an array of base-Q digits.  COUNT(R)
	//    is the same as Niederreiter's AR(N) (page 54) except that N is implicit.
	//
	//    Global, int D[nieder_DIM_MAX][nieder_FIG_MAX].
	//
	//    Global, int DIMEN, the dimension of the sequence to be generated.
	//
	//    Global, int NEXTQ[nieder_DIM_MAX], the numerators of the next item in 
	//    the series.  These are like Niederreiter's XI(N) (page 54) except that
	//    N is implicit, and the NEXTQ are integers.  To obtain the values of 
	//    XI(N), multiply by RECIP.
	//
	//    Global, int NFIGS, the number of base Q digits we are using.
	//
	//    Global, int QPOW[nieder_FIG_MAX], to speed things up a bit. 
	//    QPOW(I) = Q ** (NFIGS-I).
	//
	//    Global, double RECIP = 1.0 / Q^NFIGS.
	//
	static const int nieder_DIM_MAX = 50;
	static const int nieder_FIG_MAX = 20;
	int nieder_C[nieder_DIM_MAX][nieder_FIG_MAX][nieder_FIG_MAX];
	int nieder_COUNT[nieder_FIG_MAX];
	int nieder_D[nieder_DIM_MAX][nieder_FIG_MAX];
	int nieder_DIMEN;
	int nieder_BASE;
	int nieder_SKIP;
	int nieder_NEXTQ[nieder_DIM_MAX];
	int nieder_NFIGS;
	int nieder_QPOW[nieder_FIG_MAX];
	double nieder_RECIP;
	//    NPOLS, the number of precalculated irreducible polynomials.
	//    One different polynomial is used for each dimension.
	//    Hence, NPOLS  = DIM_MAX
	static const int nieder_NPOLS = nieder_DIM_MAX;
	//    We need nieder_DIM_MAX irreducible polynomials over GF(Q).
	//    MAXE is the highest degree among these.
	// MB, 03/06/2010 : updated from maxe=5 to maxe=7. On line #25 of irrtabs.dat, e=7 and 1  1  0  0  0  0  0  1 corresponds to px[1] to px[8]
	// MB, 08/06/2010 : updated to MAXE=8. This is the largest degree of the polynomial associated with base 2.
	static const int nieder_MAXE = 8;

	// init --
	// Initialize private fields.
	void init ( );

	// initDataFiles --
	//   Create the Niederreiter data files.
	//
	//  Parameters:
	//
	//    gfaritfile : the gfarit.txt file to use
	//
	//    gfplysfile : the gfplys.txt file to use
	//
	void initDataFiles ( char * gfaritfile , char * gfplysfile );

};

__END_DECLS


#endif /* _LOWDISC_NIEDER_D_H_ */

