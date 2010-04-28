// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

# include <cstdlib>
# include <cmath>
# include <ctime>
# include <iostream>
# include <fstream>
# include <iomanip>

using namespace std;

#include "reversehalton.h"

//  reversehalton --
//     computes the next element in a reverse Halton subsequence.
//  Licensing:
//    This code is distributed under the GNU LGPL license. 
//  Author:
//    Michael Baudin
//  Reference:
//
// B. Vandewoestyne and R. Cools, 
// Good permutations for deterministic scrambled Halton
// sequences in terms of L2-discrepancy, Computational and Applied
// Mathematics 189, 2006
// See also O. Teytaud, 2007, Gnu Scientific Library
//
//  Parameters:
//
//    Input, int dim, the number of dimensions
//    Input, int primes[], a table of dim primes
//    Input, int iter, the current iteration index
//    Output, double next[dim], the next element of the reverse Halton sequence.
//
void reversehalton ( int dim, int primes[], int iter, double next[] )
{
  int basis;
  for ( idim = 0; idim < dim; idim++ )
  {
    basis = primes(idim);
    next[idim] = vdcinv ( iter , basis );
  }
  return;
}
//
// vdcinv --
//   Returns the term #iter of the inverted Van Der Corput low discrepancy sequence in 
//   given basis.
// Arguments, input
//   iter : the index in the sequence
//   basis : the basis of the sequence
// Arguments, output
//   result : the next element in the sequence, uniform in [0,1]
//
double vdcinv ( int iter , int basis )
{
  double result;
  int current;
  // ib = inverse of the basis : 1/b, 1/b^2, 1/b^3, etc...
  double ib;
  int digit;
  current = iter;
  ib = 1.0 / (double) basis;
  result = 0.0;
  while (current>0)
  {
    digit = current % basis;
    current = ( int ) ( current / basis );
    if ( digit /= 0 ) 
    {
      result = result + ( basis - digit ) * ib;
    }
    ib = ib / basis;
  }
  return result;
}

