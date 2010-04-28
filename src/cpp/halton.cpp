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
static int *halton_BASE = NULL;
static int *halton_LEAP = NULL;
static int  halton_DIM_NUM = -1;
static int *halton_SEED = NULL;
static int  halton_STEP = -1;

// These are non-public functions
bool halham_leap_check ( int dim_num, int leap[] );
bool halham_n_check ( int n );
bool halham_dim_num_check ( int dim_num );
bool halham_seed_check ( int dim_num, int seed[] );
bool halham_step_check ( int step );
void halham_write ( int dim_num, int n, int step, int seed[], int leap[], int base[], double r[], char *file_out_name );
bool halton_base_check ( int dim_num, int base[] );

double arc_cosine ( double c );
double atan4 ( double y, double x );
char digit_to_ch ( int i );
int get_seed ( void );
int i4_log_10 ( int i );
void i4_to_halton ( int dim_num, int step, int seed[], int leap[], int base[], double r[] );
void i4_to_halton_sequence ( int dim_num, int n, int step, int seed[], int leap[], int base[], double r[] );
char *i4_to_s ( int i );
void i4vec_transpose_print ( int n, int a[], char *title );
double r8vec_dot_product ( int n, double *r1, double *r2 );
double r8vec_norm_l2 ( int n, double a[] );
int s_len_trim ( char *s );
void u1_to_sphere_unit_2d ( double u[1], double x[2] );
void u2_to_ball_unit_2d ( double u[2], double x[2] );
void u2_to_sphere_unit_3d ( double u[2], double x[3] );
void u3_to_ball_unit_3d ( double u[3], double x[3] );

//****************************************************************************80

double arc_cosine ( double c )

//****************************************************************************80
//
//  Purpose:
//
//    ARC_COSINE computes the arc cosine function, with argument truncation.
//
//  Discussion:
//
//    If you call your system ACOS routine with an input argument that is
//    outside the range [-1.0, 1.0 ], you may get an unpleasant surprise.
//    This routine truncates arguments outside the range.
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
//    Input, double C, the argument, which is usually between -1 and 1.
//
//    Output, double ARC_COSINE, an angle whose cosine is C.
//
{
	double pi = 3.141592653589793;

	if ( c < -1.0 )
	{
		return -pi;
	}
	else if ( 1.0 < c )
	{
		return 0.0;
	}
	else
	{
		return acos ( c );
	}
}
//****************************************************************************80

double atan4 ( double y, double x )

//****************************************************************************80
//
//  Purpose:
//
//    ATAN4 computes the inverse tangent of the ratio Y / X.
//
//  Discussion:
//
//    ATAN4 returns an angle whose tangent is ( Y / X ), a job which
//    the built in functions ATAN and ATAN2 already do.  
//
//    However:
//
//    * ATAN4 always returns a positive angle, between 0 and 2 PI, 
//      while ATAN and ATAN2 return angles in the interval [-PI/2,+PI/2]
//      and [-PI,+PI] respectively;
//
//    * ATAN4 accounts for the signs of X and Y, (as does ATAN2).  The ATAN 
//     function by contrast always returns an angle in the first or fourth
//     quadrants.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    18 April 1999
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, double Y, X, two quantities which represent the tangent of
//    an angle.  If Y is not zero, then the tangent is (Y/X).
//
//    Output, double ATAN4, a positive angle whose tangent is (Y/X), and
//    which lies in the appropriate quadrant so that the signs of its
//    cosine and sine match those of X and Y.
//
{
	double abs_x;
	double abs_y;
	double pi = 3.141592653589793;
	double theta;
	double theta_0;
	//
	//  Special cases:
	//
	if ( x == 0.0 )
	{
		if ( 0.0 < y )
		{
			theta = pi / 2.0;
		}
		else if ( y < 0.0 )
		{
			theta = 3.0 * pi / 2.0;
		}
		else
		{
			theta = 0.0;
		}

	}
	else if ( y == 0.0 )
	{
		if ( 0.0 < x )
		{
			theta = 0.0;
		}
		else if ( x < 0.0 )
		{
			theta = pi;
		}

	}
	//
	//  We assume that ATAN2 is correct when both arguments are positive.
	//
	else
	{
		abs_y = fabs ( y );
		abs_x = fabs ( x );

		theta_0 = atan2 ( abs_y, abs_x );

		if ( 0.0 < x && 0.0 < y )
		{
			theta = theta_0;
		}
		else if ( x < 0.0 && 0.0 < y )
		{
			theta = pi - theta_0;
		}
		else if ( x < 0.0 && y < 0.0 )
		{
			theta = pi + theta_0;
		}
		else if ( 0.0 < x && y < 0.0 )
		{
			theta = 2.0 * pi - theta_0;
		}
	}

	return theta;
}
//****************************************************************************80

char digit_to_ch ( int i )

//****************************************************************************80
//
//  Purpose:
//
//    DIGIT_TO_CH returns the base 10 digit character corresponding to a digit.
//
//  Example:
//
//     I     C
//   -----  ---
//     0    '0'
//     1    '1'
//   ...    ...
//     9    '9'  
//    10    '*'
//   -83    '*'
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    16 June 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int I, the digit, which should be between 0 and 9.
//
//    Output, char DIGIT_TO_CH, the appropriate character '0' through '9' or '*'.
//
{
	char c;

	if ( 0 <= i && i <= 9 )
	{
		c = '0' + i;
	}
	else
	{
		c = '*';
	}

	return c;
}
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
		msg << "\n";
		msg << "HALHAM_DIM_NUM_CHECK - Fatal error!\n";
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
			msg << "\n";
			msg << "HALHAM_LEAP_CHECK - Fatal error!\n";
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
		msg << "\n";
		msg << "HALHAM_N_CHECK - Fatal error!\n";
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
			msg << "\n";
			msg << "HALHAM_SEED_CHECK - Fatal error!\n";
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
		msg << "\n";
		msg << "HALHAM_STEP_CHECK - Fatal error!\n";
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
		msg << "\n";
		msg << "HALHAM_WRITE - Fatal error!\n";
		msg << "  Could not open the output file.\n";
		lowdisc_error ( msg.str() );
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
			msg << "\n";
			msg << "HALTON_BASE_CHECK - Fatal error!\n";
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

int i4_log_10 ( int i )

//****************************************************************************80
//
//  Purpose:
//
//    I4_LOG_10 returns the whole part of the logarithm base 10 of an I4.
//
//  Discussion:
//
//    It should be the case that 10^I4_LOG_10(I) <= |I| < 10^(I4_LOG_10(I)+1).
//    (except for I = 0).
//
//    The number of decimal digits in I is I4_LOG_10(I) + 1.
//
//  Example:
//
//        I    I4_LOG_10(I)
//
//        0     0
//        1     0
//        2     0
//
//        9     0
//       10     1
//       11     1
//
//       99     1
//      100     2
//      101     2
//
//      999     2
//     1000     3
//     1001     3
//
//     9999     3
//    10000     4
//    10001     4
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    17 June 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int I, the integer.
//
//    Output, int I4_LOG_10, the whole part of the logarithm of abs ( I ).
//
{
	int ten_pow;
	int value;

	i = abs ( i );

	ten_pow = 10;
	value = 0;

	while ( ten_pow <= i )
	{
		ten_pow = ten_pow * 10;
		value = value + 1;
	}

	return value;
}
//****************************************************************************80

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
//****************************************************************************80

char *i4_to_s ( int i )

//****************************************************************************80
//
//  Purpose:
//
//    I4_TO_S converts an integer to a string.
//
//  Example:
//
//    INTVAL  S
//
//         1  1
//        -1  -1
//         0  0
//      1952  1952
//    123456  123456
//   1234567  1234567
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    13 March 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int I, an integer to be converted.
//
//    Output, char *I4_TO_S, the representation of the integer.
//
{
	int digit;
	int j;
	int length;
	int ten_power;
	char *s;

	length = i4_log_10 ( i );

	ten_power = ( int ) pow ( ( double ) 10, ( double ) length );

	if ( i < 0 )
	{
		length = length + 1;
	}
	//
	//  Add one position for the trailing null.
	//
	length = length + 1;

	s = new char[length];

	if ( i == 0 )
	{
		s[0] = '0';
		s[1] = '\0';
		return s;
	}
	//
	//  Now take care of the sign.
	//
	j = 0;
	if ( i < 0 )
	{
		s[j] = '-';
		j = j + 1;
		i = abs ( i );
	}
	//
	//  Find the leading digit of I, strip it off, and stick it into the string.
	//
	while ( 0 < ten_power )
	{
		digit = i / ten_power;
		s[j] = digit_to_ch ( digit );
		j = j + 1;
		i = i - digit * ten_power;
		ten_power = ten_power / 10;
	}
	//
	//  Tack on the trailing NULL.
	//
	s[j] = '\0';
	j = j + 1;

	return s;
}
//****************************************************************************80

void i4vec_transpose_print ( int n, int a[], char *title )

//****************************************************************************80
//
//  Purpose:
//
//    I4VEC_TRANSPOSE_PRINT prints an I4VEC "transposed".
//
//  Example:
//
//    A = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
//    TITLE = "My vector:  "
//
//    My vector:      1    2    3    4    5
//                    6    7    8    9   10
//                   11
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    03 July 2004
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number of components of the vector.
//
//    Input, int A[N], the vector to be printed.
//
//    Input, char *TITLE, a title to be printed first.
//    TITLE may be blank or NULL.
//
{
	int i;
	int ihi;
	int ilo;
	int title_len;

	if ( 0 < s_len_trim ( title ) )
	{
		title_len = strlen ( title );

		for ( ilo = 1; ilo <= n; ilo = ilo + 5 )
		{
			ihi = i4_min ( ilo + 5 - 1, n );
			if ( ilo == 1 )
			{
				cout << title;
			}
			else
			{
				for ( i = 1; i <= title_len; i++ )
				{
					cout << " ";
				}
			}
			for ( i = ilo; i <= ihi; i++ )
			{
				cout << setw(12) << a[i-1];
			}
			cout << "\n";
		}
	}
	else
	{
		for ( ilo = 1; ilo <= n; ilo = ilo + 5 )
		{
			ihi = i4_min ( ilo + 5 - 1, n );
			for ( i = ilo; i <= ihi; i++ )
			{
				cout << setw(12) << a[i-1];
			}
			cout << "\n";
		}
	}

	return;
}
//****************************************************************************80

//****************************************************************************80

double r8vec_dot_product ( int n, double *r1, double *r2 )

//****************************************************************************80
//
//  Purpose:
//
//    R8VEC_DOT_PRODUCT returns the dot product of two R8VEC's.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    01 March 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number of entries in the arrays.
//
//    Input, double *R1, R2, pointers to the first entries of the arrays.
//
//    Output, double R8VEC_DOT_PRODUCT, the dot product of the two arrays.
//
{
	int i;
	double dot;

	dot = 0.0;

	for ( i = 0; i < n; i++ ) 
	{
		dot = dot + (*r1) * (*r2);
		r1 = r1 + 1;
		r2 = r2 + 1;
	}

	return dot;

}
//****************************************************************************80

double r8vec_norm_l2 ( int n, double a[] )

//****************************************************************************80
//
//  Purpose:
//
//    R8VEC_NORM_L2 returns the L2 norm of an R8VEC.
//
//  Discussion:
//
//    The vector L2 norm is defined as:
//
//      sqrt ( sum ( 1 <= I <= N ) A(I)**2 ).
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    01 March 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, int N, the number of entries in A.
//
//    Input, double A[N], the vector whose L2 norm is desired.
//
//    Output, double R8VEC_NORM_L2, the L2 norm of A.
//
{
	int i;
	double v;

	v = 0.0;

	for ( i = 0; i < n; i++ )
	{
		v = v + a[i] * a[i];
	}
	v = sqrt ( v );

	return v;
}
//****************************************************************************80

int s_len_trim ( char *s )

//****************************************************************************80
//
//  Purpose:
//
//    S_LEN_TRIM returns the length of a string to the last nonblank.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license. 
//
//  Modified:
//
//    26 April 2003
//
//  Author:
//
//    John Burkardt
//
//  Parameters:
//
//    Input, char *S, a pointer to a string.
//
//    Output, int S_LEN_TRIM, the length of the string to the last nonblank.
//    If S_LEN_TRIM is 0, then the string is entirely blank.
//
{
	int n;
	char* t;

	n = strlen ( s );
	t = s + strlen ( s ) - 1;

	while ( 0 < n ) 
	{
		if ( *t != ' ' )
		{
			return n;
		}
		t--;
		n--;
	}

	return n;
}
//****************************************************************************80

void u1_to_sphere_unit_2d ( double u[], double x[2] )

//****************************************************************************80
//
//  Purpose:
//
//    U1_TO_SPHERE_UNIT_2D maps a point in the unit interval onto the circle in 2D.
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
//    Input, double U[1], a point in the unit interval.
//
//    Output, double X[2], the corresponding point on the unit circle.
//
{
	double angle;
	double pi = 3.141592653589793;

	angle = 2.0 * pi * u[0];

	x[0] = cos ( angle );
	x[1] = sin ( angle );

	return;
}
//****************************************************************************80

void u2_to_ball_unit_2d ( double u[2], double x[2] )

//****************************************************************************80
//
//  Purpose:
//
//    U2_TO_BALL_UNIT_2D maps points from the unit box to the unit ball in 2D.
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
//    Input, double U[2], a point in the unit box.
//
//    Output, double X[2], the corresponding point in the unit ball.
//
{
	double pi = 3.141592653589793;
	double r;
	double theta;

	r = sqrt ( u[0] );
	theta = 2.0 * pi * u[1];

	x[0] = r * cos ( theta );
	x[1] = r * sin ( theta );

	return;
}
//****************************************************************************80

void u2_to_sphere_unit_3d ( double u[2], double x[3] )

//****************************************************************************80
//
//  Purpose:
//
//    U2_TO_SPHERE_UNIT_3D maps a point in the unit box to the unit sphere in 3D.
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
//    Input, double U[2], a point in the unit box.
//
//    Output, double X[3], the corresponding point on the unit sphere.
//
{
	double phi;
	double pi = 3.141592653589793;
	double theta;
	double vdot;
	//
	//  Pick a uniformly random VDOT, which must be between -1 and 1.
	//  This represents the dot product of the random vector with the Z unit vector.
	//
	//  Note: this works because the surface area of the sphere between
	//  Z and Z + dZ is independent of Z.  So choosing Z uniformly chooses
	//  a patch of area uniformly.
	//
	vdot = 2.0 * u[0] - 1.0;

	phi = arc_cosine ( vdot );
	//
	//  Pick a uniformly random rotation between 0 and 2 Pi around the
	//  axis of the Z vector.
	//
	theta = 2.0 * pi * u[1];

	x[0] = cos ( theta ) * sin ( phi );
	x[1] = sin ( theta ) * sin ( phi );
	x[2] = cos ( phi );

	return;
}
//****************************************************************************80

void u3_to_ball_unit_3d ( double u[3], double x[3] )

//****************************************************************************80
//
//  Purpose:
//
//    U3_TO_BALL_UNIT_3D maps points from the unit box to the unit ball in 3D.
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
//    Input, double U[3], a point in the unit box.
//
//    Output, double X[3], the corresponding point in the unit ball.
//
{
	double phi;
	double pi = 3.141592653589793;
	double r;
	double theta;
	double vdot;
	//
	//  Pick a uniformly random VDOT, which must be between -1 and 1.
	//  This represents the dot product of the random vector with the Z unit vector.
	//
	//  Note: this works because the surface area of the sphere between
	//  Z and Z + dZ is independent of Z.  So choosing Z uniformly chooses
	//  a patch of area uniformly.
	//
	vdot = 2.0 * u[0] - 1.0;

	phi = arc_cosine ( vdot );
	//
	//  Pick a uniformly random rotation between 0 and 2 Pi around the
	//  axis of the Z vector.
	//
	theta = 2.0 * pi * u[1];
	//
	//  Pick a random radius R.
	//
	r = pow ( ( double ) u[2], ( double ) ( 1.0 / 3.0 ) );

	x[0] = r * cos ( theta ) * sin ( phi );
	x[1] = r * sin ( theta ) * sin ( phi );
	x[2] = r * cos ( phi );

	return;
}
