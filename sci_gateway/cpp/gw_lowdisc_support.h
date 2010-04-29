
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin

//
// lowdisc_support.h
//   Header for the C++ gateway support functions for LOWDISC
//
#ifndef __SCI_LOWDISC_GWSUPPORT_H__
#define __SCI_LOWDISC_GWSUPPORT_H__

int lowdisc_AssertNumberOfRows ( char * fname , int ivar , int expected_nrows , int actual_nrows );
int lowdisc_AssertNumberOfColumns ( char * fname , int ivar , int expected_ncols , int actual_ncols );
int lowdisc_AssertVariableType ( char * fname , int ivar , int expected_type );
int lowdisc_GetTokenIndex ( char * fname , int ivar , int * token );
int lowdisc_GetOneDoubleArgument ( char * fname , int ivar , double * value );
int lowdisc_GetOneIntegerArgument ( char * fname , int ivar , int * value );
int lowdisc_GetOneCharArgument ( char * fname , int ivar , char ** value );
int lowdisc_Double2IntegerArgument ( char * fname , int ivar , double dvalue , int * ivalue );
void lowdisc_CreateLhsInteger ( int ivar , int value );
void lowdisc_CreateLhsDouble ( int ivar , double value );
void lowdisc_CreateLhsMatrix ( int ivar , int nRows , int nCols , double ** matrix );

// TODO : remove these pre-processing macros

#define lowdisc_AssertNColumns(fname , ivar , expected_ncols , actual_ncols) \
	if ( lowdisc_AssertNumberOfColumns(fname , ivar , expected_ncols , actual_ncols) == 0 ) \
{ \
	return 0;\
}

#define lowdisc_AssertNRows(fname , ivar , expected_nrows , actual_nrows) \
	if ( lowdisc_AssertNumberOfRows(fname , ivar , expected_nrows , actual_nrows) == 0 ) \
{ \
	return 0;\
}

#define lowdisc_AssertVarType(fname , ivar , expected_type) \
	if ( lowdisc_AssertVariableType(fname , ivar , expected_type) == 0 ) \
{ \
	return 0;\
}

#define lowdisc_gettoken(fname , ivar , token ) \
	if ( lowdisc_GetTokenIndex(fname , ivar , token ) == 0 ) \
{ \
	return 0;\
}

#define lowdisc_GetOneDouble(fname,ivar,value) \
	if (lowdisc_GetOneDoubleArgument(fname,ivar,value)==0) { \
	return 0; \
	}

#define lowdisc_GetOneInteger(fname,ivar,value) \
	if (lowdisc_GetOneIntegerArgument(fname,ivar,value)==0) { \
	return 0; \
	}

#define lowdisc_GetOneChar(fname,ivar,value) \
	if (lowdisc_GetOneCharArgument(fname,ivar,value)==0) { \
	return 0; \
	}

#define lowdisc_Double2Integer(fname,ivar,dvalue,ivalue) \
	if (lowdisc_Double2IntegerArgument(fname,ivar,dvalue,ivalue)==0) { \
	return 0; \
	}

/* ==================================================================== */



#endif /* __SCI_LOWDISC_GWSUPPORT_H__ */
