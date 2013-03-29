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
// Private functions
double vandercorput(int index, int base);
void halton_RR2Scrambling();
double scrambledVDC(int index, int base, int * sigma);

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

//
//  These variables are accessible to the user via calls to set/get routines.
//
// The number of dimensions
int  halton_dim_num = -1;
// The bases, an array[0,1,...,dim_num-1]
// halton_base[i] is a prime number, for i=0,1,...,dim_num
int *halton_base = NULL;
// The leap, an array[0,1,...,dim_num-1]
// halton_leap[i]>=1, for i=0,1,...,dim_num
int *halton_leap = NULL;
// The seed, an array[0,1,...,dim_num-1]
// halton_seed[i]>=0, for i=0,1,...,dim_num
int *halton_seed = NULL;
// Set to true when the component is started up
bool halton_startup = false;

// The scrambling method
int halton_scrambling = halton_scramblingZero;

// The permutation used in the scrambling
int ** halton_sigma = NULL;

void halton_next ( int index , double r[] )
{
	int i;
	int seed2;

	if ( !halton_startup )
	{
		ostringstream msg;
		msg << "halton - halton_next - Error!\n";
		msg << "  Startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}

	if ( halton_scrambling==halton_scramblingZero )
	{
		for ( i = 0; i < halton_dim_num; i++ )
		{
			seed2 = halton_seed[i] + index * halton_leap[i];
			r[i] = vandercorput(seed2, halton_base[i]);
		}
	} 
	else if ( halton_scrambling==halton_scramblingRR2 )
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

// vandercorput --
// Returns the index-th element of the Van Der Corput 
// sequence in base b
//
// Parameters
//   index, input : the index in the sequence, index>=0
//   base, input : the base of the sequence, base>=2 (base must be a prime number)
//   result, output : the index-th element in the sequence, in [0,1].
//
// Example:
// base=2;
// index=0, r=0.  
// index=1, r=0.5  
// index=2, r=0.25  
// index=3, r=0.75  
// index=4, r=0.125  
// index=5, r=0.625  
// index=6, r=0.375  
// index=7, r=0.875  
// index=8, r=0.0625  
// index=9, r=0.5625  
// 
double vandercorput(int index, int base)
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

// halton_dim_num_get --
// gets the spatial dimension for a leaped Halton subsequence.
//
//  Parameters:
//    Output, int HALTON_DIM_NUM_GET, the spatial dimension.
int halton_dim_num_get ( void )
{
	return halton_dim_num;
}

// halton_base_get -- 
// gets the base vector for a leaped Halton subsequence.
//
//  Parameters:
//    Output, int base[], the bases
void halton_base_get ( int base[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		base[i] = halton_base[i];
	}
	return;
}
// halton_leap_get --
// gets the leap vector for a leaped Halton subsequence.
//
//  Parameters:
//    Output, int leap[], the successive jumps in the Halton sequence.
void halton_leap_get ( int leap[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		leap[i] = halton_leap[i];
	}
	return;
}

// halton_seed_get -- 
// gets the seed vector for a leaped Halton subsequence.
//
//  Parameters:
//    Output, int seed[], the sequence index corresponding to STEP = 0.
void halton_seed_get ( int seed[] )
{
	int i;
	for ( i = 0; i < halton_dim_num; i++ )
	{
		seed[i] = halton_seed[i];
	}
	return;
}

void halton_start ( int dim_num , int base[] , int seed[] , int leap[] , int scrambling)
{
	int i;
	int j;

	if ( halton_startup )
	{
		ostringstream msg;
		msg << "halton - halton_start - Error!\n";
		msg << "  Startup is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	halton_startup = true;
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
	if ( scrambling==halton_scramblingZero )
	{
		halton_scrambling=scrambling;
	} 
	else if ( scrambling==halton_scramblingRR2 )
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
	if ( scrambling==halton_scramblingRR2 )
	{
		// Allocate sigma for scrambling
		halton_sigma=(int **)malloc(base[dim_num-1]*sizeof(int*));
		for ( i = 0; i < dim_num; i++ )
		{
			halton_sigma[i]=(int *)malloc(base[i]*sizeof(int));
			for ( j = 0; j < base[i]; j++ )
			{
				halton_sigma[i][j]=-1;
			}
		}
		// Compute permutations
		halton_RR2Scrambling();
	}
	return;
}

void halton_stop ( )

{
	int i;
	if ( !halton_startup )
	{
		ostringstream msg;
		msg << "halton - halton_stop - Error!\n";
		msg << "  Startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}
	halton_startup = false;

	delete [] halton_base;
	delete [] halton_leap;
	delete [] halton_seed;
	if ( halton_scrambling==halton_scramblingRR2 )
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

bool halton_isstart ( )
{
	return halton_startup;
}

// halton_RR2Scrambling --
// Compute RR2 scrambling.
//
// Parameters
// dim_num : the number of dimensions, dim_num>=1
// i : the dimension to scramble, 1<=i<=dim_num
// base : an array[0,1,...,dim_num-1], the base for direction i
// sigma : an array, the permutations for all directions
// sigma[0] : an array0[0,1,...,base[0]], the permutation for direction 1
// sigma[1] : an array0[0,1,...,base[1]], the permutation for direction 1
// ...
// sigma[dim_num-1] : an array0[0,1,...,base[dim_num-1]], the permutation for direction dim_num
//
// Reference
// L. Kocis and W. Whiten. Computational investigations of 
// low discrepancy sequences.
// ACM Trans. Mathematical Software, 23:266–294, 1997.
//
// Example
// // Reference
// Generalized Halton Sequences in 2008: 
// A Comparative Study
// HENRI FAURE
// CHRISTIANE LEMIEUX
// Section 3. OVERVIEW OF PROPOSED GENERALIZED HALTON SEQUENCES
// Item (1) KW [Kocis and Whiten 1997]:
// For instance, take s = 3. 
// Then n3 = ceil(log 5/log 2) = 3
// and so σ corresponds to the permutation [0,4,2,6,1,5,3,7]. 
// Hence σ1 corresponds to [0,1], σ2 to [0,2,1] 
// and σ3 to [0,4,2,1,3].
// [Note From MB : fixed error in the permutation - switched 
// 5 and 3].


void halton_RR2Scrambling()
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

// scrambledVDC --
// Returns the index-th element of a scrambled Van Der Corput 
// sequence in base b
//
// Parameters
//   index, input : the index in the sequence, index>=0
//   base, input : the base of the sequence, base>=2 (base must be a prime number)
//   sigma, input : an array[0,1,...,base-1], the permutation of the digits, 0<=sigma[i]<=base-1.
//   result, output : the index-th element in the sequence, in [0,1].
//
// Example:
// sigma=[0,2,1]
// base=3
// index=1, r=0.6666667
// index=2, r=0.3333333
// index=3, r=0.2222222
// index=4, r=0.8888889
// index=5, r=0.5555556
// index=6, r=0.1111111
// index=7, r=0.7777778
// index=8, r=0.4444444
// index=9, r=0.0740741
// 
double scrambledVDC(int index, int base, int * sigma)
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


int halton_scrambling_get (  )
{
	return halton_scrambling;
}
