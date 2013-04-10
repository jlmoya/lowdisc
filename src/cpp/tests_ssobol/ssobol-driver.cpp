// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html


#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "ssobol.h"

// warning C4996: 'localtime': This function or variable may be unsafe. 
// Consider using localtime_s instead. 
// To disable deprecation, use _CRT_SECURE_NO_WARNINGS.
#ifdef _MSC_VER
#pragma warning( disable : 4996 )
#endif

void test_ssobol(const char * filename, int maxd, int dimen, int iflag, int atmost)
{
	int i, j;
	int taus;
	double quasi[40];

	FILE * pFile;
	pFile = fopen (filename,"w");

	ssobol_seedreset();
	fprintf(pFile,"iflag=%d\n",iflag);
	fprintf(pFile,"atmost=%d\n",atmost);
	fprintf(pFile,"dimen=%d\n",dimen);
	fprintf(pFile,"maxd=%d\n",maxd);
	ssobol_startup(dimen, atmost, iflag, maxd, &taus);
	for (i = 1; i <= atmost; i++) {
		ssobol_next(quasi);
		fprintf(pFile,"quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			fprintf(pFile," %f",quasi[j]);
		}
		fprintf(pFile,"\n");
	}
	ssobol_stop ( );
	fclose (pFile);
	return;
}

int main(void)
{
	int maxd;
	int iflag;
	int dimen;
	int atmost;
	char filename[50];

	maxd = 30;
	atmost = 50;

	dimen = 2;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,atmost);
		test_ssobol(filename, maxd, dimen, iflag, atmost);
	}

	dimen = 3;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,atmost);
		test_ssobol(filename, maxd, dimen, iflag, atmost);
	}

	dimen = 5;
	for (iflag = 0; iflag <= 3; iflag++) {
		sprintf (filename, "ssobol-iflag%d-s%d-n%d.txt",iflag,dimen,atmost);
		test_ssobol(filename, maxd, dimen, iflag, atmost);
	}

	return 0;
}
