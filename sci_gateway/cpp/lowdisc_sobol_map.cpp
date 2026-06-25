// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html


//
// lowdisc_sobol_map.cpp --
//   A map to manage Sobol for the lowdisc Scilab Toolbox
//

extern "C" {
#include "Scierror.h"
#include "localization.h"
}

#include <stdlib.h>
#include <map>

#include "sobol_i8.h"

#include "lowdisc_sobol_map.hxx"
#include "gw_lowdisc_support.h" 

using namespace std;
typedef map<int , Sobol *> lowdisc_sobol_map_type;
lowdisc_sobol_map_type lowdisc_sobol_map;
int Sobol_counter = 0;

int lowdisc_sobol_map_add ( Sobol * seq )
{
	int token;
	token = Sobol_counter;
	Sobol_counter = Sobol_counter + 1;
	lowdisc_sobol_map[token] = seq;
	return token;
}

void lowdisc_sobol_map_remove ( int token )
{
	lowdisc_sobol_map_type::iterator it;
	it = lowdisc_sobol_map.find (token);
	lowdisc_sobol_map.erase(it);
}

Sobol * lowdisc_sobol_map_getobject ( int token )
{
	Sobol * seq = NULL;
	if ( lowdisc_sobol_map.size()!=0 ) {
		lowdisc_sobol_map_type::iterator it;
		it = lowdisc_sobol_map.find (token);
		if ( it!= lowdisc_sobol_map.end()) {
			seq = it->second;
		}
	}
	return seq;
}

int lowdisc_sobol_map_size ()
{
	return lowdisc_sobol_map.size();
}

void lowdisc_sobol_map_tokens (int * tokens)
{
	int index = 0;
	int token;
	for(lowdisc_sobol_map_type::iterator it = lowdisc_sobol_map.begin(); it != lowdisc_sobol_map.end(); ++it)
	{
		token = it->first;
		tokens[index] = token;
		index ++;
	}
}

int lowdisc_token2Sobol( char * fname, int ivar , int token, Sobol ** seq)
{
	*seq = lowdisc_sobol_map_getobject ( token );
	if (*seq==NULL) {
		Scierror(999,_("%s: Wrong sobol object %d in argument #%d.\n"),fname,token,ivar);
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}
