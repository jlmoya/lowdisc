// Copyright (C) 2006-2009 - CEA - Jean-Marc Martinez
// Copyright (C) 2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html


#include "lowdisc_math.h"

int * ivector(int n) {
	return(new int[n]);
}

int ** imatrix(int l, int c) {
	int **a = new int * [l];
	for(int i = 0; i < l; i++) {
		a[i] = new int[c];
	}
	return(a);
}

void free_ivector(int * v) {
	delete [] v;
}

void free_imatrix(int ** mat, int l) {
	for(int i=0;i<l;i++) {
		delete [] mat[i];
	}
	delete [] mat;
}

double * dvector(int n) {
	return(new double[n]);
}

double ** dmatrix(int l, int c) {
	double **a = new double * [l];
	for(int i = 0; i < l; i++) {
		a[i] = new double[c];
	}
	return(a);
}

void free_dvector(double * v) {
	delete [] v;
}

void free_dmatrix(double ** mat, int l) {
	for(int i=0;i<l;i++) {
		delete [] mat[i];
	}
	delete [] mat;
}

