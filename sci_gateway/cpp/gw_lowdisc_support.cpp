
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin

#include <limits.h>

extern "C" {
#include "stack-c.h" 
#include "Scierror.h"
#include "localization.h"
}

#include "gw_lowdisc_support.h" 

// 
// lowdisc_AssertNumberOfRows --
//   Reports a wrong number of rows error in Scilab if the actual number of rows 
//   is not equal to the expected number of rows.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   expected_nrows : the expected number of rows
//   actual_nrows : the actual number of rows
//
int lowdisc_AssertNumberOfRows ( char * fname , int ivar , int expected_nrows , int actual_nrows )
{
	if ( expected_nrows != actual_nrows )
	{
		Scierror(999,_("%s: Wrong number of columns in argument #%d: found %d rows but %d rows expected.\n"),fname,ivar , actual_nrows , expected_nrows );
		return 0;
	} else {
		return 1;
	}
}

// 
// lowdisc_AssertNumberOfColumns --
//   Reports a wrong number of columns error in Scilab if the actual number of rows 
//   is not equal to the expected number of rows.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   expected_ncols : the expected number of columns
//   actual_ncols : the actual number of columns
//
int lowdisc_AssertNumberOfColumns ( char * fname , int ivar , int expected_ncols , int actual_ncols )
{
	if ( expected_ncols != actual_ncols )
	{
		Scierror(999,_("%s: Wrong number of columns in argument #%d: found %d columns but %d columns expected.\n"),fname,ivar , actual_ncols , expected_ncols );
		return 0;
	} else {
		return 1;
	}
}

// 
// lowdisc_AssertVartype --
//   Reports a wrong type error in Scilab if the actual variable type does not 
//   match the expected variable type.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   expected_type : the expected number of columns
//
int lowdisc_AssertVariableType ( char * fname , int ivar , int expected_type )
{
	if ( GetType(ivar) != expected_type )
	{
		if ( expected_type = sci_strings ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: String expected.\n"),fname,ivar);
		} else if ( expected_type = sci_matrix ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Matrix expected.\n"),fname,ivar);
		} else if ( expected_type = sci_poly ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Polynomial expected.\n"),fname,ivar);
		} else if ( expected_type = sci_boolean ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Boolean expected.\n"),fname,ivar);
		} else if ( expected_type = sci_sparse ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Sparse expected.\n"),fname,ivar);
		} else if ( expected_type = sci_matlab_sparse ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Matlab Sparse expected.\n"),fname,ivar);
		} else if ( expected_type = sci_ints ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Integer expected.\n"),fname,ivar);
		} else if ( expected_type = sci_handles ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Handle expected.\n"),fname,ivar);
		} else if ( expected_type = sci_u_function ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: U-Function expected.\n"),fname,ivar);
		} else if ( expected_type = sci_c_function ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: C-Function expected.\n"),fname,ivar);
		} else if ( expected_type = sci_lib ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Library expected.\n"),fname,ivar);
		} else if ( expected_type = sci_list ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: List expected.\n"),fname,ivar);
		} else if ( expected_type = sci_tlist ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: TList expected.\n"),fname,ivar);
		} else if ( expected_type = sci_mlist ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: MList expected.\n"),fname,ivar);
		} else if ( expected_type = sci_lufact_pointer ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: LUFACT expected.\n"),fname,ivar);
		//} else if ( expected_type = sci_implicit_poly ) {
			//Scierror(204,_("%s: Wrong type for input argument #%d: Implicit polynomial expected.\n"),fname,ivar);
		//} else if ( expected_type = sci_intrinsic_function ) {
			//Scierror(204,_("%s: Wrong type for input argument #%d: Intrinsic function expected.\n"),fname,ivar);
		} else {
			Scierror(204,_("%s: Wrong type for input argument #%d: <Unknown data type> expected.\n"),fname,ivar);
		}
		return 0;
	} else {
		return 1;
	}
}

// 
// lowdisc_GetOneDoubleArgument --
//   Gets one double precision number from the argument #ivar in the function fname.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to get
//
int lowdisc_GetOneDoubleArgument ( char * fname , int ivar , double * value )
{
	int nRows, nCols;
	double * mydata = NULL;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_matrix) == 0 )
	{
		return 0;
	}
	GetRhsVarMatrixDouble(ivar, &nRows, &nCols, &mydata);
	if ( lowdisc_AssertNumberOfRows(fname , ivar , 1 , nRows) == 0 )
	{ 
		return 0;
	}
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , 1 , nCols) == 0 )
	{
		return 0;
	}
	*value = mydata[0];
	return 1;
}

// 
// lowdisc_GetOneIntegerArgument --
//   Gets one integer number from the argument #ivar in the function fname.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to get
//
int lowdisc_GetOneIntegerArgument ( char * fname , int ivar , int * value )
{
	int nRows, nCols;
	double * mydata = NULL;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_matrix) == 0 )
	{
		return 0;
	}
	GetRhsVarMatrixDouble(ivar, &nRows, &nCols, &mydata);
	if ( lowdisc_AssertNumberOfRows(fname , ivar , 1 , nRows) == 0 )
	{ 
		return 0;
	}
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , 1 , nCols) == 0 )
	{
		return 0;
	}
	if ( lowdisc_Double2IntegerArgument ( fname , ivar , mydata[0] , value ) == 0 ) {
		return 0;
	}
	return 1;
}

// 
// lowdisc_GetOneCharArgument --
//   Gets one string from the argument #ivar in the function fname.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to get
//
int lowdisc_GetOneCharArgument ( char * fname , int ivar , char ** value )
{
	int nRows, nCols;
	char ** mydata = NULL;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_strings) == 0 )
	{
		return 0;
	}
	GetRhsVar( ivar, MATRIX_OF_STRING_DATATYPE, &nRows,   &nCols,   &mydata);
	if ( lowdisc_AssertNumberOfRows(fname , ivar , 1 , nRows) == 0 )
	{ 
		return 0;
	}
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , 1 , nCols) == 0 )
	{
		return 0;
	}
	*value = mydata[0];
	return 1;
}

// 
// lowdisc_Double2IntegerArgument --
//   Compute if the given double is storable as an integer.
//   Returns 0 if an error is detected, returns 1 if not error occurs.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to get
//
int lowdisc_Double2IntegerArgument ( char * fname , int ivar , double dvalue , int * ivalue )
{
	if ( dvalue > INT_MAX ) {
		Scierror(999,_("%s: Too large integer value in argument #%d: found %e while maximum value is %d.\n"),fname,ivar , dvalue , INT_MAX );
		return 0;
	}
	if ( dvalue < INT_MIN ) {
		Scierror(999,_("%s: Too large integer value in argument #%d: found %e while minimum value is %d.\n"),fname,ivar , dvalue , INT_MIN );
		return 0;
	}
	*ivalue = (int)dvalue;
	// Now check that the double was really an integer
	// TODO : put a warning instead of an error
	if ( (double)*ivalue != dvalue ) {
		Scierror(999,_("%s: Wrong integer in argument #%d: found %e which is different from the closest integer %d.\n"),fname,ivar , dvalue , *ivalue );
		return 0;
	}
	
	return 1;
}

// 
// lowdisc_CreateLhsInteger --
//   Creates an integer variable on the Left Hand Side at location ivar.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to create
//
void lowdisc_CreateLhsInteger ( int ivar , int value )
{
	int nRows, nCols;
	double *pdblFinalVar = NULL;
	nRows=1;
	nCols=1;
	iAllocMatrixOfDouble(Rhs+ivar, nRows, nCols, &pdblFinalVar);
	pdblFinalVar[0] = value;
	LhsVar(ivar) = Rhs+ivar;
}

// 
// lowdisc_CreateLhsDouble --
//   Creates a double variable on the Left Hand Side at location ivar.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   value : the value to create
//
void lowdisc_CreateLhsDouble ( int ivar , double value )
{
	int nRows, nCols;
	double *pdblFinalVar = NULL;
	nRows=1;
	nCols=1;
	iAllocMatrixOfDouble ( Rhs + ivar , nRows , nCols , &pdblFinalVar );
	pdblFinalVar[0] = value;
	LhsVar(ivar) = Rhs+ivar;
}
// 
// lowdisc_CreateLhsMatrix --
//   Creates a double matrix variable on the Left Hand Side at location ivar.
// Arguments
//   fname : the name of the Scilab function generating this error
//   ivar : the index of the input variable
//   nRows : the number of rows
//   nCols : the number of columns
//   value : the value to create
//
void lowdisc_CreateLhsMatrix ( int ivar , int nRows , int nCols , double ** matrix )
{
	iAllocMatrixOfDouble ( Rhs + ivar , nRows , nCols , matrix );
	LhsVar(ivar) = Rhs+ivar;
}
