// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <stdio.h>
#include <stdlib.h>

#include "halton.h"

void testHalton ( )
{
	int dim_num;
	int base[3];
	int seed[3];
	int leap[3];
	double r[3];
	int index;
	int i;
	base[0]=2;
	base[1]=3;
	base[2]=5;
	dim_num=3;
	for ( i = 0; i < dim_num; i++ )
	{
		seed[i]=0;
	}
	for ( i = 0; i < dim_num; i++ )
	{
		leap[i]=1;
	}
	halton_start ( dim_num, base, seed, leap , halton_scramblingZero );
	for ( index = 0; index < 10; index++ )
	{
		halton_next ( index , r);
		printf("x[%d]=",index);
		for ( i = 0; i < dim_num; i++ )
		{
			printf("%f ",r[i]);
		}
		printf("\n");
	}
	halton_stop ( );
}

int main ( void )
{
	int dim_num;
	int base[3];
	int i;
	int j;
	double r[3];
	int index;
	int seed[3];
	int leap[3];
	base[0]=2;
	base[1]=3;
	base[2]=5;
	dim_num=3;
	for ( i = 0; i < dim_num; i++ )
	{
		seed[i]=0;
	}
	for ( i = 0; i < dim_num; i++ )
	{
		leap[i]=1;
	}
	halton_start ( dim_num , base , seed , leap , halton_scramblingRR2);
	for ( index = 0; index < 10; index++ )
	{
		halton_next ( index , r );
		printf("x[%d]=",index);
		for ( i = 0; i < dim_num; i++ )
		{
			printf("%f ",r[i]);
		}
		printf("\n");
	}
	// 
	halton_stop ( );
	return 0;
}
