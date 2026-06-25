// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <stdio.h>
#include <stdlib.h>

#include "lowdisc.h"
#include "halton.h"
#include "faure.h"
#include "sobol_i8.h"
#include "niederreiter.h"

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
void testSobolAtOne ()
{
	// This tests a Sobol sequence, where 
	// the first required element is at index 1.
	Sobol *seq;
	int dim_num;
	long long int index;
	double quasi[3];
	int i;
	dim_num=3;
	seq = new Sobol( dim_num);
	index = 2;
	seq->next ( &index , quasi);
	printf("x[%d]=",index);
	for ( i = 0; i < dim_num; i++ )
	{
		printf("%f ",quasi[i]);
	}
	printf("\n");
	delete seq;
}
void testFaure ()
{
	Faure *seq;
	int dim_num;
	int index;
	double quasi[3];
	int i;
	int j;
	int basis;
	dim_num=3;
	basis=lowdisc_prime_ge(dim_num);
	seq = new Faure(dim_num,basis);
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

void testNiederreiter ()
{
	Niederreiter *seq;
	int dim_num;
	int index;
	double quasi[3];
	int i;
	int j;
	int base;
	int skip;
	char gfaritfile[50]="gfarit.txt";
	char gfplysfile[50]="gfplsys.txt";
	dim_num=3;
	base=2;
	skip=0;
	seq = new Niederreiter(dim_num, base, skip , gfaritfile , gfplysfile );
	index = 0;
	for ( j = 0; j < 10; j++ )
	{
		seq->next(quasi);
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
	int choice = 5;
	if (choice==1)
	{
		testHalton(HALTON_SCRAMBLINGREVERSE);
	} 
	else if (choice==2)
	{
		testSobol();
	} 
	else if (choice==3)
	{
		testSobolAtOne();
	}
	else if (choice==4)
	{
		testFaure ();
	}
	else if (choice=5)
	{
		testNiederreiter();
	}
	return 0;
}
