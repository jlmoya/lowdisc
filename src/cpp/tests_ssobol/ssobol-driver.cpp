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

void test_ssobol(const char * filename, int maxd, int dimen, int iflag, int imax, int atmost)
{
	int i, j;
	int taus;
	double quasi[40];
	Ssobol * seq;

	FILE * pFile;
	pFile = fopen (filename,"w");

	fprintf(pFile,"iflag=%d\n",iflag);
	fprintf(pFile,"atmost=%d\n",atmost);
	fprintf(pFile,"dimen=%d\n",dimen);
	fprintf(pFile,"maxd=%d\n",maxd);
	seq = new Ssobol(dimen, atmost, iflag, maxd, &taus);
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

void test_errorfunction ( char * message ) {
	printf("%s\n" , message );
}

// sci_lowdisc_messagefunction --
//   The error callback used by the Low Discrepancy Library.
//   Redirect the message to Scilab's error function.
void test_messagefunction ( char * message ) {
	printf( "%s\n",message );
}

void test_startup ()
{
	lowdisc_msgsetfunction ( test_messagefunction );
	lowdisc_errorsetfunction ( test_errorfunction );
	return;
}
void test_ssobolerrorcase () 
{
	int maxd=30;
	int iflag=1;
	int dimen=50;
	int atmost=100;
	int taus;
	Ssobol * seq;
	test_startup ();
	// Error : the dimension is too large.
	seq = new Ssobol(dimen, atmost, iflag, maxd, &taus);
	return;
}

void test_ssobolsimple(void)
{
	int maxd=30;
	int iflag=1;
	int dimen=2;
	int atmost=50;
	int taus;
	int i;
	int j;
	double quasi[40];
	Ssobol * seq;
	
	seq = new Ssobol(dimen, atmost, iflag, maxd, &taus);
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
	test_ssobolfiles ();
	return 0;
}

