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

int reversehalton_dim = 0;
int * reversehalton_base = NULL;

//
// Private functions
double vdcinv ( int iter , int b );

//  reversehalton --
//     computes the next element in a reverse Halton subsequence.
//
//  Parameters:
//
//    Input, int dim, the number of dimensions
//    Input, int primes[], a table of dim primes
//    Input, int iter, the current iteration index
//    Output, double next[dim], the next element of the reverse Halton sequence.
//
void reversehalton ( int iter, double next[] )
{
  int b;
  int idim;
  for ( idim = 0; idim < reversehalton_dim; idim++ )
  {
    b = reversehalton_base [idim];
    next[idim] = vdcinv ( iter , b );
  }
  return;
}
//***************************************************************************
//
// vdcinv --
//   Returns the term #iter of the inverted Van Der Corput low discrepancy sequence in 
//   given base.
//
// Paramters
//   iter, input : the index in the sequence
//   base, input : the base of the sequence
//   vdcinv, output : the next element in the sequence, uniform in [0,1]
//
double vdcinv ( int iter , int b )
{
  double result;
  int current;
  // ib = inverse of the base : 1/b, 1/b^2, 1/b^3, etc...
  double ib;
  int digit;
  current = iter;
  ib = 1.0 / (double) b;
  result = 0.0;
  while (current>0)
  {
    digit = current % b;
    current = ( int ) ( current / b );
    if ( digit /= 0 ) 
    {
      result = result + ( b - digit ) * ib;
    }
    ib = ib / b;
  }
  return result;
}
//***************************************************************************

//  reversehalton_baseset --
//     sets the base
//
//  Parameters:
//    Input, int base[], a table of dim primes
//    Input, int iter, the current iteration index
//    Output, double next[dim], the next element of the reverse Halton sequence.
//
void reversehalton_baseset ( int newbase[] )
{
	int idim;

	if ( reversehalton_dim < 1 ) 
	{
		ostringstream msg;
		msg << "reversehalton - reversehalton_baseset - Error!\n";
		msg << "  Negative dimension dim = " << reversehalton_dim << "\n";
		lowdisc_error ( msg.str() );
		return;
	}
	for ( idim = 0; idim < reversehalton_dim; idim++ )
	{
		if ( newbase[idim] < 1 ) 
		{
			ostringstream msg;
			msg << "reversehalton - reversehalton_baseset - Error!\n";
			msg << "  Negative prime base at index idim=" << idim << ", newbase[i] = " << newbase[idim] << "\n";
			lowdisc_error ( msg.str() );
			return;
		}
		reversehalton_base[idim] = newbase[idim];
	}

	return;
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
	for ( idim = 0; idim < reversehalton_dim; idim++ )
	{
		base[idim] = reversehalton_base[idim];
	}
	return;
}
//***************************************************************************
//  reversehalton_dimset --
//     sets the spatial dimension for a reverse Halton sequence.
//
//  Parameters:
//    base, dim_num : a positive integer, the dimension of the sequence
//
void reversehalton_dimset ( int dim_num )
{
	if ( reversehalton_dim < 1 ) 
	{
		ostringstream msg;
		msg << "reversehalton - reversehalton_dimset - Error!\n";
		msg << "  Negative dimension dim = " << dim_num << "\n";
		lowdisc_error ( msg.str() );
		return;
	}
	reversehalton_dim = dim_num;
	if ( reversehalton_base != NULL )
	{
		delete [] reversehalton_base;
	}
	reversehalton_base = new int[reversehalton_dim];
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
	return reversehalton_dim;
}

