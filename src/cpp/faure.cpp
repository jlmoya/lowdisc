// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <cstdlib>
#include <iostream>
#include <cmath>
#include <ctime>
#include <sstream>
#include <fstream>

using namespace std;

#include "faure.h"
#include "lowdisc_shared.h"

int *binomial_table ( int qs, int m, int n );
int i4_log_i4 ( int i4, int j4 );
void timestamp ( void );
int prime_ge ( int n );


int startup = 0;
int *coef = NULL;
int hisum_save = -1;
int qs = -1;
int *ytemp = NULL;

//****************************************************************************80

int *binomial_table ( int qs, int m, int n )

//****************************************************************************80
//
//  Purpose:
//
//    BINOMIAL_TABLE computes a table of bionomial coefficients MOD QS.
//
//  Discussion:
//
//    For "technical reasons", COEF(0,0) is set to 0 instead of 1.
//
//  Modified:
//
//    08 June 2007
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int QS, the base for the MOD operation.
//
//    Input, int M, N, the limits of the binomial table.
//
//    Output, int BINOMIAL_TABLE[(M+1)*(N+1)], the table of binomial 
//    coefficients modulo QS.
//
{
	int *coef;
	int i;
	int j;

	coef = new int[(m+1)*(n+1)];

	for ( j = 0; j <= n; j++ )
	{
		for ( i = 0; i <= m; i++ )
		{
			coef[i+j*(m+1)] = 0;
		}
	}

	coef[0] = 1;

	j = 0;
	for ( i = 1; i <= m; i++ )
	{
		coef[i+j*(m+1)] = 1;
	}

	for ( i = 1; i <= i4_min ( m, n ); i++ )
	{
		j = i;
		coef[i+j*(m+1)] = 1;
	}

	for( j = 1; j <= n; j++ )
	{
		for ( i = j + 1; i <= m; i++ )
		{
			coef[i+j*(m+1)] = ( coef[i-1+j*(m+1)] + coef[i-1+(j-1)*(m+1)] ) % qs;
		}
	}

	return coef;
}
//****************************************************************************80

void faure_startup ( int dim_num , int basis )

//****************************************************************************80
//
//  Purpose:
//
//    faure_startup startup the sequence.
//    Setup the following parameters : 
//	  startup = 1;
//    hisum_save = -1
//    qs the smallest prime greater than dim_num
//	
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension, which should be
//    at least 2.
//
//    Input, int basis, the basis of the Faure sequence.
//	  If basis=0, then a basis is computed automatically from
//	  an internal table of primes. If basis is nonzero and positive,
//	  then it is used as a basis. This feature allows to extend 
//	  the sequence to dimensions where the internal table is not 
//	  large enough.
//    The basis must be the smallest prime greater than dim_num.
//
{
	if ( startup == 1 )
	{
		ostringstream msg;
		msg << "faure - faure_startup - Fatal error!\n";
		msg << "  Startup is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	startup = 1;
	if ( basis == 0 )
	{
		qs = prime_ge ( dim_num );
	} 
	else if ( basis < 0 ) 
	{
		ostringstream msg;
		msg << "faure - faure_baseset - Fatal error!\n";
		msg << "  New base " << basis << " is negative.\n";
		lowdisc_error(msg.str());
		return;
	} else
	{
		qs = basis;
	}

	if ( qs < 1 )
	{
		ostringstream msg;
		msg << "faure - FAURE - Fatal error!\n";
		msg << "  PRIME_GE failed.\n";
		lowdisc_error(msg.str());
		return;
	}
	hisum_save = -1;
	return;
}
//****************************************************************************80

int faure_baseget ( )

//****************************************************************************80
// Returns the base used by the Faure sequence.
// Must be executed only after the sequence has been started up.
{
	return qs;
}
//****************************************************************************80

void faure_shutdown ( )

//****************************************************************************80
//
//  Purpose:
//
//    faure_shutdown shutdown the sequence.
//    Setup the following parameters : 
//	  startup = 0;
//    qs = -1
//    hisum_save = -1
//	  Deletes the unnecessary memory.
//	
//  Parameters:
//
{
	if ( startup == 0 )
	{
		ostringstream msg;
		msg << "faure - faure_shutdown - Fatal error!\n";
		msg << "  Shutdown is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	startup = 0;
	qs = -1;
	hisum_save = -1;
	if ( coef != NULL )
	{
		delete [] coef;
		coef = NULL;
	}

	if ( ytemp != NULL )
	{
		delete [] ytemp;
		ytemp = NULL;
	}
	return;
}
//****************************************************************************80

void faure ( int dim_num, int *seed, double quasi[] )

//****************************************************************************80
//
//  Purpose:
//
//    FAURE generates a new quasirandom Faure vector with each call.
//
//  Discussion:
//
//    This routine implements the Faure method for computing
//    quasirandom numbers.  It is a merging and adaptation of
//    Bennett Fox's routines INFAUR and GOFAUR from ACM TOMS Algorithm 647.
//
//  Modified:
//
//    09 June 2007
//
//  Author:
//
//    John Burkardt
//
//  Reference:
//
//    Henri Faure,
//    Discrepance de suites associees a un systeme de numeration
//    (en dimension s),
//    Acta Arithmetica,
//    Volume 41, 1982, pages 337-351.
//
//    Bennett Fox,
//    Algorithm 647:
//    Implementation and Relative Efficiency of Quasirandom 
//    Sequence Generators,
//    ACM Transactions on Mathematical Software,
//    Volume 12, Number 4, December 1986, pages 362-376.
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension, which should be
//    at least 2.
//
//    Input/output, int *SEED, the seed, which can be used to index
//    the values.  On first call, set the input value of SEED to be 0
//    or negative.  The routine will automatically initialize data,
//    and set SEED to a new value.  Thereafter, to compute successive
//    entries of the sequence, simply call again without changing
//    SEED.  On the first call, if SEED is negative, it will be set
//    to a positive value that "skips over" an early part of the sequence
//    (This is recommended for better results).
//
//    Output, double QUASI[DIM_NUM], the next quasirandom vector.
//
{
	int hisum;
	int i;
	int j;
	int k;
	int ktemp;
	int ltemp;
	int mtemp;
	double r;
	int ztemp;
	//
	//  Initialization already done ?
	//
	if ( startup == 0 )
	{
		ostringstream msg;
		msg << "faure - FAURE - Fatal error!\n";
		msg << "  Startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}
	//
	//  If SEED < 0, reset for recommended initial skip.
	//
	if ( *seed < 0 )
	{
		hisum = 3;
		*seed = i4_power ( qs, hisum + 1 ) - 1;
	}
	else if ( *seed == 0 )
	{
		hisum = 0;
	}
	else
	{
		hisum = i4_log_i4 ( *seed, qs );
	}
	//
	//  Is it necessary to recompute the coefficient table?
	//
	if ( hisum_save != hisum )
	{
		if ( coef != NULL )
		{
			delete [] coef;
		}

		if ( ytemp != NULL )
		{
			delete [] ytemp;
		}

		hisum_save = hisum;

		coef = binomial_table ( qs, hisum, hisum );

		ytemp = new int[hisum+1];
	}

	//
	//  Find QUASI(1) using the method of Faure.
	//
	//  SEED has a representation in base QS of the form: 
	//
	//    Sum ( 0 <= J <= HISUM ) YTEMP(J) * QS**J
	//
	//  We now compute the YTEMP(J)'s.
	//
	ktemp = i4_power ( qs, hisum + 1 );
	ltemp = *seed;

	for ( i = hisum; 0 <= i; i-- )
	{
		ktemp = ktemp / qs;
		mtemp = ltemp % ktemp;
		ytemp[i] = ( ltemp - mtemp ) / ktemp;
		ltemp = mtemp;
	}
	//
	//  QUASI(K) has the form
	//
	//    Sum ( 0 <= J <= HISUM ) YTEMP(J) / QS**(J+1)
	//
	//  Compute QUASI(1) using nested multiplication.
	//
	r = ( ( double ) ytemp[hisum] );
	for ( i = hisum-1; 0 <= i; i-- )
	{
		r = ( ( double ) ytemp[i] ) + r / ( ( double ) qs );
	}

	quasi[0] = r / ( ( double ) qs );
	//
	//  Find components QUASI(2:DIM_NUM) using the Faure method.
	//
	for ( k = 1; k < dim_num; k++ )
	{
		quasi[k] = 0.0;
		r = 1.0 / ( ( double ) qs );

		for ( j = 0; j <= hisum; j++ )
		{
			ztemp = 0;
			for ( i = j; i <= hisum; i++ )
			{
				ztemp = ztemp + ytemp[i] * coef[i+j*(hisum+1)];
			}
			//
			//  New YTEMP(J) is:
			//
			//    Sum ( J <= I <= HISUM ) ( old ytemp(i) * binom(i,j) ) mod QS.
			//
			ytemp[j] = ztemp % qs;
			quasi[k] = quasi[k] + ( ( double ) ytemp[j] ) * r;
			r = r / ( ( double ) qs );
		}
	}
	//
	//  Update SEED.
	//
	*seed = *seed + 1;

	return;
}
//****************************************************************************80

int i4_log_i4 ( int i4, int j4 )

//****************************************************************************80
//
//  Purpose:
//
//    I4_LOG_I4 returns the logarithm of an I4 to an I4 base.
//
//  Discussion:
//
//    Only the integer part of the logarithm is returned.
//
//    If 
//
//      K4 = I4_LOG_J4 ( I4, J4 ),
//
//    then we ordinarily have
//
//      J4^(K4-1) < I4 <= J4^K4.
//
//    The base J4 should be positive, and at least 2.  If J4 is negative,
//    a computation is made using the absolute value of J4.  If J4 is
//    -1, 0, or 1, the logarithm is returned as 0.
//
//    The number I4 should be positive and at least 2.  If I4 is negative,
//    a computation is made using the absolute value of I4.  If I4 is
//    -1, 0, or 1, then the logarithm is returned as 0.
//
//    An I4 is an integer ( kind = 4 ) value.
//
//  Example:
//
//    I4  J4  K4
//
//     0   3   0
//     1   3   0
//     2   3   0
//     3   3   1
//     4   3   1
//     8   3   1
//     9   3   2
//    10   3   2
//
//  Modified:
//
//    09 June 2007
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int I4, the number whose logarithm is desired.
//
//    Input, int J4, the base of the logarithms.
//
//    Output, int I4_LOG_I4, the integer part of the logarithm
//    base abs(J4) of abs(I4).
//
{
	int i4_abs;
	int j4_abs;
	int value;

	value = 0;

	i4_abs = abs ( i4 );

	if ( 2 <= i4_abs )
	{
		j4_abs = abs ( j4 );

		if ( 2 <= j4_abs )
		{
			while ( j4_abs <= i4_abs )
			{
				i4_abs = i4_abs / j4_abs;
				value = value + 1;
			}
		}
	}
	return value;
}
//****************************************************************************80

int prime_ge ( int n )

//****************************************************************************80
//
//  Purpose:
//
//    PRIME_GE returns the smallest prime greater than or equal to N.
//
//  Examples:
//
//    N     PRIME_GE
//
//    -10    2
//      1    2
//      2    2
//      3    3
//      4    5
//      5    5
//      6    7
//      7    7
//      8   11
//      9   11
//     10   11
//
//  Modified:
//
//    09 March 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number to be bounded.
//
//    Output, int PRIME_GE, the smallest prime number that is greater
//    than or equal to N.  However, if N is larger than the
//    largest prime stored, then PRIME_GE is returned as -1.
//
{
	int i_hi;
	int i_lo;
	int i_mid;
	int p;
	int p_hi;
	int p_lo;
	int p_mid;

	if ( n <= 2 )
	{
		p = 2;
	}
	else
	{
		i_lo = 1;
		p_lo = prime(i_lo);
		i_hi = prime(-1);
		p_hi = prime(i_hi);

		if ( p_hi < n )
		{
			p = - p_hi;
		}
		else
		{
			for ( ; ; )
			{
				if ( i_lo + 1 == i_hi )
				{
					p = p_hi;
					break;
				}

				i_mid = ( i_lo + i_hi ) / 2;
				p_mid = prime(i_mid);

				if ( p_mid < n )
				{
					i_lo = i_mid;
					p_lo = p_mid;
				}
				else if ( n <= p_mid )
				{
					i_hi = i_mid;
					p_hi = p_mid;
				}
			}
		}
	}

	return p;
}
