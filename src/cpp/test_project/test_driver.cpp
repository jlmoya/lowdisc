// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <stdio.h>
#include <stdlib.h>

#include "halton.h"
#include "sobol_i8.h"

void testHalton (int scrambling)
{
	Halton *seq;
	int dim_num;
	int base[3];
	int seed[3];
	int leap[3];
	double quasi[3];
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
	seq = new Halton( dim_num, base, seed, leap , scrambling );
	for ( index = 0; index < 10; index++ )
	{
		seq->next ( index , quasi);
		printf("x[%d]=",index);
		for ( i = 0; i < dim_num; i++ )
		{
			printf("%f ",quasi[i]);
		}
		printf("\n");
	}
	delete seq;
}
void testSobol ()
{
	Sobol *seq;
	int dim_num;
	long long int index;
	double quasi[3];
	int i;
	int j;
	dim_num=3;
	seq = new Sobol( dim_num);
	index = 0;
	for ( j = 0; j < 10; j++ )
	{
		seq->next ( &index , quasi);
		printf("x[%d]=",index);
		for ( i = 0; i < dim_num; i++ )
		{
			printf("%f ",quasi[i]);
		}
		printf("\n");
	}
	delete seq;
}

int main ( void )
{
	// testHalton(HALTON_SCRAMBLINGREVERSE);
	testSobol();
	return 0;
}
