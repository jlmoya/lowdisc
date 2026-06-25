// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include <ctime>
#include <sstream>
#include <fstream>

using namespace std;

#include "lowdisc.h"
#include "lowdisc_shared.h"

//****************************************************************************80
// Set the error function
void lowdisc_errorsetfunction ( void (* f)(char * message) ) {
	lowdisc_errorfunction = f;
}
//****************************************************************************80
// Set the message function
void lowdisc_msgsetfunction ( void (* f)(char * message) ) {
	lowdisc_messagefunction = f;
}

int lowdisc_prime_ge ( int n )
{
	int i_hi;
	int i_lo;
	int i_mid;
	int p;
	int p_hi;
	int p_lo;
	int p_mid;

	if ( n <= 2 )
	{
		p = 2;
	}
	else
	{
		i_lo = 1;
		p_lo = prime(i_lo);
		i_hi = prime(-1);
		p_hi = prime(i_hi);

		if ( p_hi < n )
		{
			p = - p_hi;
		}
		else
		{
			for ( ; ; )
			{
				if ( i_lo + 1 == i_hi )
				{
					p = p_hi;
					break;
				}

				i_mid = ( i_lo + i_hi ) / 2;
				p_mid = prime(i_mid);

				if ( p_mid < n )
				{
					i_lo = i_mid;
					p_lo = p_mid;
				}
				else if ( n <= p_mid )
				{
					i_hi = i_mid;
					p_hi = p_mid;
				}
			}
		}
	}

	return p;
}

