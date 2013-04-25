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

int *Faure::binomial_table ( int faure_qs, int m, int n )
{
	int *faure_coef;
	int i;
	int j;

	faure_coef = new int[(m+1)*(n+1)];

	for ( j = 0; j <= n; j++ )
	{
		for ( i = 0; i <= m; i++ )
		{
			faure_coef[i+j*(m+1)] = 0;
		}
	}

	faure_coef[0] = 1;

	j = 0;
	for ( i = 1; i <= m; i++ )
	{
		faure_coef[i+j*(m+1)] = 1;
	}

	for ( i = 1; i <= i4_min ( m, n ); i++ )
	{
		j = i;
		faure_coef[i+j*(m+1)] = 1;
	}

	for( j = 1; j <= n; j++ )
	{
		for ( i = j + 1; i <= m; i++ )
		{
			faure_coef[i+j*(m+1)] = ( faure_coef[i-1+j*(m+1)] + faure_coef[i-1+(j-1)*(m+1)] ) % faure_qs;
		}
	}

	return faure_coef;
}

Faure::Faure ( int dim_num , int basis )
{
	//
	// Initialize private fields
	//
	init();

	//
	// Store the dimension
	//
	if ( dim_num < 1 )
	{
		ostringstream msg;
		msg << "faure - faure_start - Fatal Error" << endl;
		msg << "  The spatial dimension DIM_NUM is lower than 1." << endl;
		msg << "  But this input value is DIM_NUM = " << dim_num << endl;
		lowdisc_error(msg.str());
		return;
	}
	faure_dim_num = dim_num;
	//
	// Compute faure_qs
	//
	if ( basis < 0 ) 
	{
		ostringstream msg;
		msg << "faure - faure_baseset - Error!\n";
		msg << "  New base " << basis << " is negative.\n";
		lowdisc_error(msg.str());
		return;
	} 
	else
	{
		faure_qs = basis;
	}

	if ( faure_qs < 1 )
	{
		ostringstream msg;
		msg << "faure - FAURE - Error!\n";
		msg << "  PRIME_GE failed.\n";
		lowdisc_error(msg.str());
		return;
	}
	faure_hisum_save = -1;
	return;
}

void Faure::init ( )
{
	//
	// Initialize private fields
	//
	faure_dim_num = 0;
	faure_coef = NULL;
	faure_hisum_save = -1;
	faure_qs = -1;
	faure_ytemp = NULL;
}
int Faure::baseget ( )
{
	return faure_qs;
}

Faure::~Faure ( )
{
	faure_qs = -1;
	faure_hisum_save = -1;
	if ( faure_coef != NULL )
	{
		delete [] faure_coef;
		faure_coef = NULL;
	}

	if ( faure_ytemp != NULL )
	{
		delete [] faure_ytemp;
		faure_ytemp = NULL;
	}
	return;
}

void Faure::next ( int *seed, double quasi[] )
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
	//  If SEED < 0, reset for recommended initial skip.
	//
	if ( *seed < 0 )
	{
		hisum = 3;
		*seed = i4_power ( faure_qs, hisum + 1 ) - 1;
	}
	else if ( *seed == 0 )
	{
		hisum = 0;
	}
	else
	{
		hisum = i4_log_i4 ( *seed, faure_qs );
	}
	//
	//  Is it necessary to recompute the faure_coefficient table?
	//
	if ( faure_hisum_save != hisum )
	{
		if ( faure_coef != NULL )
		{
			delete [] faure_coef;
		}

		if ( faure_ytemp != NULL )
		{
			delete [] faure_ytemp;
		}

		faure_hisum_save = hisum;

		faure_coef = binomial_table ( faure_qs, hisum, hisum );

		faure_ytemp = new int[hisum+1];
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
	ktemp = i4_power ( faure_qs, hisum + 1 );
	ltemp = *seed;

	for ( i = hisum; 0 <= i; i-- )
	{
		ktemp = ktemp / faure_qs;
		mtemp = ltemp % ktemp;
		faure_ytemp[i] = ( ltemp - mtemp ) / ktemp;
		ltemp = mtemp;
	}
	//
	//  QUASI(K) has the form
	//
	//    Sum ( 0 <= J <= HISUM ) YTEMP(J) / QS**(J+1)
	//
	//  Compute QUASI(1) using nested multiplication.
	//
	r = ( ( double ) faure_ytemp[hisum] );
	for ( i = hisum-1; 0 <= i; i-- )
	{
		r = ( ( double ) faure_ytemp[i] ) + r / ( ( double ) faure_qs );
	}

	quasi[0] = r / ( ( double ) faure_qs );
	//
	//  Find components QUASI(2:DIM_NUM) using the Faure method.
	//
	for ( k = 1; k < faure_dim_num; k++ )
	{
		quasi[k] = 0.0;
		r = 1.0 / ( ( double ) faure_qs );

		for ( j = 0; j <= hisum; j++ )
		{
			ztemp = 0;
			for ( i = j; i <= hisum; i++ )
			{
				ztemp = ztemp + faure_ytemp[i] * faure_coef[i+j*(hisum+1)];
			}
			//
			//  New YTEMP(J) is:
			//
			//    Sum ( J <= I <= HISUM ) ( old faure_ytemp(i) * binom(i,j) ) mod QS.
			//
			faure_ytemp[j] = ztemp % faure_qs;
			quasi[k] = quasi[k] + ( ( double ) faure_ytemp[j] ) * r;
			r = r / ( ( double ) faure_qs );
		}
	}
	//
	//  Update SEED.
	//
	*seed = *seed + 1;

	return;
}

int Faure::i4_log_i4 ( int i4, int j4 )
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

int Faure::dimget ( )
{
	return faure_dim_num;
}
