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

// warning C4996: 'fopen': This function or variable may be unsafe.
#ifdef _MSC_VER
#pragma warning( disable : 4996 )
#endif

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

void Niederreiter::init ( )
{
}

void Niederreiter::initDataFiles ( char * gfaritfile , char * gfplysfile )
{
	int ierr;
	ierr = GFARIT ( gfaritfile );
	if ( ierr==0 ) {
		return;
	}
	//
	ierr = GFPLYS ( gfaritfile , gfplysfile );
	if ( ierr==0 ) {
		return;
	}
	return;
}


Niederreiter::Niederreiter ( int dim_num, int base, int skip , char * gfaritfile , char * gfplysfile )
{
	int ierr;
	FILE * pFile;
	//
	// Initalize private fields.
	init();
	//
	// If the first file do not exist, create both of them
	pFile = fopen (gfaritfile,"r");
	if (pFile==NULL)
	{
		initDataFiles ( gfaritfile , gfplysfile );
	}
	//
	nieder_BASE = base;
	nieder_SKIP = skip;
	ierr = Niederreiter::inlo ( dim_num, base, skip , gfaritfile , gfplysfile );
	if ( ierr==0 ) {
		return;
	}
	return;
}


Niederreiter::~Niederreiter ( )
{
	return;
}

void Niederreiter::next ( double quasi[] )
{
	// TODO : rename golo into next...
	golo ( quasi );
	return;
}

int Niederreiter::calcc ( char * gfplysfile )
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

void Niederreiter::calcv ( int px[], int b[], int v[], int v_max )
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

void Niederreiter::golo ( double quasi[] )
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

int Niederreiter::i4_characteristic ( int q )
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

int Niederreiter::inlo ( int dim, int base, int skip , char * gfaritfile , char * gfplysfile )
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

int *Niederreiter::plymul ( int pa[], int pb[] )
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

int Niederreiter::setfld ( int q_init , char * gfaritfile )
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

int Niederreiter::dim_num_get ( void )
{
	return nieder_DIMEN;
}

int Niederreiter::base_get ( )
{
	return nieder_BASE;
}

int Niederreiter::skip_get ( )
{
	return nieder_SKIP;
}


int Niederreiter::GFARIT ( char * gfaritfile )
{
	FILE * output;
	int q_init;
	int ierr;
	output = fopen(gfaritfile,"w");
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
	fclose(output);
	return 1;
}

int Niederreiter::gftab ( FILE * output, int q_init , char * gfaritfile )
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
		fprintf(output," %d\n",q_init);
		for ( i = 0; i < q_init; i++ )
		{
			for ( j = 0; j < q_init; j++ )
			{
				fprintf(output," %d",gfadd[i][j]);
			}
				fprintf(output,"\n");
		}
		for ( i = 0; i < q_init; i++ )
		{
			for ( j = 0; j < q_init; j++ )
			{
				fprintf(output," %d",gfmul[i][j]);
			}
			fprintf(output,"\n");
		}
		return 1;
}

int *Niederreiter::itop ( int in )
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

int *Niederreiter::plyadd ( int pa[], int pb[] )
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

int Niederreiter::plydiv ( int pa[], int pb[], int pq[], int pr[] )
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

int Niederreiter::ptoi ( int poly[] )
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

int Niederreiter::GFPLYS ( char * gfaritfile , char * gfplysfile )
{
	FILE * output;
	int q_init;
	int ierr;

	output = fopen(gfplysfile,"w");
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
	fclose(output);
	return 1;
}

int Niederreiter::find ( int n, int tab[], int i, int tab_max )
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

int Niederreiter::irred ( FILE * output, int q_init , char * gfaritfile )
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
	fprintf(output,"  %d\n",nieder_Q);
	for ( i = 1; i <= SIEVE_MAX; i++ )
	{
		if ( sieve[i-1] )
		{
			pi = itop ( monpol[i-1] );
			if ( pi == NULL ) {
				return 0;
			}
			k = pi[0];
			fprintf(output,"  %d",k);
			for ( l = 0; l <= k; l++ )
			{
				fprintf(output,"  %d",pi[l+1]);
			}
			fprintf(output,"\n");
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


