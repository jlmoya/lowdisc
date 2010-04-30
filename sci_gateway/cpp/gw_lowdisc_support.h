
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
int lowdisc_GetOneDoubleArgument ( char * fname , int ivar , double * value );
int lowdisc_GetOneIntegerArgument ( char * fname , int ivar , int * value );
int lowdisc_GetOneCharArgument ( char * fname , int ivar , char ** value );
int lowdisc_Double2IntegerArgument ( char * fname , int ivar , double dvalue , int * ivalue );
void lowdisc_CreateLhsInteger ( int ivar , int value );
void lowdisc_CreateLhsDouble ( int ivar , double value );
void lowdisc_CreateLhsMatrix ( int ivar , int nRows , int nCols , double ** matrix );



/* ==================================================================== */



#endif /* __SCI_LOWDISC_GWSUPPORT_H__ */
