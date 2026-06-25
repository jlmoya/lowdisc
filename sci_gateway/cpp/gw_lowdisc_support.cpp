
// Copyright (C) 2008 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
// Copyright (C) 2026 - Scilab 2026 / api_scilab port
//
// This file must be used under the terms of the GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html

#include <limits.h>

extern "C" {
#include "api_scilab.h"
#include "Scierror.h"
#include "localization.h"
}

#include "gw_lowdisc_support.h"

// Scilab 6+ removed the global api context that Scilab 5 provided. The gateways
// set this global from their pvApiCtx argument before calling any support
// function (see gw_lowdisc.h / the sci_lowdisc_* gateways).
void * pvApiCtx = NULL;

//
// lowdisc_AssertNumberOfRows --
//   Reports a wrong number of rows error if actual != expected.
//
int lowdisc_AssertNumberOfRows ( char * fname , int ivar , int expected_nrows , int actual_nrows )
{
	if ( expected_nrows != actual_nrows )
	{
		Scierror(999,_("%s: Wrong number of columns in argument #%d: found %d rows but %d rows expected.\n"),fname,ivar , actual_nrows , expected_nrows );
		return LOWDISC_GWSUPPORT_ERROR;
	} else {
		return LOWDISC_GWSUPPORT_OK;
	}
}

//
// lowdisc_AssertNumberOfColumns --
//   Reports a wrong number of columns error if actual != expected.
//
int lowdisc_AssertNumberOfColumns ( char * fname , int ivar , int expected_ncols , int actual_ncols )
{
	if ( expected_ncols != actual_ncols )
	{
		Scierror(999,_("%s: Wrong number of columns in argument #%d: found %d columns but %d columns expected.\n"),fname,ivar , actual_ncols , expected_ncols );
		return LOWDISC_GWSUPPORT_ERROR;
	} else {
		return LOWDISC_GWSUPPORT_OK;
	}
}

//
// lowdisc_AssertVariableType --
//   Reports a wrong type error if the actual type != expected type.
//
int lowdisc_AssertVariableType ( char * fname , int ivar , int expected_type )
{
	int iType = 0;
	int * piAddr = NULL;
	SciErr sciErr;

	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	sciErr = getVarType(pvApiCtx, piAddr, &iType);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }

	if ( iType != expected_type )
	{
		if ( expected_type == sci_strings ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: String expected.\n"),fname,ivar);
		} else if ( expected_type == sci_matrix ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Matrix expected.\n"),fname,ivar);
		} else if ( expected_type == sci_poly ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Polynomial expected.\n"),fname,ivar);
		} else if ( expected_type == sci_boolean ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Boolean expected.\n"),fname,ivar);
		} else if ( expected_type == sci_sparse ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Sparse expected.\n"),fname,ivar);
		} else if ( expected_type == sci_ints ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Integer expected.\n"),fname,ivar);
		} else if ( expected_type == sci_handles ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Handle expected.\n"),fname,ivar);
		} else if ( expected_type == sci_u_function ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: U-Function expected.\n"),fname,ivar);
		} else if ( expected_type == sci_c_function ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: C-Function expected.\n"),fname,ivar);
		} else if ( expected_type == sci_lib ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: Library expected.\n"),fname,ivar);
		} else if ( expected_type == sci_list ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: List expected.\n"),fname,ivar);
		} else if ( expected_type == sci_tlist ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: TList expected.\n"),fname,ivar);
		} else if ( expected_type == sci_mlist ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: MList expected.\n"),fname,ivar);
		} else if ( expected_type == sci_lufact_pointer ) {
			Scierror(204,_("%s: Wrong type for input argument #%d: LUFACT expected.\n"),fname,ivar);
		} else {
			Scierror(204,_("%s: Wrong type for input argument #%d: <Unknown data type> expected.\n"),fname,ivar);
		}
		return LOWDISC_GWSUPPORT_ERROR;
	} else {
		return LOWDISC_GWSUPPORT_OK;
	}
}

//
// lowdisc_GetOneDoubleArgument --
//   Gets one double precision number from argument #ivar.
//
int lowdisc_GetOneDoubleArgument ( char * fname , int ivar , double * value )
{
	int nRows, nCols;
	double * mydata = NULL;
	int * piAddr = NULL;
	SciErr sciErr;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_matrix) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &nRows, &nCols, &mydata);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	if ( lowdisc_AssertNumberOfRows(fname , ivar , 1 , nRows) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , 1 , nCols) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	*value = mydata[0];
	return LOWDISC_GWSUPPORT_OK;
}

//
// lowdisc_GetOneIntegerArgument --
//   Gets one integer number from argument #ivar.
//
int lowdisc_GetOneIntegerArgument ( char * fname , int ivar , int * value )
{
	int nRows, nCols;
	double * mydata = NULL;
	int * piAddr = NULL;
	SciErr sciErr;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_matrix) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, &nRows, &nCols, &mydata);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	if ( lowdisc_AssertNumberOfRows(fname , ivar , 1 , nRows) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , 1 , nCols) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	if ( lowdisc_Double2IntegerArgument ( fname , ivar , mydata[0] , value ) == 0 ) {
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}

//
// lowdisc_GetOneCharArgument --
//   Gets one string from argument #ivar.
//
int lowdisc_GetOneCharArgument ( char * fname , int ivar , char ** value )
{
	int * piAddr = NULL;
	char * str = NULL;
	SciErr sciErr;
	if ( lowdisc_AssertVariableType(fname , ivar , sci_strings) == 0 )
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	if ( getAllocatedSingleString(pvApiCtx, piAddr, &str) != 0 ) {
		Scierror(999, _("%s: Can not read input argument #%d.\n"), fname, ivar);
		return LOWDISC_GWSUPPORT_ERROR;
	}
	*value = str;
	return LOWDISC_GWSUPPORT_OK;
}

//
// lowdisc_GetMatrixOfDoubleArgument --
//   Gets the dimensions and the data pointer of a matrix of doubles
//   from argument #ivar. Replaces the Scilab 5 GetRhsVarMatrixDouble macro.
//
int lowdisc_GetMatrixOfDoubleArgument ( char * fname , int ivar , int * nRows , int * nCols , double ** value )
{
	int * piAddr = NULL;
	SciErr sciErr;
	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	sciErr = getMatrixOfDouble(pvApiCtx, piAddr, nRows, nCols, value);
	if (sciErr.iErr) { printError(&sciErr, 0); return LOWDISC_GWSUPPORT_ERROR; }
	return LOWDISC_GWSUPPORT_OK;
}

//
// lowdisc_Double2IntegerArgument --
//   Checks the given double is storable as an int and converts it.
//
int lowdisc_Double2IntegerArgument ( char * fname , int ivar , double dvalue , int * ivalue )
{
	if ( dvalue > INT_MAX ) {
		Scierror(999,_("%s: Too large integer value in argument #%d: found %e while maximum value is %d.\n"),fname,ivar , dvalue , INT_MAX );
		return LOWDISC_GWSUPPORT_ERROR;
	}
	if ( dvalue < INT_MIN ) {
		Scierror(999,_("%s: Too large integer value in argument #%d: found %e while minimum value is %d.\n"),fname,ivar , dvalue , INT_MIN );
		return LOWDISC_GWSUPPORT_ERROR;
	}
	*ivalue = (int)dvalue;
	if ( (double)*ivalue != dvalue ) {
		Scierror(999,_("%s: Wrong integer in argument #%d: found %e which is different from the closest integer %d.\n"),fname,ivar , dvalue , *ivalue );
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}

//
// lowdisc_CreateLhsInteger --
//   Creates an integer (1x1 double) variable on the LHS at location ivar.
//
void lowdisc_CreateLhsInteger ( int ivar , int value )
{
	double * pdblFinalVar = NULL;
	SciErr sciErr;
	sciErr = allocMatrixOfDouble(pvApiCtx, Rhs + ivar, 1, 1, &pdblFinalVar);
	if (sciErr.iErr) { printError(&sciErr, 0); return; }
	pdblFinalVar[0] = value;
	LhsVar(ivar) = Rhs + ivar;
}

//
// lowdisc_CreateLhsDouble --
//   Creates a double (1x1) variable on the LHS at location ivar.
//
void lowdisc_CreateLhsDouble ( int ivar , double value )
{
	double * pdblFinalVar = NULL;
	SciErr sciErr;
	sciErr = allocMatrixOfDouble(pvApiCtx, Rhs + ivar, 1, 1, &pdblFinalVar);
	if (sciErr.iErr) { printError(&sciErr, 0); return; }
	pdblFinalVar[0] = value;
	LhsVar(ivar) = Rhs + ivar;
}

//
// lowdisc_CreateLhsMatrix --
//   Creates a double matrix variable on the LHS at location ivar.
//
void lowdisc_CreateLhsMatrix ( int ivar , int nRows , int nCols , double ** matrix )
{
	SciErr sciErr;
	sciErr = allocMatrixOfDouble(pvApiCtx, Rhs + ivar, nRows, nCols, matrix);
	if (sciErr.iErr) { printError(&sciErr, 0); return; }
	LhsVar(ivar) = Rhs + ivar;
}

//
// lowdisc_GetOneBooleanArgument --
//   Gets one boolean from argument #ivar.
//
int lowdisc_GetOneBooleanArgument ( char * fname , int ivar , int * value )
{
	int* piAddr = NULL;
	SciErr sciErr;
	int ierr;

	sciErr = getVarAddressFromPosition(pvApiCtx, ivar, &piAddr);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return LOWDISC_GWSUPPORT_ERROR;
	}
	ierr = getScalarBoolean(pvApiCtx, piAddr, value);
	if(ierr)
	{
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}
