// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

# include <cstdlib>
# include <cmath>
# include <ctime>
# include <iostream>
# include <sstream>
# include <fstream>
# include <iomanip>

using namespace std;

#include "halton.h"
#include "lowdisc_shared.h"


//
//  Reference:
//
//    J H Halton,
//    On the efficiency of certain quasi-random sequences of points
//    in evaluating multi-dimensional integrals,
//    Numerische Mathematik,
//    Volume 2, 1960, pages 84-90.
//
//    J H Halton and G B Smith,
//    Algorithm 247: Radical-Inverse Quasi-Random Point Sequence,
//    Communications of the ACM,
//    Volume 7, 1964, pages 701-702.
//
//    Ladislav Kocis and William Whiten,
//    Computational Investigations of Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 23, Number 2, 1997, pages 266-294.
//


void Halton::next ( int index , double r[] )
{
	int i;
	int seed2;

	if ( halton_scrambling==HALTON_SCRAMBLINGZERO )
	{
		for ( i = 0; i < halton_dim_num; i++ )
		{
			seed2 = halton_seed[i] + index * halton_leap[i];
			r[i] = vandercorput(seed2, halton_base[i]);
		}
	} 
	else if ( halton_scrambling==HALTON_SCRAMBLINGRR2 )
	{
		for ( i = 0; i < halton_dim_num; i++ )
		{
			seed2 = halton_seed[i] + index * halton_leap[i];
			r[i] = scrambledVDC(index, halton_base[i], halton_sigma[i]);
		}
	}
	else if ( halton_scrambling==HALTON_SCRAMBLINGREVERSE )
	{
		for ( i = 0; i < halton_dim_num; i++ )
		{
			seed2 = halton_seed[i] + index * halton_leap[i];
			r[i] = scrambledVDC(index, halton_base[i], halton_sigma[i]);
		}
	}
	else
	{
		ostringstream msg;
		msg << "halton - halton_next - Error!\n";
		msg << "  Unknown scrambling "<<halton_scrambling<<"\n";
		lowdisc_error(msg.str());
		return;
	}
	return;
}

double Halton::vandercorput(int index, int base)
{
	double base_inv;
	double dblbase;
	double result;
	int digit;
	dblbase=( double ) base;
	base_inv = 1.0 / dblbase;
	result=0;
	while ( index != 0 )
	{
		digit = index % base;
		result = result + ( ( double ) digit ) * base_inv;
		base_inv = base_inv / dblbase;
		index = index / base;
	}
	return result;
};

int Halton::dim_num_get ( void )
{
	return halton_dim_num;
}

void Halton::base_get ( int base[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		base[i] = halton_base[i];
	}
	return;
}
void Halton::leap_get ( int leap[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		leap[i] = halton_leap[i];
	}
	return;
}

void Halton::seed_get ( int seed[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		seed[i] = halton_seed[i];
	}
	return;
}

Halton::Halton ( int dim_num , int base[] , int seed[] , int leap[] , int scrambling)
{
	int i;
	int j;

	//
	// Initialize
	//
	// The number of dimensions
	halton_dim_num = -1;
	// The bases, an array[0,1,...,dim_num-1]
	// halton_base[i] is a prime number, for i=0,1,...,dim_num
	halton_base = NULL;
	// The leap, an array[0,1,...,dim_num-1]
	// halton_leap[i]>=1, for i=0,1,...,dim_num
	halton_leap = NULL;
	// The seed, an array[0,1,...,dim_num-1]
	// halton_seed[i]>=0, for i=0,1,...,dim_num
	halton_seed = NULL;
	// The scrambling method
	halton_scrambling = HALTON_SCRAMBLINGZERO;
	// The permutation used in the scrambling
	halton_sigma = NULL;

	//
	// Store the dimension
	//
	if ( dim_num < 1 )
	{
		ostringstream msg;
		msg << "halton - halton_start - Error" << endl;
		msg << "  The spatial dimension DIM_NUM is lower than 1." << endl;
		msg << "  But this input value is DIM_NUM = " << dim_num << endl;
		lowdisc_error(msg.str());
		return;
	}
	halton_dim_num = dim_num;
	//
	// Store the seed
	//
	halton_seed = new int[halton_dim_num];
	for ( i = 0; i < halton_dim_num; i++ )
	{
		if ( seed[i] < 0 ) 
		{
			ostringstream msg;
			msg << "halton - halton_start - Error!\n";
			msg << "  SEED entries must be nonnegative.\n";
			msg << "  seed[" << i << "] = " << seed[i] << "\n";
			lowdisc_error ( msg.str() );
			return;
		}
		halton_seed[i] = seed[i];
	}
	//
	// Set the leap
	//
	halton_leap = new int[halton_dim_num];
	for ( i = 0; i < halton_dim_num; i++ )
	{
		if ( leap[i] < 1 ) 
		{
			ostringstream msg;
			msg << "halton - halton_start - Error!\n";
			msg << "  Leap entries must be greater than 0.\n";
			msg << "  leap[" << i << "] = " << leap[i] << "\n";
			lowdisc_error ( msg.str() );
			return;
		}
		halton_leap[i] = leap[i];
	}
	//
	// Set the base
	//
	halton_base = new int[halton_dim_num];
	for ( i = 0; i < halton_dim_num; i++ )
	{
		if ( base[i] < 0 || base[i] == 1 ) 
		{
			ostringstream msg;
			msg << "halton - halton_start - Error!\n";
			msg << "  Bases must be greater than 1.\n";
			msg << "  base[" << i << "] = " << base[i] << "\n";
			lowdisc_error ( msg.str() );
			return;
		}
		else if ( base[i] == 0 ) 
		{
			halton_base[i] = prime ( i + 1 );
		} 
		else
		{
			halton_base[i] = base[i];
		}
	}
	if ( scrambling==HALTON_SCRAMBLINGZERO || \
		scrambling==HALTON_SCRAMBLINGRR2 || \
		scrambling==HALTON_SCRAMBLINGREVERSE )
	{
		halton_scrambling=scrambling;
	} 
	else
	{
		ostringstream msg;
		msg << "halton - halton_start - Error!\n";
		msg << "  Scrambling method "<<scrambling<<" is unknown.\n";
		lowdisc_error(msg.str());
		return;
	}
	if ( scrambling==HALTON_SCRAMBLINGRR2 || \
		scrambling==HALTON_SCRAMBLINGREVERSE )
	{
		// Allocate sigma for scrambling
		halton_sigma=(int **)malloc(base[dim_num-1]*sizeof(int*));
		for ( i = 0; i < dim_num; i++ )
		{
			halton_sigma[i]=(int *)malloc(base[i]*sizeof(int));
			// Initialize
			for ( j = 0; j < base[i]; j++ )
			{
				halton_sigma[i][j]=-1;
			}
		}
		// Compute permutations
		if (scrambling==HALTON_SCRAMBLINGRR2)
		{
			RR2Scrambling();
		}
		else if (scrambling==HALTON_SCRAMBLINGREVERSE)
		{
			ReverseScrambling();
		}
	}
	return;
}

Halton::~Halton ( )
{
	int i;
	delete [] halton_base;
	delete [] halton_leap;
	delete [] halton_seed;
	if ( halton_scrambling==HALTON_SCRAMBLINGRR2 )
	{
		// Free sigma
		for ( i = 0; i < halton_dim_num; i++ )
		{
			free(halton_sigma[i]);
		}
		free(halton_sigma);
	}
	return;
}

void Halton::RR2Scrambling()
{
	int ns;
	int twopowns;
	int j;
	double doublebase;
	int k;
	int i;
	int vdck;

	doublebase=(double) halton_base[halton_dim_num-1];
	ns=(int)ceil(log(doublebase)/log(2.));
	// Caution : what when ns is large ?
	twopowns=(int)pow(2.,ns); 
	// Extract the permutations for base i.
	for ( i = 0; i < halton_dim_num; i++ )
	{
		j=0;
		for ( k = 0; k < twopowns; k++ )
		{
			vdck=(int)(vandercorput(k,2)*twopowns+0.5);
			if (vdck<halton_base[i])
			{
				halton_sigma[i][j]=vdck;
				j=j+1;
				if (j==halton_base[i])
				{
					// The permutation is computed:
					// we are done for this i.
					break;
				}
			}
		}
	}
}

void Halton::ReverseScrambling()
{
	int j;
	int i;
	int base;


	// Extract the permutations for base i.
	for ( i = 0; i < halton_dim_num; i++ )
	{
		base=halton_base[i];
		for ( j = 0; j < base; j++ )
		{
			if (j==0)
			{
				halton_sigma[i][j]=0;
			}
			else
			{
				halton_sigma[i][j]=base-j;
			}
		}
	}
}

double Halton::scrambledVDC(int index, int base, int * sigma)
{
	double base_inv;
	double dblbase;
	double result;
	int digit;
	double doubledigit;
	dblbase=( double ) base;
	base_inv = 1.0 / dblbase;
	result=0;
	while ( index != 0 )
	{
		digit = index % base;
		digit=sigma[digit];
		doubledigit=( double ) digit;
		result = result + doubledigit * base_inv;
		base_inv = base_inv / dblbase;
		index = index / base;
	}
	return result;
};


int Halton::scrambling_get (  )
{
	return halton_scrambling;
}
