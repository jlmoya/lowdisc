// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_FAURE_D_H_
#define _LOWDISC_FAURE_D_H_

#ifdef _MSC_VER
#if LIBLOWDISC_EXPORTS 
#define LOWDISC_IMPORTEXPORT __declspec (dllexport)
#else
#define LOWDISC_IMPORTEXPORT __declspec (dllimport)
#endif
#else
#define LOWDISC_IMPORTEXPORT
#endif

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

__BEGIN_DECLS

	//! Class of Faure Sequence
class LOWDISC_IMPORTEXPORT Faure {
public:

	// Constructor
	//
	//  Purpose:
	//
	//    Startup the sequence.
	//    Setup the following parameters : 
	//	  faure_startup = true;
	//    hisum_save = -1
	//    qs the smallest prime greater than faure_dim_num
	//	
	//  Parameters:
	//
	//    Input, int faure_dim_num, the spatial dimension, which should be
	//    at least 2.
	//
	//    Input, int basis, the basis of the Faure sequence.
	//	  If basis is nonzero and positive,
	//	  then it is used as a basis. 
	//    The basis must be the smallest prime greater than faure_dim_num.
	//
	Faure ( int dim_num , int basis );

	// Destructor
//	  Deletes the unnecessary memory.
	~Faure ( );

	// next -- 
	// generates a new quasirandom Faure vector with each call.
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
	void next ( int *seed, double quasi[] );

	// baseget -- 
	// returns the base used by the Faure sequence.
	int baseget ( );

	// dimget --
	// gets the spatial dimension for a Faure sequence.
	//
	//  Parameters:
	//    dim, output : an integer, the dimension of the sequence
	//
	int dimget ( void );
private:
	// Private methods

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
	int * Faure::binomial_table ( int qs, int m, int n );

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
	int Faure::i4_log_i4 ( int i4, int j4 );

	// Initialize private fields
	void Faure::init ();

	// Private fields
	int faure_dim_num;
	int *faure_coef;
	int faure_hisum_save;
	int faure_qs;
	int *faure_ytemp;

};

__END_DECLS

#endif /* _LOWDISC_FAURE_D_H_ */

