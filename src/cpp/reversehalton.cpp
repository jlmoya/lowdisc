// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

//  Reference:
//
// B. Vandewoestyne and R. Cools, 
// Good permutations for deterministic scrambled Halton
// sequences in terms of L2-discrepancy, Computational and Applied
// Mathematics 189, 2006
// See also O. Teytaud, 2007, Gnu Scientific Library
//

# include <cstdlib>
# include <cmath>
# include <ctime>
# include <iostream>
# include <fstream>
# include <iomanip>
# include <sstream>

using namespace std;

#include "reversehalton.h"
#include "lowdisc_shared.h"

bool revhal_startup = false;
int revhal_dim = 0;
int * revhal_base = NULL;

//
// Private functions
double vdcinv ( int index , int b );

//  reversehalton --
//     computes the next element in a reverse Halton subsequence.
//    This routine is able to generate 2^32 - 1  = 4 294 967 295 experiments
//    in arbitrary dimension.
//	  To configure the maximum available dimension, setup a base of 
//	  primes accordingly with reversehalton_start.
//
//  Parameters:
//
//    Input, int index, the current iteration index
//    Output, double next[dim], the next element of the reverse Halton sequence.
//
void reversehalton ( int index, double next[] )
{
	int b;
	int idim;

	//
	//  Initialization already done ?
	//
	if ( !revhal_startup )
	{
		ostringstream msg;
		msg << "reversehalton - reversehalton - Error!\n";
		msg << "  revhal_startup is not done.\n";
		lowdisc_error(msg.str());
		return;
	}


	for ( idim = 0; idim < revhal_dim; idim++ )
	{
		b = revhal_base [idim];
		next[idim] = vdcinv ( index , b );
	}
	return;
}
//***************************************************************************
//
// vdcinv --
//   Returns the term #index of the inverted Van Der Corput low discrepancy sequence in 
//   given base.
//
// Parameters
//   index, input : the index in the sequence, index>=0
//   base, input : the base of the sequence, base>=2 (base must be a prime number)
//   vdcinv, output : the next element in the sequence, in [0,1]
//
double vdcinv ( int index , int b )
{
	double result;
	int current;
	// ib = inverse of the base : 1/b, 1/b^2, 1/b^3, etc...
	double ib;
	int digit;
	current = index;
	ib = 1.0 / (double) b;
	result = 0.0;
	while (current>0)
	{
		digit = current % b;
		current = ( int ) ( current / b );
		if ( digit != 0 ) 
		{
			result = result + ( b - digit ) * ib;
		}
		ib = ib / b;
	}
	return result;
}

//***************************************************************************
//  reversehalton_baseget --
//     returns the base
//
//  Parameters:
//    base, output : an integer array of size dim.
//

void reversehalton_baseget ( int * base )
{
	int idim;
	for ( idim = 0; idim < revhal_dim; idim++ )
	{
		base[idim] = revhal_base[idim];
	}
	return;
}


//***************************************************************************
//  reversehalton_dimget --
//     gets the spatial dimension for a reverse Halton sequence.
//
//  Parameters:
//    dim, output : an integer, the dimension of the sequence
//
int reversehalton_dimget ( )
{
	return revhal_dim;
}

//***************************************************************************

//  reversehalton_start --
//     revhal_startup the sequence
//
//  Parameters:
//    Input, int dim_num, the dimension of the sequence
//    Input, int base[], a table of dim primes
//
void reversehalton_start ( int dim_num , int newbase[] )
{
	int idim;

	if ( revhal_startup )
	{
		ostringstream msg;
		msg << "reversehalton - reversehalton_start - Error!\n";
		msg << "  revhal_startup is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	revhal_startup = true;

	if ( dim_num < 1 ) 
	{
		ostringstream msg;
		msg << "reversehalton - revhal_dimset - Error!\n";
		msg << "  Negative dimension dim = " << dim_num << "\n";
		lowdisc_error ( msg.str() );
		return;
	}
	revhal_dim = dim_num;
	if ( revhal_base != NULL )
	{
		delete [] revhal_base;
	}
	revhal_base = new int[revhal_dim];

	for ( idim = 0; idim < revhal_dim; idim++ )
	{
		if ( newbase[idim] < 1 ) 
		{
			ostringstream msg;
			msg << "reversehalton - revhal_baseset - Error!\n";
			msg << "  Negative prime base at index idim=" << idim << ", newbase[i] = " << newbase[idim] << "\n";
			lowdisc_error ( msg.str() );
			return;
		}
		revhal_base[idim] = newbase[idim];
	}

	return;
}
//****************************************************************************80

void reversehalton_stop ( )

//****************************************************************************80
//
//  Purpose:
//
//    reversehalton_stop shutdown the sequence.
//    Setup the following parameters : 
//	  revhal_startup = 0;
//    revhal_dim = 0
//	  Deletes the unnecessary memory.
//	
//  Parameters:
//
{
	if ( !revhal_startup )
	{
		ostringstream msg;
		msg << "reversehalton - reversehalton_shutdown - Error!\n";
		msg << "  Shutdown is already done.\n";
		lowdisc_error(msg.str());
		return;
	}
	revhal_startup = false;
	revhal_dim = 0;
	if ( revhal_base != NULL )
	{
		delete [] revhal_base;
		revhal_base = NULL;
	}
	return;
}
//***************************************************************************
//  reversehalton_isstart --
//     Returns true if the sequence is already started up.
//
//  Parameters:
//    startup, output : true if the sequence is already started up.
//
bool reversehalton_isstart ( )
{
	return revhal_startup;
}
