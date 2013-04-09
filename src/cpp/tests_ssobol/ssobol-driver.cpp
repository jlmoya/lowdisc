// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html


#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "ssobol.h"

int main(void)
{
	/* Local variables */
	int i, j, maxd;
	int taus, iflag, dimen;
	double quasi[40];
	int atmost;

	maxd = 30;
	dimen = 2;
	iflag = 3;
	atmost = 50;
	printf("iflag=%d\n",iflag);
	printf("atmost=%d\n",atmost);
	printf("dimen=%d\n",dimen);
	printf("maxd=%d\n",maxd);
	ssobol_startup(dimen, atmost, iflag, maxd, &taus, quasi);
	for (i = 2; i <= atmost; i++) {
		ssobol_next(quasi);
		printf("quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			printf(" %f",quasi[j]);
		}
		printf("\n");
	}
	return 0;
}
