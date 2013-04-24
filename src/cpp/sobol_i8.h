// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_SOBOL_D_H_
#define _LOWDISC_SOBOL_D_H_

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

#define I8SOBOL_DIM_MAX2 1111
#define I8SOBOL_LOG_MAX 62

// http://people.sc.fsu.edu/~burkardt/cpp_src/sobol/sobol.C
//
// SOBOL
//
// The Sobol Quasirandom Sequence 
//  Reference:
//
//    IA Antonov, VM Saleev,
//    An Economic Method of Computing LP Tau-Sequences,
//    USSR Computational Mathematics and Mathematical Physics,
//    Volume 19, 1980, pages 252 - 256.
//
//    Paul Bratley, Bennett Fox,
//    Algorithm 659:
//    Implementing Sobol's Quasirandom Sequence Generator,
//    ACM Transactions on Mathematical Software,
//    Volume 14, Number 1, pages 88-100, 1988.
//
//    Bennett Fox,
//    Algorithm 647:
//    Implementation and Relative Efficiency of Quasirandom 
//    Sequence Generators,
//    ACM Transactions on Mathematical Software,
//    Volume 12, Number 4, pages 362-376, 1986.
//
//    Stephen Joe, Frances Kuo
//    Remark on Algorithm 659:
//    Implementing Sobol's Quasirandom Sequence Generator,
//    ACM Transactions on Mathematical Software,
//    Volume 29, Number 1, pages 49-57, March 2003.
//
//    Ilya Sobol,
//    USSR Computational Mathematics and Mathematical Physics,
//    Volume 16, pages 236-242, 1977.
//
//    Ilya Sobol, YL Levitan, 
//    The Production of Points Uniformly Distributed in a Multidimensional 
//    Cube (in Russian),
//    Preprint IPM Akad. Nauk SSSR, 
//    Number 40, Moscow 1976.
//
	//! Class of Sobol Sequence
class LOWDISC_IMPORTEXPORT Sobol {
public:

	//
	// Startup the Sobol sequence.
	Sobol ( int dim_num );

	// Destructor
	~Sobol();

	//    next --
	// generates a new quasirandom Sobol vector with each call.
	//    This function is able to generate at most 
	//    2^62-1 = 4 611 686 018 427 387 903
	//    experiments in dimension 1111.
	//
	//  Discussion:
	//
	//    The routine adapts the ideas of Antonov and Saleev.
	//
	//    This routine uses LONG LONG INT for integers and DOUBLE for real values.
	//
	//    Thanks to Steffan Berridge for supplying (twice) the properly
	//    formatted V data needed to extend the original routine's dimension
	//    limit from 40 to 1111, 05 June 2007.
	//
	//    Thanks to Francis Dalaudier for pointing out that the range of allowed
	//    values of DIM_NUM should start at 1, not 2!  17 February 2009.
	//
	//  Modified:
	//
	//    17 February 2009
	//
	//  Author:
	//
	//    FORTRAN77 original version by Bennett Fox.
	//    C++ version by John Burkardt
	//
	//  Parameters:
	//
	//    Input, int DIM_NUM, the number of spatial dimensions.
	//    DIM_NUM must satisfy 1 <= DIM_NUM <= 1111.
	//
	//    Input/output, long long int *SEED, the "seed" for the sequence.
	//    This is essentially the index in the sequence of the quasirandom
	//    value to be generated.  On output, SEED has been set to the
	//    appropriate next value, usually simply SEED+1.
	//    If SEED is less than 0 on input, it is treated as though it were 0.
	//    An input value of 0 requests the first (0-th) element of the sequence.
	//
	//    Output, double QUASI[DIM_NUM], the next quasirandom vector.
	void next ( long long int *seed, double quasi[ ] );

	// dimget --
	// Returns the dimension.
	//
	//  Parameters:
	//    dim, output : an integer, the dimension of the sequence
	int dimget ( );

private:
	//
	// Fields
	//
	//
	// Parameters for i8_sobol
	//
	int i8sobol_dim_num;
	long long int i8sobol_lastq[I8SOBOL_DIM_MAX2];
	long long int i8sobol_maxcol;
	long long int i8sobol_poly[I8SOBOL_DIM_MAX2];
	double i8sobol_recipd;
	long long int i8sobol_seed_save;
	long long int i8sobol_v[I8SOBOL_DIM_MAX2][I8SOBOL_LOG_MAX];
};

__END_DECLS

#endif /* _LOWDISC_SOBOL_D_H_ */

