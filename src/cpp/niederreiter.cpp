// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate NiederreiteSoftware,
//    Volume 20, Number 4, 1994, pages 494-495.
//
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
//

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <cmath>
#include <ctime>
#include <fstream>
#include <sstream>

// Some notes by John Burkardt
// Modified:   06-11-12 September 2007
//
// GFARIT must be run first, to set up a tables of addition and multiplication.
//   This produces gfarit.txt, the data file created by the run;
//	 Handle a field of prime-power order.
//	 This file was called 'gftabs.dat' in TOMS.
//   File compared : OK (still difference of formatting : gftabs.dat uses 2 lines instead of 1 line in gfarit.txt, same content).
//
// GFPLYS must be run second, to set up a table of irreducible polynomials.
//   This produces gfplys.txt, the data file created by the run; 
//	 This file was called 'irrtabs.dat' in TOMS.
//   File compared : OK (after fixing bugs in itop and ptoi : use of nieder_Q, as in TOMS)
//
// The call to these routines is automatically done by the start routine.
using namespace std;
#include "niederreiter.h"
#include "lowdisc_shared.h"
int calcc ( char * gfplysfile );
void calcv ( int px[], int b[], int v[], int v_max );
void golo ( double quasi[] );
int i4_characteristic ( int q );
int inlo ( int dim, int base, int skip , char * gfaritfile , char * gfplysfile );
int *plymul ( int pa[], int pb[] );
int setfld ( int q , char * gfaritfile );
int gftab ( ofstream &output, int q_init , char * gfaritfile );
int *itop ( int in );
int ptoi ( int poly[] );
int *plyadd ( int pa[], int pb[] );
int plydiv ( int pa[], int pb[], int pq[], int pr[] );
int irred ( ofstream &output, int q_init , char * gfaritfile );
int GFARIT ( char * gfaritfile );
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
const int nieder_DEG_MAX = 50;
const int nieder_Q_MAX = 50;
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
const int nieder_DIM_MAX = 50;
const int nieder_FIG_MAX = 20;
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
bool nieder_startup = false;
//    NPOLS, the number of precalculated irreducible polynomials.
//    One different polynomial is used for each dimension.
//    Hence, NPOLS  = DIM_MAX
const int nieder_NPOLS = nieder_DIM_MAX;
//    We need nieder_DIM_MAX irreducible polynomials over GF(Q).
//    MAXE is the highest degree among these.
// MB, 03/06/2010 : updated from maxe=5 to maxe=7. On line #25 of irrtabs.dat, e=7 and 1  1  0  0  0  0  0  1 corresponds to px[1] to px[8]
// MB, 08/06/2010 : updated to MAXE=8. This is the largest degree of the polynomial associated with base 2.
const int nieder_MAXE = 8;


//****************************************************************************80
void niederreiter_start ( int dim_num, int base, int skip , char * gfaritfile , char * gfplysfile , bool init )
// niederreiter_start
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
//    init : if true, then the two strings are stored and the gfarit.txt and gfplys.txt are created.
//           If false, the two strings are stored, but the files are expected to already exist on disk.
//
//    ierr: 0 in case of error, 1 if OK.
//
{
	int ierr;

	if ( nieder_startup )
	{
		ostringstream msg;
		msg << "niederreiter - niederreiter_start - Error!\n";
		msg << "  Startup is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	nieder_startup = true;
	//
	if ( init ) {
		ierr = GFARIT ( gfaritfile );
		if ( ierr==0 ) {
			return;
		}
		//
		ierr = GFPLYS ( gfaritfile , gfplysfile );
		if ( ierr==0 ) {
			return;
		}
	}
	//
	nieder_BASE = base;
	nieder_SKIP = skip;
	ierr = inlo ( dim_num, base, skip , gfaritfile , gfplysfile );
	if ( ierr==0 ) {
		return;
	}
	return;
}
//****************************************************************************80
void niederreiter_stop ( )
// niederreiter_stop
//   Stop the Niederreiter sequence.
//   TODO : de-allocate the memory (obviously after the first fix : allocate the memory).
//
{
	if ( !nieder_startup )
	{
		ostringstream msg;
		msg << "niederreiter - niederreiter_stop - Error!\n";
		msg << "  Startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}
	nieder_startup = false;
	return;
}
//****************************************************************************80
void niederreiter ( double quasi[] )
//****************************************************************************80
//
//  Purpose:
//
//    NIEDERREITER returns an element of a Niederreiter sequence for base BASE.
//
//  Parameters:
//
//    Input/output, int *SEED, a seed for the random number generator.
//
//    Output, double quasi[DIM_NUM], the element of the sequence.
//
{
	if ( !nieder_startup )
	{
		ostringstream msg;
		msg << "niederreiter - niederreiter - Error!\n";
		msg << "  Startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}
	golo ( quasi );
	return;
}
//****************************************************************************80
int calcc ( char * gfplysfile )
//****************************************************************************80
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
{
	const int v_max = nieder_FIG_MAX + nieder_MAXE;
	int b[nieder_DEG_MAX+2];
	int e;
	ifstream input;
	int i;
	int j;
	int k;
	int px[nieder_MAXE+2];
	int r;
	int u;
	int v[v_max+1];
	//
	//  Read the irreducible polynomials.
	//
	input.open ( gfplysfile );
	if ( !input )
	{
		ostringstream msg;
		msg << "niederreiter - calcc - Error!\n";
		msg << "  Could not open the input file: \"" << gfplysfile << "\"\n";
		lowdisc_error(msg.str());
		return 0;
	}
	while ( true ) 
	{
		input >> i;
		if ( input.eof ( ) )
		{
			ostringstream msg;
			msg << "niederrreiter - CALCC - Error!\n"; 
			msg << "  Could not find tables for Q = " << nieder_Q << "\n";
			lowdisc_error(msg.str());
			return 0;
		}
		if ( i == nieder_Q )
		{
			break;
		}
		for ( j = 1; j <= nieder_NPOLS; j++ )
		{
			input >> e;
			for ( k = 0; k <= e; k++ )
			{
				input >> px[k+1];
			}
		}
	}
	for ( i = 0; i < nieder_DIMEN; i++ )
	{
		//
		//  For each dimension, we need to calculate powers of an
		//  appropriate irreducible polynomial.  See Niederreiter
		//  page 65, just below equation (19).
		//
		//  Read the appropriate irreducible polynomial into PX,
		//  and its degree into E.  Set polynomial B = PX^0 = 1.
		//  M is the degree of B.  Subsequently B will hold higher
		//  powers of PX.
		//
		//  The polynomial PX is stored in 'gfplys.txt' in the format
		//
		//    n  a0  a1  a2  ... an
		//
		//  where n is the degree of the polynomial and the ai are
		//  its coefficients.
		//
		input >> e;
		for ( k = 0; k <= e; k++ )
		{
			input >> px[k+1];
		}
		px[0] = e;
		b[0] = 0;
		b[1] = 1;
		//
		//  Niederreiter (page 56, after equation (7), defines two variables 
		//  Q and U.  We do not need Q explicitly, but we do need U.
		//
		u = 0;
		for ( j = 0; j < nieder_NFIGS; j++ )
		{
			//
			//  If U = 0, we need to set B to the next power of PX
			//  and recalculate V.  This is done by subroutine CALCV.
			//
			if ( u == 0 )
			{
				calcv ( px, b, v, v_max );
			}
			//
			//  Now C is obtained from V.  Neiderreiter obtains A from V 
			//  (page 65, near the bottom), and then gets C from A (page 56,
			//  equation (7)).  However this can be done in one step.
			//
			for ( r = 0; r < nieder_NFIGS; r++ )
			{
				nieder_C[i][j][r] = v[r+u];
			}
			//
			//  Increment U.  If U = E, then U = 0 and in Niederreiter's
			//  paper Q = Q + 1.  Here, however, Q is not used explicitly.
			//
			u = u + 1;
			if ( u == e )
			{
				u = 0;
			}
		}
	}
	input.close ( );
	return 1;
}
//****************************************************************************80
void calcv ( int px[], int b[], int v[], int v_max )
//****************************************************************************80
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
{
	int arbit = 1;
	int *b2;
	int bigm;
	int e;
	int h[nieder_DEG_MAX+2];
	int i;
	int j;
	int kj;
	int m;
	int nonzer = 1;
	int r;
	int term;
	e = px[0];
	//
	//  The polynomial H is PX^(J-1), which is the value of B on arrival.
	//
	//  In section 3.3, the values of Hi are defined with a minus sign:
	//  don't forget this if you use them later//
	//
	for ( i = 0; i < nieder_DEG_MAX + 2; i++ )
	{
		h[i] = b[i];
	}
	bigm = h[0];
	//
	//  Now multiply B by PX so B becomes PX^J.
	//
	//  In section 2.3, the values of Bi are defined with a minus sign:
	//  don't forget this if you use them later!
	//
	b2 = plymul ( px, b );
	for ( i = 0; i < nieder_DEG_MAX + 2; i++ )
	{
		b[i] = b2[i];
	}
	delete [] b2;
	m = b[0];
	//
	//  We don't use J explicitly anywhere, but here it is just in case.
	//
	j = m / e;
	//
	//  Now choose a value of Kj as defined in section 3.3.
	//  We must have 0 <= Kj < E*J = M.
	//  The limit condition on Kj does not seem very relevant
	//  in this program.
	//
	kj = bigm;
	//
	//  Now choose values of V in accordance with the conditions in
	//  section 3.3
	//
	for ( i = 0; i < kj; i++ )
	{
		v[i] = 0;
	}
	v[kj] = 1;
	if ( kj < bigm )
	{
		term = nieder_sub [0] [ h[kj+1] ];
		for ( r = kj + 1; r <= bigm - 1; r++ )
		{
			v[r] = arbit;
			//
			//  Check the condition of section 3.3,
			//  remembering that the H's have the opposite sign.
			//
			term = nieder_sub [ term ] [ nieder_mul [ h[r+1] ] [ v[r] ] ];
		}
		//
		//  Now V(BIGM) is anything but TERM.
		//
		v[bigm] = nieder_add [ nonzer] [ term ];
		for ( i = bigm + 1; i <= m - 1; i++ )
		{
			v[i] = arbit;
		}
	}
	else
	{
		for ( i = kj + 1; i <= m - 1; i++ )
		{
			v[i] = arbit;
		}
	}
	//
	//  Calculate the remaining V's using the recursion of section 2.3,
	//  remembering that the B's have the opposite sign.
	//
	for ( r = 0; r <= v_max - m; r++ )
	{
		term = 0;
		for ( i = 0; i <= m - 1; i++ )
		{
			term = nieder_sub [ term ] [ nieder_mul [ b[i+1] ] [ v[r+i] ] ];
		}
		v[r+m] = term;
	}
	return;
}
//****************************************************************************80
void golo ( double quasi[] )
//****************************************************************************80
//
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
{
	int diff;
	int i;
	int j;
	int nq;
	int oldcnt;
	int r;
	//
	//  Multiply the numerators in NEXTQ by RECIP to get the next
	//  quasi-random vector.
	//
	for ( i = 0; i < nieder_DIMEN; i++ )
	{
		quasi[i] = ( double ) ( nieder_NEXTQ[i] ) * nieder_RECIP;
	}
	//
	//  Update COUNT, treated as a base-Q integer.  Instead of
	//  recalculating the values of D from scratch, we update
	//  them for each digit of COUNT which changes.  In terms of
	//  Niederreiter page 54, NEXTQ(I) corresponds to XI(N), with
	//  N being implicit, and D(I,J) corresponds to XI(N,J), again
	//  with N implicit.  Finally COUNT(R) corresponds to AR(N).
	//
	r = 0;
	while ( true )
	{
		if ( nieder_NFIGS <= r )
		{
			ostringstream msg;
			msg << "niederrreiter - GOLO - Error!\n";
			msg << "  Too many calls!\n";
			lowdisc_error(msg.str());
			return;
		}
		oldcnt = nieder_COUNT[r];
		if ( nieder_COUNT[r] < nieder_Q - 1 )
		{
			nieder_COUNT[r] = nieder_COUNT[r] + 1;
		}
		else
		{
			nieder_COUNT[r] = 0;
		}
		diff = nieder_sub [ nieder_COUNT[r] ] [ oldcnt ];
		//
		//  Digit R has just changed.  DIFF says how much it changed
		//  by.  We use this to update the values of array D.
		//
		for ( i = 0; i < nieder_DIMEN; i++ )
		{
			for ( j = 0; j < nieder_NFIGS; j++ )
			{
				nieder_D[i][j] = nieder_add [ nieder_D[i][j] ] [ nieder_mul [ nieder_C[i][j][r] ] [ diff ] ];
			}
		}
		//
		//  If COUNT(R) is now zero, we must propagate the carry.
		//
		if ( nieder_COUNT[r] != 0 )
		{
			break;
		}
		r = r + 1;
	}
	//
	//  Now use the updated values of D to calculate NEXTQ.
	//  Array QPOW helps to speed things up a little:
	//  QPOW(J) is Q^(nieder_NFIGS-J).
	//
	for ( i = 0; i < nieder_DIMEN; i++ )
	{
		nq = 0;
		for ( j = 0; j < nieder_NFIGS; j++ )
		{
			nq = nq + nieder_D[i][j] * nieder_QPOW[j];
		}
		nieder_NEXTQ[i] = nq;
	}
	return;
}
//****************************************************************************80
int i4_characteristic ( int q )
//****************************************************************************80
//
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
{
	int i;
	int i_max;
	int q_copy;
	int value;
	if ( q <= 1 )
	{
		value = 0;
		return value;
	}
	//
	//  If Q is not prime, then there is at least one prime factor
	//  of Q no greater than SQRT(Q)+1.
	//
	//  A faster code would only consider prime values of I,
	//  but that entails storing a table of primes and limiting the 
	//  size of Q.  Simplicity and flexibility for now.
	//
	i_max = ( int ) ( sqrt ( ( double ) ( q ) ) ) + 1;
	q_copy = q;
	for ( i = 2; i <= i_max; i++ )
	{
		if ( ( q_copy % i ) == 0 )
		{
			while ( ( q_copy % i ) == 0 )
			{
				q_copy = q_copy / i;
			}
			if ( q_copy == 1 )
			{
				value = i;
			}
			else
			{
				value = 0;
			}
			return value;
		}
	}
	//
	//  If no factor was found, then Q is prime.
	//
	value = q;
	return value;
}
//****************************************************************************80
int inlo ( int dim, int base, int skip , char * gfaritfile , char * gfplysfile )
//****************************************************************************80
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
{
	int i;
	int j;
	int nbits = 31;
	int nq;
	int r;
	double temp;
	int ierr;
	nieder_DIMEN = dim;
	if ( nieder_DIMEN <= 0 || nieder_DIM_MAX < nieder_DIMEN )
	{
		ostringstream msg;
		msg << "niederreiter - INLO - Error!\n";
		msg << "  Bad spatial dimension.\n";
		lowdisc_error(msg.str());
		return 0;
	}
	if ( base < 1 ) 
	{
		ostringstream msg;
		msg << "niederreiter - inlo - Error!\n";
		msg << "  Base must be greater than 1.\n";
		msg << "  base = " << base << "\n";
		lowdisc_error ( msg.str() );
		return 0;
	}
	if ( i4_characteristic ( base ) == 0 )
	{
		ostringstream msg;
		msg << "niederreiter - INLO - Error!\n";
		msg << "  Base not prime power or out of range.\n";
		lowdisc_error(msg.str());
		return 0;
	}
	ierr = setfld ( base , gfaritfile );
	if ( ierr==0 ) {
		return 0;
	}
	//
	//  Calculate how many figures to use in base Q = BASE
	//
	temp = log ( pow ( 2.0, nbits ) - 1.0 ) / log ( ( double ) ( nieder_Q ) );
	nieder_NFIGS = i4_min ( nieder_FIG_MAX, ( int ) temp );
	//
	//  Calculate the C array.
	//
	ierr = calcc ( gfplysfile );
	if ( ierr==0 ) {
		return 0;
	}
	//
	//  Set RECIP.
	//
	nieder_RECIP = 1.0 / ( double ) ( i4_power ( nieder_Q, nieder_NFIGS ) );
	//
	//  Set QPOW(I) = Q^(nieder_NFIGS-I).
	//
	nieder_QPOW[nieder_NFIGS-1] = 1;
	for ( i = nieder_NFIGS - 1; 1 <= i; i-- )
	{
		nieder_QPOW[i-1] = nieder_Q * nieder_QPOW[i];
	}
	//
	//  Initialize COUNT.
	//
	if ( skip < 0 ) 
	{
		ostringstream msg;
		msg << "niederreiter - inlo - Error!\n";
		msg << "  Skip must be greater than 1.\n";
		msg << "  skip = " << skip << "\n";
		lowdisc_error ( msg.str() );
		return 0;
	}
	i = skip;
	for ( r = 0; r < nieder_NFIGS; r++ )
	{
		nieder_COUNT[r] = ( i % nieder_Q );
		i = i / nieder_Q;
	}
	if ( i != 0 )
	{
		ostringstream msg;
		msg << "niederreiter - INLO - Error!\n";
		msg << "  SKIP is too long!\n";
		lowdisc_error(msg.str());
		return 0;
	}
	//
	//  Initialize D.
	//
	for ( i = 0; i < nieder_DIMEN; i++ )
	{
		for ( j = 0; j < nieder_NFIGS; j++ )
		{
			nieder_D[i][j] = 0;
		}
	}
	for ( r = 0; r < nieder_NFIGS; r++ )
	{
		if ( nieder_COUNT[r] != 0 )
		{
			for ( i = 0; i < nieder_DIMEN; i++ )
			{
				for ( j = 0; j < nieder_NFIGS; j++ )
				{
					nieder_D[i][j] = nieder_add [ nieder_D[i][j] ] [ nieder_mul [ nieder_C[i][j][r] ] [ nieder_COUNT[r] ] ];
				}
			}
		}
	}
	//
	//  Initialize NEXTQ.
	//
	for ( i = 0; i < nieder_DIMEN; i++ )
	{
		nq = 0;
		for ( j = 0; j < nieder_NFIGS; j++ )
		{
			nq = nq + nieder_D[i][j] * nieder_QPOW[j];
		}
		nieder_NEXTQ[i] = nq;
	}
	return 1;
}
//****************************************************************************80
int *plymul ( int pa[], int pb[] )
//****************************************************************************80
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
{
	int dega;
	int degb;
	int degc;
	int i;
	int j;
	int *pc;
	int term;
	pc = new int[nieder_DEG_MAX+2];
	dega = pa[0];
	degb = pb[0];
	if ( dega == -1 || degb == -1 )
	{
		degc = -1;
	}
	else
	{
		degc = dega + degb;
	}
	if ( nieder_DEG_MAX < degc )
	{
		ostringstream msg;
		msg << "niederreiter - PLYMUL - Error!\n";
		msg << "  The degree of the product exceeds nieder_DEG_MAX.\n";
		lowdisc_error(msg.str());
		return 0;
	}
	for ( i = 0; i <= degc; i++ )
	{
		term = 0;
		for ( j = i4_max ( 0, i - dega ); j <= i4_min ( degb, i ); j++ )
		{
			term = nieder_add [ term ] [ nieder_mul [ pa[i-j+1] ] [ pb[j+1] ] ];
		}
		pc[i+1] = term;
	}
	pc[0] = degc;
	for ( i = degc + 1; i <= nieder_DEG_MAX; i++ )
	{
		pc[i+1] = 0;
	}
	return pc;
}
//****************************************************************************80
int setfld ( int q_init , char * gfaritfile )
//****************************************************************************80
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
{
	int i;
	int j;
	ifstream input;
	int n;
	if ( q_init <= 1 || nieder_Q_MAX < q_init )
	{
		ostringstream msg;
		msg << "niederreiter - SETFLD - Error!\n";
		msg << "  Bad value of Q = " << q_init << "\n";
		lowdisc_error(msg.str());
		return 0;
	}
	nieder_Q = q_init;
	nieder_P = i4_characteristic ( nieder_Q );
	if ( nieder_P == 0 )
	{
		ostringstream msg;
		msg << "niederreiter - SETFLD - Error!\n";
		msg << "  There is no field of order Q = " << nieder_Q << "\n";
		lowdisc_error(msg.str());
		return 0;
	}
	if ( nieder_P == nieder_Q )
	{
		//
		//  Set up to handle a field of prime or prime-power order.
		//  Calculate the addition and multiplication tables.
		//
		for ( i = 0; i < nieder_Q; i++ )
		{
			for ( j = 0; j < nieder_Q; j++ )
			{
				nieder_add[i][j] = ( i + j ) % nieder_P;
			}
		}
		for ( i = 0; i < nieder_Q; i++ )
		{
			for ( j = 0; j < nieder_Q; j++ )
			{
				nieder_mul[i][j] = ( i * j ) % nieder_P;
			}
		}
	}
	else
	{
		//
		//  Handle a field of prime-power order:  tables for
		//  ADD and MUL are in the file "gfarit.txt".
		//
		input.open ( gfaritfile );
		if ( !input )
		{
			ostringstream msg;
			msg << "niederreiter - SETFLD - Error!\n";
			msg << "  Could not open the input file: \"" << gfaritfile << "\"\n";
			lowdisc_error(msg.str());
			return 0;
		}
		for ( ; ; )
		{
			input >> n;
			if ( input.eof ( ) )
			{
				ostringstream msg;
				msg << "niederreiter - SETFLD - Error!\n";
				msg << "  Could not find tables for Q = " << nieder_Q << "\n";
				lowdisc_error(msg.str());
				return 0;
			}
			for ( i = 0; i < n; i++ )
			{
				for ( j = 0; j < n; j++)
				{
					input >> nieder_add[i][j];
				}
			}
			for ( i = 0; i < n; i++ )
			{
				for ( j = 0; j < n; j++)
				{
					input >> nieder_mul[i][j];
				}
			}
			if ( n == nieder_Q )
			{
				break;
			}
		}
		input.close ( );
	}
	//
	//  Use the addition table to set the subtraction table.
	//
	for ( i = 0; i < nieder_Q; i++ )
	{
		for ( j = 0; j < nieder_Q; j++ )
		{
			nieder_sub [ nieder_add[i][j] ] [i] = j;
		}
	}
	return 1;
}
//****************************************************************************80
int niederreiter_dim_num_get ( void )
//    niederreiter_dim_num_get gets the spatial dimension for a Niederreiter sequence.
{
	return nieder_DIMEN;
}
//****************************************************************************80
int niederreiter_base_get ( )
//    niederreiter_base_get gets the base for a Niederreiter sequence.
{
	return nieder_BASE;
}
//****************************************************************************80
int niederreiter_skip_get ( )
//    niederreiter_skip_get gets the skip for a Niederreiter sequence.
{
	return nieder_SKIP;
}
//***************************************************************************
//  niederreiter_isstart --
//     Returns true if the sequence is already started up.
//
//  Parameters:
//    startup, output : true if the sequence is already started up.
//
bool niederreiter_isstart ( )
{
	return nieder_startup;
}
//****************************************************************************80
int GFARIT ( char * gfaritfile )
//****************************************************************************80
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
{
	ofstream output;
	int q_init;
	int ierr;
	output.open ( gfaritfile );
	if ( !output )
	{
		ostringstream msg;
		msg << "niederreiter - GFARIT - Error!\n";
		msg << "  Could not open the output file: \"" << gfaritfile << "\"\n";
		lowdisc_error(msg.str());
		return 0;
	}
	for ( q_init = 2; q_init <= nieder_Q_MAX; q_init++ )
	{
		ierr = gftab ( output, q_init , gfaritfile );
		if ( ierr==0 ) {
			return 0;
		}
	}
	output.close ( );
	return 1;
}
//****************************************************************************80
int gftab ( ofstream &output, int q_init , char * gfaritfile )
//****************************************************************************80
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
{
	int gfadd[nieder_Q_MAX][nieder_Q_MAX];
	int gfmul[nieder_Q_MAX][nieder_Q_MAX];
	int i;
	static int irrply[8][8] = {
		{  4, 2, 1, 1, 1, 0, 0, 0 },
		{  8, 3, 1, 1, 0, 1, 0, 0 },
		{  9, 2, 1, 0, 1, 0, 0, 0 },
		{ 16, 4, 1, 1, 0, 0, 1, 0 },
		{ 25, 2, 2, 0, 1, 0, 0, 0 },
		{ 27, 3, 1, 2, 0, 1, 0, 0 },
		{ 32, 5, 1, 0, 1, 0, 0, 1 },
		{ 49, 2, 1, 0, 1, 0, 0, 0 } };
		int j;
		int modply[nieder_DEG_MAX+2];
		int *pi;
		int *pj;
		int *pk;
		int *pl;
		int ierr;
		if ( q_init <= 1 || nieder_Q_MAX < q_init )
		{
			ostringstream msg;
			msg << "niederreiter - GFTAB - Error!\n";
			msg << "  Bad value of Q_INIT.\n";
			lowdisc_error(msg.str());
			return 0;
		}
		nieder_P = i4_characteristic ( q_init );
		//
		//  If QIN is not a prime power, we are not interested.
		//
		if ( nieder_P == 0 || nieder_P == q_init )
		{
			return 1;
		}
		//
		//  Otherwise, we set up the elements of the common /FIELD/
		//  ready to do arithmetic mod P, the characteristic of Q_INIT.
		//
		// MB, 21/05/2010 : replaced setfld ( q_init ); by setfld ( nieder_P , gfaritfile ); as in TOMS/GFARIT/GFTAB, l. 182
		ierr = setfld ( nieder_P , gfaritfile );
		if ( ierr==0 ) {
			return 0;
		}
		//
		//  Next find a suitable irreducible polynomial and copy it to array MODPLY.
		//
		i = 1;
		while ( irrply[i-1][-2+2] != q_init )
		{
			i = i + 1;
		}
		for ( j = -1; j <= irrply[i-1][-1+2]; j++ )
		{
			modply[j+1] = irrply[i-1][j+2];
		}
		for ( j = irrply[i-1][-1+2]+1; j <= nieder_DEG_MAX; j++ )
		{
			modply[j+1] = 0;
		}
		//
		//  Deal with the trivial cases.
		//
		for ( i = 0; i < q_init; i++ )
		{
			gfadd[i][0] = i;
			gfadd[0][i] = i;
			gfmul[i][0] = 0;
			gfmul[0][i] = 0;
		}
		for ( i = 1; i < q_init; i++ )
		{
			gfmul[i][1] = i;
			gfmul[1][i] = i;
		}
		//
		//  Now deal with the rest.  Each integer from 1 to Q-1
		//  is treated as a polynomial with coefficients handled mod P.
		//  Multiplication of polynomials is mod MODPLY.
		//
		pl = new int[nieder_DEG_MAX+2];
		for ( i = 1; i < q_init; i++ )
		{
			pi = itop ( i );
			if ( pi == NULL ) {
				return 0;
			}
			for ( j = 1; j <= i; j++ )
			{
				pj = itop ( j );
				if ( pj == NULL ) {
					return 0;
				}
				pk = plyadd ( pi, pj );
				gfadd[i][j] = ptoi ( pk );
				gfadd[j][i] = gfadd[i][j];
				delete [] pk;
				if ( 1 < i && 1 < j )
				{
					pk = plymul ( pi, pj );
					ierr = plydiv ( pk, modply, pj, pl );
					if ( ierr == 0 ) {
						return 0;
					}
					gfmul[i][j] = ptoi ( pl );
					gfmul[j][i] = gfmul[i][j];
					delete [] pk;
				}
				delete [] pj;
			}
			delete [] pi;
		}
		delete [] pl;
		//
		//  Write out the tables.
		//
		output << " " << q_init << "\n";
		for ( i = 0; i < q_init; i++ )
		{
			for ( j = 0; j < q_init; j++ )
			{
				output << " " << gfadd[i][j];
			}
			output << "\n";
		}
		for ( i = 0; i < q_init; i++ )
		{
			for ( j = 0; j < q_init; j++ )
			{
				output << " " << gfmul[i][j];
			}
			output << "\n";
		}
		return 1;
}
//****************************************************************************80
int *itop ( int in )
//****************************************************************************80
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
{
	int i;
	int j;
	int *poly;
	poly = new int[nieder_DEG_MAX+2];
	for ( j = 0; j < nieder_DEG_MAX + 2; j++ )
	{
		poly[j] = 0;
	}
	i = in;
	j = -1;
	while ( 0 < i )
	{
		j = j + 1;
		if ( nieder_DEG_MAX < j )
		{
			ostringstream msg;
			msg << "niederreiter - ITOP - Error!\n";
			msg << "  The polynomial degree exceeds DEG_MAX.\n";
			lowdisc_error(msg.str());
			return NULL;
		}
		poly[j+1] = ( i % nieder_Q );
		i = i / nieder_Q;
	}
	poly[0] = j;
	return poly;
}
//****************************************************************************80
int *plyadd ( int pa[], int pb[] )
//****************************************************************************80
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
{
	int degc;
	int i;
	int maxab;
	int *pc;
	pc = new int[nieder_DEG_MAX+2];
	maxab = i4_max ( pa[0], pb[0] );
	degc = -1;
	for ( i = 0; i <= maxab; i++ )
	{
		pc[i+1] = nieder_add [ pa[i+1] ] [ pb[i+1] ];
		if ( pc[i+1] != 0 )
		{
			degc = i;
		}
	}
	pc[0] = degc;
	for ( i = maxab+1; i <= nieder_DEG_MAX; i++ )
	{
		pc[i+1] = 0;
	}
	return pc;
}
//****************************************************************************80
int plydiv ( int pa[], int pb[], int pq[], int pr[] )
//****************************************************************************80
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
{
	int binv;
	int d;
	int degb;
	int degq;
	int degr;
	int i;
	int j;
	int m;
	if ( pb[0] == -1 )
	{
		ostringstream msg;
		msg << "niederreiter - PLYDIV -  Error!\n";
		msg << "  Division by zero polynomial.\n";
		lowdisc_error(msg.str());
		return 0;
	}
	for ( i = -1; i <= nieder_DEG_MAX; i++ )
	{
		pq[i+1] = 0;
		pr[i+1] = pa[i+1];
	}
	degr = pa[0];
	degb = pb[0];
	degq = degr - degb;
	if ( degq < 0 )
	{
		degq = -1;
	}
	//
	//  Find the inverse of the leading coefficient of PB.
	//
	j = pb[degb+1];
	for ( i = 1; i <= nieder_P - 1; i++ )
	{
		if ( nieder_mul[i][j] == 1 )
		{
			binv = i;
		}
	}
	for ( d = degq; 0 <= d; d-- )
	{
		m = nieder_mul [ pr[degr+1] ] [ binv ];
		for ( i = degb; 0 <= i; i-- )
		{
			pr[degr+i-degb+1] = nieder_sub [ pr[degr+i-degb+1] ] [ nieder_mul[m][pb[i+1]] ];
		}
		degr = degr - 1;
		pq[d+1] = m;
	}
	pq[0] = degq;
	while ( pr[degr+1] == 0 && 0 <= degr ) 
	{
		degr = degr - 1;
	}
	pr[0] = degr;
	return 1;
}
//****************************************************************************80
int ptoi ( int poly[] )
//****************************************************************************80
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
{
	int degree;
	int i;
	int j;
	degree = poly[0];
	i = 0;
	for ( j = degree; 0 <= j; j-- )
	{
		i = i * nieder_Q + poly[j+1];
	}
	return i;
}
//****************************************************************************80
//////////////////////////////////////////////////////////////////////////////////////
int GFPLYS ( char * gfaritfile , char * gfplysfile )
//****************************************************************************80
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
{
	ofstream output;
	int q_init;
	int ierr;

	output.open ( gfplysfile );
	if ( !output )
	{
		ostringstream msg;
		msg << "niederreiter - GFPLYS - Error!\n";
		msg << "  Could not open the output file: \"" << gfplysfile << "\"\n";
		lowdisc_error(msg.str());
		return 0;
	}
	for ( q_init = 2; q_init <= nieder_Q_MAX; q_init++ )
	{
		ierr = irred ( output, q_init , gfaritfile );
		if ( ierr==0 ) {
			return 0;
		}
	}
	output.close ( );
	return 1;
}
//****************************************************************************80
int find ( int n, int tab[], int i, int tab_max )
//****************************************************************************80
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
{
	int j;
	int value;
	value = -1;
	if ( tab[tab_max-1]  <  n )
	{
		return value;
	}
	for ( j = i; j <= tab_max; j++ )
	{
		if ( tab[j-1] == n )
		{
			value = j;
			return value;
		}
	}
	return value;
}
//****************************************************************************80
int irred ( ofstream &output, int q_init , char * gfaritfile )
//****************************************************************************80
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
{
# define SIEVE_MAX 400
	int i;
	int j;
	int k;
	int l;
	int monpol[SIEVE_MAX];
	int n;
	int *pi;
	int *pj;
	int *pk;
	bool sieve[SIEVE_MAX];
	int ierr;
	if ( q_init <= 1 || nieder_Q_MAX < q_init )
	{
		ostringstream msg;
		msg << "\n";
		msg << "niederreiter - IRRED - Fatal error!\n";
		msg << "  Bad value of Q = " << q_init << " is greater than Q_MAX = " << nieder_Q_MAX << "\n";
		lowdisc_error(msg.str());
		return 0;
	}
	nieder_P = i4_characteristic ( q_init );
	//
	//  If no field of order Q_INIT exists, there is nothing to do.
	//
	if ( nieder_P <= 0 )
	{
		return 1;
	}
	//
	//  Set up the field arithmetic tables.
	//  (Note that SETFLD sets Q = q_init!)
	//
	ierr = setfld ( q_init , gfaritfile );
	if ( ierr==0 ) {
		return 0;
	}
	//
	//  Set up the sieve containing only monic polynomials.
	//
	i = 0;
	j = 1;
	k = nieder_Q;
	for ( n = 1; n <= SIEVE_MAX; n++ )
	{
		i = i + 1;
		if ( i == j )
		{
			i = k;
			j = 2 * k;
			k = nieder_Q * k;
		}
		monpol[n-1] = i;
		sieve[n-1] = true;
	}
	//
	//  Write out the irreducible polynomials as they are found.
	//
	n = 0;
	output << setw(3) << nieder_Q << "\n";
	for ( i = 1; i <= SIEVE_MAX; i++ )
	{
		if ( sieve[i-1] )
		{
			pi = itop ( monpol[i-1] );
			if ( pi == NULL ) {
				return 0;
			}
			k = pi[0];
			output << setw(3) << k;
			for ( l = 0; l <= k; l++ )
			{
				output << setw(3) << pi[l+1];
			}
			output << "\n";
			n = n + 1;
			if ( n == nieder_NPOLS )
			{
				delete [] pi;
				return 1;
			}
			for ( j = i; j <= SIEVE_MAX; j++ )
			{
				pj = itop ( monpol[j-1] );
				if ( pj == NULL ) {
					return 0;
				}
				pk = plymul ( pi, pj );
				k = find ( ptoi ( pk ), monpol, j, SIEVE_MAX );
				if ( k != -1 )
				{
					sieve[k-1] = false;
				}
				delete [] pj;
				delete [] pk;
			}
			delete [] pi;
		}
	}
	ostringstream msg;
	msg << "niederreiter - IRRED - Warning!\n";
	msg << "  The sieve size SIEVE_MAX is too small.\n";
	msg << "  Number of irreducible polynomials found: " << n << "\n";
	msg << "  Number needed: " << nieder_NPOLS << "\n";
	lowdisc_error(msg.str());
	return 0;
# undef SIEVE_MAX
}
//****************************************************************************80

