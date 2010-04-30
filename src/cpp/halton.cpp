// Copyright (C) 2005-2007 - John Burkardt
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
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
//  These variables are accessible to the user via calls to set/get routines.
//
int *halton_BASE = NULL;
int *halton_LEAP = NULL;
int  halton_DIM_NUM = -1;
int *halton_SEED = NULL;
int  halton_STEP = -1;

// These are non-public functions

//    HALHAM_LEAP_CHECK checks LEAP for a Halton or Hammersley sequence.
bool halham_leap_check ( int dim_num, int leap[] );

//    HALHAM_N_CHECK checks N, the number of elements of a subsequence for a Halton or Hammersley sequence.
bool halham_n_check ( int n );

//    HALHAM_DIM_NUM_CHECK checks DIM_NUM for a Halton or Hammersley sequence.
bool halham_dim_num_check ( int dim_num );

//    HALHAM_SEED_CHECK checks SEED for a Halton or Hammersley sequence.
bool halham_seed_check ( int dim_num, int seed[] );

//    HALHAM_STEP_CHECK checks STEP for a Halton or Hammersley sequence.
bool halham_step_check ( int step );

//    HALHAM_WRITE writes a Halton or Hammersley dataset to a file.
void halham_write ( int dim_num, int n, int step, int seed[], int leap[], int base[], double r[], char *file_out_name );

//    HALTON_BASE_CHECK checks BASE for a Halton sequence.
bool halton_base_check ( int dim_num, int base[] );

//    GET_SEED returns a random seed for the random number generator.
int get_seed ( void );

//    I4_TO_HALTON computes one element of a leaped Halton subsequence.
void i4_to_halton ( int dim_num, int step, int seed[], int leap[], int base[], double r[] );

//    I4_TO_HALTON_SEQUENCE computes N elements of a leaped Halton subsequence.
void i4_to_halton_sequence ( int dim_num, int n, int step, int seed[], int leap[], int base[], double r[] );

//****************************************************************************80

int get_seed ( void )

//****************************************************************************80
//
//  Purpose:
//
//    GET_SEED returns a random seed for the random number generator.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    15 September 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int GET_SEED, a random seed value.
//
{
# define I4_MAX 2147483647
	time_t clock;
	int ihour;
	int imin;
	int isec;
	int seed;
	struct tm *lt;
	time_t tloc;
	//
	//  If the internal seed is 0, generate a value based on the time.
	//
	clock = time ( &tloc );
	lt = localtime ( &clock );
	//
	//  Hours is 1, 2, ..., 12.
	//
	ihour = lt->tm_hour;

	if ( 12 < ihour )
	{
		ihour = ihour - 12;
	}
	//
	//  Move Hours to 0, 1, ..., 11
	//
	ihour = ihour - 1;

	imin = lt->tm_min;

	isec = lt->tm_sec;

	seed = isec + 60 * ( imin + 60 * ihour );
	//
	//  We want values in [1,43200], not [0,43199].
	//
	seed = seed + 1;
	//
	//  Remap ISEED from [1,43200] to [1,IMAX].
	//
	seed = ( int ) 
		( ( ( double ) seed )
		* ( ( double ) I4_MAX ) / ( 60.0 * 60.0 * 12.0 ) );
	//
	//  Never use a seed of 0.
	//
	if ( seed == 0 )
	{
		seed = 1;
	}

	return seed;
# undef I4_MAX
}
//****************************************************************************80

bool halham_dim_num_check ( int dim_num )

//****************************************************************************80
//
//  Purpose:
//
//    HALHAM_DIM_NUM_CHECK checks DIM_NUM for a Halton or Hammersley sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 September 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension.
//    DIM_NUM must be positive.
//
//    Output, bool HALHAM_DIM_NUM_CHECK, is true if DIM_NUM is legal.
//
{
	bool value;

	if ( dim_num < 1 ) 
	{
		ostringstream msg;
		msg << "halton - HALHAM_DIM_NUM_CHECK - Error!\n";
		msg << "  DIM_NUM < 0.";
		msg << "  DIM_NUM = " << dim_num << "\n";
		lowdisc_error ( msg.str() );
		value = false;
	}
	else
	{
		value = true;
	}

	return value;
}
//****************************************************************************80

bool halham_leap_check ( int dim_num, int leap[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALHAM_LEAP_CHECK checks LEAP for a Halton or Hammersley sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 September 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension.
//
//    Input, int LEAP[DIM_NUM], the successive jumps in the sequence.
//    Each entry must be greater than 0.
//
//    Output, bool HALHAM_LEAP_CHECK, is true if LEAP is legal.
//
{
	int i;
	bool value;

	value = true;

	for ( i = 0; i < dim_num; i++ )
	{
		if ( leap[i] < 1 ) 
		{
			ostringstream msg;
			msg << "halton - HALHAM_LEAP_CHECK - Error!\n";
			msg << "  Leap entries must be greater than 0.\n";
			msg << "  leap[" << i << "] = " << leap[i] << "\n";
			lowdisc_error ( msg.str() );
			value = false;
			break;
		}
	}

	return value;
}
//****************************************************************************80

bool halham_n_check ( int n )

//****************************************************************************80
//
//  Purpose:
//
//    HALHAM_N_CHECK checks N for a Halton or Hammersley sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 September 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number of elements of the subsequence.
//    N must be positive.
//
//    Output, bool HALHAM_N_CHECK, is true if N is legal.
//
{
	bool value;

	if ( n < 1 ) 
	{
		ostringstream msg;
		msg << "halton - HALHAM_N_CHECK - Error!\n";
		msg << "  N < 0.";
		msg << "  N = " << n << "\n";
		lowdisc_error ( msg.str() );
		value = false;
	}
	else
	{
		value = true;
	}

	return value;
}
//****************************************************************************80

bool halham_seed_check ( int dim_num, int seed[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALHAM_SEED_CHECK checks SEED for a Halton or Hammersley sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 September 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension.
//
//    Input, int SEED[DIM_NUM], the sequence index
//    corresponding to STEP = 0.  Each entry must be 0 or greater.
//
//    Output, bool HALHAM_SEED_CHECK, is true if SEED is legal.
//
{
	int i;
	bool value;

	value = true;

	for ( i = 0; i < dim_num; i++ )
	{
		if ( seed[i] < 0 ) 
		{
			ostringstream msg;
			msg << "halton - HALHAM_SEED_CHECK - Error!\n";
			msg << "  SEED entries must be nonnegative.\n";
			msg << "  seed[" << i << "] = " << seed[i] << "\n";
			lowdisc_error ( msg.str() );
			value = false;
			break;
		}
	}

	return value;
}
//****************************************************************************80

bool halham_step_check ( int step )

//****************************************************************************80
//
//  Purpose:
//
//    HALHAM_STEP_CHECK checks STEP for a Halton or Hammersley sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 September 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int STEP, the index of the subsequence element.
//    STEP must be 1 or greater.
//
//    Output, bool HALHAM_STEP_CHECK, is true if STEP is legal.
//
{
	bool value;

	if ( step < 0 ) 
	{
		ostringstream msg;
		msg << "halton - HALHAM_STEP_CHECK - Error!\n";
		msg << "  STEP < 0.";
		msg << "  STEP = " << step << "\n";
		lowdisc_error ( msg.str() );
		value = false;
	}
	else
	{
		value = true;
	}

	return value;
}
//****************************************************************************80

void halham_write ( int dim_num, int n, int step, int seed[], int leap[], 
				   int base[], double r[], char *file_out_name )

				   //****************************************************************************80
				   //
				   //  Purpose:
				   //
				   //    HALHAM_WRITE writes a Halton or Hammersley dataset to a file.
				   //
				   //  Discussion:
				   //
				   //    The initial lines of the file are comments, which begin with a
				   //    "#" character.
				   //
				   //    Thereafter, each line of the file contains the DIM_NUM-dimensional
				   //    components of the next entry of the dataset.
				   //
				   //  Licensing:
				   //
				   //    This code is distributed under the GNU LGPL license. 
				   //
				   //  Modified:
				   //
				   //    16 September 2004
				   //
				   //  Author:
				   //
				   //    John Burkardt
				   //
				   //  Parameters:
				   //
				   //    Input, int DIM_NUM, the spatial dimension.
				   //
				   //    Input, int N, the number of elements in the subsequence.
				   //
				   //    Input, int STEP, the index of the subsequence element.
				   //    0 <= STEP is required.
				   //
				   //    Input, int SEED[DIM_NUM], the sequence index for STEP = 0.
				   //
				   //    Input, int LEAP[DIM_NUM], the successive jumps in the sequence.
				   //
				   //    Input, int BASE[DIM_NUM], the bases.
				   //
				   //    Input, double R[DIM_NUM*N], the points.
				   //
				   //    Input, char *FILE_OUT_NAME, the name of the output file.
				   //
{
	ofstream file_out;
	int i;
	int j;
	int mhi;
	int mlo;
	char *s;

	file_out.open ( file_out_name );

	if ( !file_out )
	{
		ostringstream msg;
		msg << "halton - HALHAM_WRITE - Error!\n";
		msg << "  Could not open the output file.\n";
		lowdisc_error ( msg.str() );
                return;
	}

	s = timestring ( );

	file_out << "#  " << file_out_name << "\n";
	file_out << "#  created by routine HALHAM_WRITE.CC" << "\n";
	file_out << "#  at " << s << "\n";
	file_out << "#\n";
	file_out << "#  DIM_NUM = " << setw(12) << dim_num << "\n";
	file_out << "#  N =    " << setw(12) << n    << "\n";
	file_out << "#  STEP = " << setw(12) << step << "\n";
	for ( mlo = 1; mlo <= dim_num; mlo = mlo + 5 )
	{
		mhi = i4_min ( mlo + 5 - 1, dim_num );
		if ( mlo == 1 )
		{
			file_out << "#  SEED = ";
		}
		else
		{
			file_out << "#         ";
		}
		for ( i = mlo; i <= mhi; i++ )
		{
			file_out << setw(12) << seed[i-1];
		}
		file_out << "\n";
	}
	for ( mlo = 1; mlo <= dim_num; mlo = mlo + 5 )
	{
		mhi = i4_min ( mlo + 5 - 1, dim_num );
		if ( mlo == 1 )
		{
			file_out << "#  LEAP = ";
		}
		else
		{
			file_out << "#         ";
		}
		for ( i = mlo; i <= mhi; i++ )
		{
			file_out << setw(12) << leap[i-1];
		}
		file_out << "\n";
	}
	for ( mlo = 1; mlo <= dim_num; mlo = mlo + 5 )
	{
		mhi = i4_min ( mlo + 5 - 1, dim_num );
		if ( mlo == 1 )
		{
			file_out << "#  BASE = ";
		}
		else
		{
			file_out << "#         ";
		}
		for ( i = mlo; i <= mhi; i++ )
		{
			file_out << setw(12) << base[i-1];
		}
		file_out << "\n";
	}
	file_out << "#  EPSILON (unit roundoff) = " << r8_epsilon ( ) << "\n";
	file_out << "#\n";

	for ( j = 0; j < n; j++ )
	{
		for ( i = 0; i < dim_num; i++ )
		{
			file_out << setw(10) << r[i+j*dim_num] << "  ";
		}
		file_out << "\n";
	}

	file_out.close ( );

	delete [] s;

	return;
}
//****************************************************************************80

void halton ( double r[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON computes the next element in a leaped Halton subsequence.
//
//  Discussion:
//
//    The DIM_NUM-dimensional Halton sequence is really DIM_NUM separate
//    sequences, each generated by a particular base.
//
//    This routine selects elements of a "leaped" subsequence of the 
//    Halton sequence.  The subsequence elements are indexed by a
//    quantity called STEP, which starts at 0.  The STEP-th subsequence 
//    element is simply element 
//
//      SEED(1:DIM_NUM) + STEP * LEAP(1:DIM_NUM) 
//
//    of the original Halton sequence.
//
//
//    This routine "hides" a number of input arguments.  To specify these
//    arguments explicitly, use I4_TO_HALTON instead.
//
//    All the arguments have default values.  However, if you want to
//    examine or change them, you may call the appropriate routine
//    before calling HALTON.
//
//    The arguments that the user may set include:
//
//    * DIM_NUM, the spatial dimension, 
//      Default: DIM_NUM = 1;
//      Required: 1 <= DIM_NUM is required.
//
//    * STEP, the subsequence index.
//      Default: STEP = 0.
//      Required: 0 <= STEP.
//
//    * SEED(1:DIM_NUM), the Halton sequence element corresponding to STEP = 0.
//      Default SEED = (0, 0, ... 0).  
//      Required: 0 <= SEED(1:DIM_NUM).
//
//    * LEAP(1:DIM_NUM), the succesive jumps in the Halton sequence.
//      Default: LEAP = (1, 1, ..., 1). 
//      Required: 1 <= LEAP(1:DIM_NUM).
//
//    * BASE(1:DIM_NUM), the Halton bases.
//      Default: BASE = (2, 3, 5, 7, 11, ... ). 
//      Required: 1 < BASE(1:DIM_NUM).
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    08 July 2004
//
//  Author:
//
//    John Burkardt
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
//  Parameters:
//
//    Output, double R[DIM_NUM], the next element of the leaped Halton
//    subsequence.
//
{
	int *base;
	int i;
	int dim_num;
	int *leap;
	int *seed;
	int step;

	if ( halton_DIM_NUM < 1 )
	{ 
		halton_DIM_NUM = 1;
	}

	if ( halton_STEP < 0 )
	{ 
		halton_STEP = 0;
	}

	if ( !halton_SEED )
	{
		halton_SEED = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_SEED[i] = 0;
		}
	}

	if ( !halton_LEAP )
	{
		halton_LEAP = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_LEAP[i] = 1;
		}
	}

	if ( !halton_BASE )
	{
		halton_BASE = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_BASE[i] = prime ( i + 1 );
		}
	}

	dim_num = halton_DIM_NUM;
	step = halton_STEP;
	seed = halton_SEED;
	leap = halton_LEAP;
	base = halton_BASE;

	i4_to_halton ( dim_num, step, seed, leap, base, r );

	halton_STEP = halton_STEP + 1;

	return;
}
//****************************************************************************80

bool halton_base_check ( int dim_num, int base[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_BASE_CHECK checks BASE for a Halton sequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension.
//
//    Input, int BASE[DIM_NUM], the bases.
//
//    Output, bool HALTON_BASE_CHECK, is true if BASE is legal.
//
{
	int i;
	bool value;

	value = true;

	for ( i = 0; i < dim_num; i++ )
	{
		if ( base[i] <= 1 ) 
		{
			ostringstream msg;
			msg << "halton - HALTON_BASE_CHECK - Error!\n";
			msg << "  Bases must be greater than 1.\n";
			msg << "  base[" << i << "] = " << base[i] << "\n";
			lowdisc_error ( msg.str() );
			value = false;
			break;
		}
	}

	return value;
}
//****************************************************************************80

int *halton_base_get ( void )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_BASE_GET gets the base vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    28 February 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int *HALTON_BASE_GET, a pointer to the Halton bases.
//
{
	return halton_BASE;
}
//****************************************************************************80

void halton_base_set ( int base[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_BASE_SET sets the base vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    28 February 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int BASE[HALTON_DIM_NUM], the Halton bases.
//    Each base must be greater than 1.
//
{
	int i;

	if ( !halton_base_check ( halton_DIM_NUM, base ) )
	{
		return;
	}

	for ( i = 0; i < halton_DIM_NUM; i++ )
	{
		halton_BASE[i] = base[i];
	}

	return;
}
//****************************************************************************80

int *halton_leap_get ( void )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_LEAP_GET gets the leap vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int *HALTON_LEAP_GET, a pointer to the successive jumps in
//    the Halton sequence.
//
{
	return halton_LEAP;
}
//****************************************************************************80

void halton_leap_set ( int leap[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_LEAP_SET sets the leap vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int LEAP[HALTON_DIM_NUM], the successive jumps in the Halton sequence.
//    Each entry must be greater than 0.
//
{
	int i;

	if ( !halham_leap_check ( halton_DIM_NUM, leap ) )
	{
		return;
	}

	for ( i = 0; i < halton_DIM_NUM; i++ )
	{
		halton_LEAP[i] = leap[i];
	}

	return;
}
//****************************************************************************80

int halton_dim_num_get ( void )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_DIM_NUM_GET gets the spatial dimension for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    28 February 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int HALTON_DIM_NUM_GET, the spatial dimension.
//
{
	return halton_DIM_NUM;
}
//****************************************************************************80

void halton_dim_num_set ( int dim_num )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_DIM_NUM_SET sets the spatial dimension for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    28 February 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int DIM_NUM, the spatial dimension.
//    DIM_NUM must be positive.
//
{
	int i;

	if ( !halham_dim_num_check ( dim_num ) ) 
	{
		return;
	}

	if ( halton_DIM_NUM != dim_num && 0 < halton_DIM_NUM )
	{
		delete [] halton_BASE;
		delete [] halton_LEAP;
		delete [] halton_SEED;
	}

	if ( halton_DIM_NUM != dim_num )
	{
		halton_DIM_NUM = dim_num;
		halton_SEED = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_SEED[i] = 0;
		}
		halton_LEAP = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_LEAP[i] = 1;
		}
		halton_BASE = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_BASE[i] = prime ( i + 1 );
		}
		halton_STEP = 0;
	}

	return;
}
//****************************************************************************80

int *halton_seed_get ( void )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_SEED_GET gets the seed vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int *HALTON_SEED_GET, a pointer to the Halton sequence index
//    corresponding to STEP = 0.
//
{
	return halton_SEED;
}
//****************************************************************************80

void halton_seed_set ( int seed[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_SEED_SET sets the seed vector for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int SEED[HALTON_DIM_NUM], the Halton sequence index
//    corresponding to STEP = 0.  Each entry must be 0 or greater.
//
{
	int i;

	if ( !halham_seed_check ( halton_DIM_NUM, seed ) )
	{
		return;
	}

	for ( i = 0; i < halton_DIM_NUM; i++ )
	{
		halton_SEED[i] = seed[i];
	}

	return;
}
//****************************************************************************80

void halton_sequence ( int n, double r[] )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_SEQUENCE computes N elements in an DIM_NUM-dimensional Halton sequence.
//
//  Discussion:
//
//    The DIM_NUM-dimensional Halton sequence is really DIM_NUM separate
//    sequences, each generated by a particular base.
//
//    This routine selects elements of a "leaped" subsequence of the 
//    Halton sequence.  The subsequence elements are indexed by a
//    quantity called STEP, which starts at 0.  The STEP-th subsequence 
//    element is simply element 
//
//      SEED(1:DIM_NUM) + STEP * LEAP(1:DIM_NUM) 
//
//    of the original Halton sequence.
//
//
//    This routine "hides" a number of input arguments.  To specify these
//    arguments explicitly, use the routine I4_TO_HALTON_SEQUENCE instead.
//
//    All the arguments have default values.  However, if you want to
//    examine or change them, you may call the appropriate routine first.
//
//    The arguments that the user may set include:
//
//    * DIM_NUM, the spatial dimension, 
//      Default: DIM_NUM = 1;
//      Required: 1 <= DIM_NUM is required.
//
//    * STEP, the subsequence index.
//      Default: STEP = 0.
//      Required: 0 <= STEP.
//
//    * SEED(1:DIM_NUM), the Halton sequence element corresponding to STEP = 0.
//      Default SEED = (0, 0, ... 0).  
//      Required: 0 <= SEED(1:DIM_NUM).
//
//    * LEAP(1:DIM_NUM), the succesive jumps in the Halton sequence.
//      Default: LEAP = (1, 1, ..., 1). 
//      Required: 1 <= LEAP(1:DIM_NUM).
//
//    * BASE(1:DIM_NUM), the Halton bases.
//      Default: BASE = (2, 3, 5, 7, 11, ... ). 
//      Required: 1 < BASE(1:DIM_NUM).
//
//
//    The data to be computed has two dimensions.
//
//    The number of data items is DIM_NUM * N, where DIM_NUM is the spatial dimension
//    of each element of the sequence, and N is the number of elements of the sequence.
//
//    The data is stored in a one dimensional array R.  The first element of the
//    sequence is stored in the first DIM_NUM entries of R, followed by the DIM_NUM entries
//    of the second element, and so on.
//
//    In particular, the J-th element of the sequence is stored in entries
//    0+(J-1)*DIM_NUM through (DIM_NUM-1) + (J-1)*DIM_NUM.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    08 July 2004
//
//  Author:
//
//    John Burkardt
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
//  Parameters:
//
//    Input, int N, the number of elements desired.
//
//    Output, double R[DIM_NUM*N], the next N elements of the Halton sequence.
//
{
	int *base;
	int i;
	int *leap;
	int dim_num;
	int *seed;
	int step;

	if ( halton_DIM_NUM < 1 )
	{ 
		halton_DIM_NUM = 1;
	}

	if ( halton_STEP < 0 )
	{ 
		halton_STEP = 0;
	}

	if ( !halton_SEED )
	{
		halton_SEED = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_SEED[i] = 0;
		}
	}

	if ( !halton_LEAP )
	{
		halton_LEAP = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_LEAP[i] = 1;
		}
	}

	if ( !halton_BASE )
	{
		halton_BASE = new int[halton_DIM_NUM];
		for ( i = 0; i < halton_DIM_NUM; i++ )
		{
			halton_BASE[i] = prime ( i + 1 );
		}
	}

	dim_num = halton_DIM_NUM;
	step = halton_STEP;
	seed = halton_SEED;
	leap = halton_LEAP;
	base = halton_BASE;

	i4_to_halton_sequence ( dim_num, n, step, seed, leap, base, r );

	halton_STEP = halton_STEP + n;

	return;
}
//****************************************************************************80

int halton_step_get ( void )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_STEP_GET gets the step for the leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Output, int HALTON_STEP_GET, the index of the subsequence element.
//
{
	return halton_STEP;
}
//****************************************************************************80

void halton_step_set ( int step )

//****************************************************************************80
//
//  Purpose:
//
//    HALTON_STEP_SET sets the step for a leaped Halton subsequence.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    06 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int STEP, the index of the subsequence element.
//    STEP must be 1 or greater.
//
{

	if ( !halham_step_check ( step ) ) 
	{
		return;
	}

	halton_STEP = step;

	return;
}
//****************************************************************************80

void i4_to_halton ( int dim_num, int step, int seed[], int leap[], int base[], 
				   double r[] )

{
	//****************************************************************************80
	//
	//  Purpose:
	//
	//    I4_TO_HALTON computes one element of a leaped Halton subsequence.
	//
	//  Licensing:
	//
	//    This code is distributed under the GNU LGPL license. 
	//
	//  Modified:
	//
	//    16 July 2004
	//
	//  Author:
	//
	//    John Burkardt
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
	//  Parameters:
	//
	//    Input, int DIM_NUM, the spatial dimension.
	//    1 <= DIM_NUM is required.
	//
	//    Input, int STEP, the index of the subsequence element.
	//    0 <= STEP is required.
	//
	//    Input, int SEED[DIM_NUM], the Halton sequence index corresponding 
	//    to STEP = 0.
	//    0 <= SEED(1:DIM_NUM) is required.
	//
	//    Input, int LEAP[DIM_NUM], the successive jumps in the Halton sequence.
	//    1 <= LEAP(1:DIM_NUM) is required.
	//
	//    Input, int BASE[DIM_NUM], the Halton bases.
	//    1 < BASE(1:DIM_NUM) is required.
	//
	//    Output, double R[DIM_NUM], the STEP-th element of the leaped 
	//    Halton subsequence.
	//

	double base_inv;
	int digit;
	int i;
	int seed2;
	//
	//  Check the input.
	//
	if ( !halham_dim_num_check ( dim_num ) )
	{
		return;
	}

	if ( !halham_step_check ( step ) )
	{
		return;
	}

	if ( !halham_seed_check ( dim_num, seed ) )
	{
		return;
	}

	if ( !halham_leap_check ( dim_num, leap ) )
	{
		return;
	}

	if ( !halton_base_check ( dim_num, base ) )
	{
		return;
	}
	//
	//  Calculate the data.
	//
	for ( i = 0; i < dim_num; i++ )
	{
		seed2 = seed[i] + step * leap[i];

		r[i] = 0.0;

		base_inv = 1.0 / ( ( double ) base[i] );

		while ( seed2 != 0 )
		{
			digit = seed2 % base[i];
			r[i] = r[i] + ( ( double ) digit ) * base_inv;
			base_inv = base_inv / ( ( double ) base[i] );
			seed2 = seed2 / base[i];
		}
	}

	return;
}
//****************************************************************************80

void i4_to_halton_sequence ( int dim_num, int n, int step, int seed[], 
							int leap[], int base[], double r[] )
{
	//****************************************************************************80
	//
	//  Purpose:
	//
	//    I4_TO_HALTON_SEQUENCE computes N elements of a leaped Halton subsequence.
	//
	//  Discussion:
	//
	//    The DIM_NUM-dimensional Halton sequence is really DIM_NUM separate
	//    sequences, each generated by a particular base.
	//
	//    This routine selects elements of a "leaped" subsequence of the
	//    Halton sequence.  The subsequence elements are indexed by a
	//    quantity called STEP, which starts at 0.  The STEP-th subsequence
	//    element is simply element
	//
	//      SEED(1:DIM_NUM) + STEP * LEAP(1:DIM_NUM)
	//
	//    of the original Halton sequence.
	//
	//
	//    The data to be computed has two dimensions.
	//
	//    The number of data items is DIM_NUM * N, where DIM_NUM is the spatial dimension
	//    of each element of the sequence, and N is the number of elements of the sequence.
	//
	//    The data is stored in a one dimensional array R.  The first element of the
	//    sequence is stored in the first DIM_NUM entries of R, followed by the DIM_NUM entries
	//    of the second element, and so on.
	//
	//    In particular, the J-th element of the sequence is stored in entries
	//    0+(J-1)*DIM_NUM through (DIM_NUM-1) + (J-1)*DIM_NUM.
	//
	//  Licensing:
	//
	//    This code is distributed under the GNU LGPL license. 
	//
	//  Modified:
	//
	//    16 July 2004
	//
	//  Author:
	//
	//    John Burkardt
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
	//  Parameters:
	//
	//    Input, int DIM_NUM, the spatial dimension.
	//
	//    Input, int N, the number of elements of the sequence.
	//
	//    Input, int STEP, the index of the subsequence element.
	//    0 <= STEP is required
	//
	//    Input, int SEED[DIM_NUM], the Halton sequence index corresponding
	//    to STEP = 0. 
	//
	//    Input, int LEAP[DIM_NUM], the succesive jumps in the Halton sequence.
	//
	//    Input, int BASE[DIM_NUM], the Halton bases.
	//
	//    Output, double R[DIM_NUM*N], the next N elements of the
	//    leaped Halton subsequence, beginning with element STEP.
	//
	double base_inv;
	int digit;
	int i;
	int j;
	int *seed2;
	//
	//  Check the input.
	//
	if ( !halham_dim_num_check ( dim_num ) )
	{
		return;
	}

	if ( !halham_n_check ( n ) )
	{
		return;
	}

	if ( !halham_step_check ( step ) )
	{
		return;
	}

	if ( !halham_seed_check ( dim_num, seed ) )
	{
		return;
	}

	if ( !halham_leap_check ( dim_num, leap ) )
	{
		return;
	}

	if ( !halton_base_check ( dim_num, base ) )
	{
		return;
	}
	//
	//  Calculate the data.
	//
	seed2 = new int[n];

	for ( i = 0; i < dim_num; i++ )
	{
		for ( j = 0; j < n; j++ )
		{
			seed2[j] = seed[i] + ( step + j ) * leap[i];
		}

		for ( j = 0; j < n; j++ )
		{
			r[i+j*dim_num] = 0.0;
		}

		for ( j = 0; j < n; j++ )
		{
			base_inv = 1.0 / ( ( double ) base[i] );

			while ( seed2[j] != 0 )
			{
				digit = seed2[j] % base[i];
				r[i+j*dim_num] = r[i+j*dim_num] + ( ( double ) digit ) * base_inv;
				base_inv = base_inv / ( ( double ) base[i] );
				seed2[j] = seed2[j] / base[i];
			}
		}
	}

	delete [] seed2;

	return;
}
