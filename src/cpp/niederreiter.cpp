// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <cmath>
#include <ctime>
#include <fstream>
#include <sstream>

using namespace std;

#include "niederreiter.h"
#include "lowdisc_shared.h"

void calcc ( void );
void calcv ( int px[], int b[], int v[], int v_max );
void golo ( double quasi[] );
int i4_characteristic ( int q );
void inlo ( int dim, int base, int skip );
int *plymul ( int pa[], int pb[] );
void setfld ( int q );


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

//****************************************************************************80

void niederreiter_start ( int dim_num, int base, int skip )
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
{
	if ( nieder_startup )
	{
		ostringstream msg;
		msg << "niederreiter - niederreiter_start - Error!\n";
		msg << "  Startup is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	nieder_startup = true;

	nieder_BASE = base;
	nieder_SKIP = skip;
	inlo ( dim_num, base, skip );
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

void niederreiter ( double r[] )

//****************************************************************************80
//
//  Purpose:
//
//    NIEDERREITER returns an element of a Niederreiter sequence for base BASE.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    11 September 2007
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input/output, int *SEED, a seed for the random number generator.
//
//    Output, double R[DIM_NUM], the element of the sequence.
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
	golo ( r );

	return;
}

//****************************************************************************80

void calcc ( void )

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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    14 September 2007
//
//  Author:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
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
	const int maxe = 5;
	const int v_max = nieder_FIG_MAX + maxe;

	int b[nieder_DEG_MAX+2];
	int e;
	ifstream input;
	char *input_filename = "gfplys.txt";
	int i;
	int j;
	int k;
	const int npols = 25;
	int px[maxe+2];
	int r;
	int u;
	int v[v_max+1];
	//
	//  Read the irreducible polynomials.
	//
	input.open ( input_filename );

	for ( ; ; )
	{
		input >> i;

		if ( input.eof ( ) )
		{
			ostringstream msg;
			msg << "niederrreiter - CALCC - Error!\n"; 
			msg << "  Could not find tables for Q = " << nieder_Q << "\n";
			lowdisc_error(msg.str());
			return;
		}

		if ( i == nieder_Q )
		{
			break;
		}

		for ( j = 1; j <= npols; j++ )
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

	return;
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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    11 September 2007
//
//  Author:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    12 September 2007
//
//  Author:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
//
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
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

	for ( ; ; )
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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 September 2007
//
//  Author:
//
//    Paul Bratley, Bennet Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
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

void inlo ( int dim, int base, int skip )

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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    12 September 2007
//
//  Author:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
//
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
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

	nieder_DIMEN = dim;

	if ( nieder_DIMEN <= 0 || nieder_DIM_MAX < nieder_DIMEN )
	{
		ostringstream msg;
		msg << "niederreiter - INLO - Error!\n";
		msg << "  Bad spatial dimension.\n";
		lowdisc_error(msg.str());
		return;
	}
	if ( base < 1 ) 
	{
		ostringstream msg;
		msg << "niederreiter - inlo - Error!\n";
		msg << "  Base must be greater than 1.\n";
		msg << "  base = " << base << "\n";
		lowdisc_error ( msg.str() );
		return;
	}

	if ( i4_characteristic ( base ) == 0 )
	{
		ostringstream msg;
		msg << "niederreiter - INLO - Error!\n";
		msg << "  Base not prime power or out of range.\n";
		lowdisc_error(msg.str());
		return;
	}

	setfld ( base );
	//
	//  Calculate how many figures to use in base Q = BASE
	//
	temp = log ( pow ( 2.0, nbits ) - 1.0 ) / log ( ( double ) ( nieder_Q ) );

	nieder_NFIGS = i4_min ( nieder_FIG_MAX, ( int ) temp );
	//
	//  Calculate the C array.
	//
	calcc ( );
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
		return;
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
		return;
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

	return;
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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 September 2007
//
//  Author:
//
//    Paul Bratley, Bennet Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
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

void setfld ( int q_init )

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
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 September 2007
//
//  Author:
//
//    Paul Bratley, Bennet Fox, Harald Niederreiter.
//    C++ version by John Burkardt.
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738: 
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, 1994, pages 494-495.
//
//  Parameters:
//
//    Input, int Q_INIT, the order of the field.
//
{
	int i;
	int j;

	if ( q_init <= 1 || nieder_Q_MAX < q_init )
	{
		ostringstream msg;
		msg << "niederreiter - SETFLD - Error!\n";
		msg << "  Bad value of Q = " << q_init << "\n";
		lowdisc_error(msg.str());
		return;
	}

	nieder_Q = q_init;
	nieder_P = i4_characteristic ( nieder_Q );

	if ( nieder_P == 0 )
	{
		ostringstream msg;
		msg << "niederreiter - SETFLD - Error!\n";
		msg << "  There is no field of order Q = " << nieder_Q << "\n";
		lowdisc_error(msg.str());
		return;
	}
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
	return;
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
