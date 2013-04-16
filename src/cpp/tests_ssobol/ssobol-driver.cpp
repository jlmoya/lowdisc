// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html


#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "ssobol.h"
#include "lowdisc.h"

// warning C4996: 'localtime': This function or variable may be unsafe. 
// Consider using localtime_s instead. 
// To disable deprecation, use _CRT_SECURE_NO_WARNINGS.
#ifdef _MSC_VER
#pragma warning( disable : 4996 )
#endif

//
// Writes into filename the scrambled Sobol sequence 
// with given parameters.
//
void test_ssobol(const char * filename, int maxd, int dimen, int iflag, int imax, int atmost)
{
	int i, j;
	double quasi[40];
	Ssobol * seq;
	int isok;

	FILE * pFile;
	pFile = fopen (filename,"w");

	fprintf(pFile,"iflag=%d\n",iflag);
	fprintf(pFile,"atmost=%d\n",atmost);
	fprintf(pFile,"dimen=%d\n",dimen);
	fprintf(pFile,"maxd=%d\n",maxd);
	seq = new Ssobol(dimen, atmost, iflag, maxd,&isok);
	for (i = 1; i <= imax; i++) {
		seq->next(quasi);
		fprintf(pFile,"quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			fprintf(pFile," %f",quasi[j]);
		}
		fprintf(pFile,"\n");
	}
	delete seq;
	fclose (pFile);
	return;
}
//
// Writes a series of data files, containing 50 points 
// in dimensions 2, 3, 5 for scramblings=0,1,2,3.
//
void test_ssobolfiles(void)
{
	int maxd;
	int iflag;
	int dimen;
	int atmost;
	char filename[50];
	int imax;

	maxd = 30;
	atmost = 1073741823;
	imax = 50;

	dimen = 2;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,imax);
		test_ssobol(filename, maxd, dimen, iflag, imax, atmost);
	}

	dimen = 3;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,imax);
		test_ssobol(filename, maxd, dimen, iflag, imax, atmost);
	}

	dimen = 5;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,imax);
		test_ssobol(filename, maxd, dimen, iflag, imax, atmost);
	}

	return;
}

//   The error callback used by the Low Discrepancy Library.
void test_errorfunction ( char * message ) {
	printf("Error : %s\n" , message );
}

//   The message callback used by the Low Discrepancy Library.
void test_messagefunction ( char * message ) {
	printf( "Message : %s\n",message );
}

//
// Configure the error and message functions
//
void test_startup ()
{
	lowdisc_msgsetfunction ( test_messagefunction );
	lowdisc_errorsetfunction ( test_errorfunction );
	return;
}
//
// A test for an error : the dimension is too large.
//
void test_ssobolerrorcase () 
{
	int maxd=30;
	int iflag=1;
	int dimen=50;
	int atmost=100;
	Ssobol * seq;
	int isok;
	test_startup ();
	seq = new Ssobol(dimen, atmost, iflag, maxd,&isok);
	return;
}
//
// A straightforward generation of Scrambled Sobol sequence
//
void test_ssobolsimple()
{
	int maxd=30;
	int iflag=1;
	int dimen=2;
	int atmost=50;
	int i;
	int j;
	double quasi[40];
	Ssobol * seq;
	int isok;
	
	seq = new Ssobol(dimen, atmost, iflag, maxd,&isok);
	for (i = 1; i <= 50; i++) {
		seq->next(quasi);
		printf("quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			printf(" %f",quasi[j]);
		}
		printf("\n");
	}
	delete seq;

	return;
}
//
// Test the configuration of the seed : the seedset method.
//
void test_seedset()
{
	int maxd=30;
	int iflag=1;
	int dimen=2;
	int atmost=50;
	int i;
	int j;
	double quasi[40];
	Ssobol * seq;
	int isok;
	static double seeds[24] = { .8804418,.2694365,.0367681,.4068699,
		.4554052,.2880635,.1463408,.2390333,.6407298,.1755283,.713294,
		.4913043,.2979918,.1396858,.3589528,.5254809,.9857749,.4612127,
		.2196441,.7848351,.40961,.9807353,.2689915,.5140357 };
	
	seq = new Ssobol(dimen, atmost, iflag, maxd,seeds,&isok);
	for (i = 1; i <= 50; i++) {
		seq->next(quasi);
		printf("quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			printf(" %f",quasi[j]);
		}
		printf("\n");
	}
	delete seq;

	return;
}


int main(void)
{
	test_seedset ();
	return 0;
}

