// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html


//
// lowdisc_halton_map.cpp --
//   A map to manage halton for the lowdisc Scilab Toolbox
//

extern "C" {
#include "Scierror.h"
#include "localization.h"
}

#include <stdlib.h>
#include <map>

#include "halton.h"

#include "lowdisc_halton_map.hxx"
#include "gw_lowdisc_support.h" 

using namespace std;
typedef map<int , Halton *> lowdisc_halton_map_type;
lowdisc_halton_map_type lowdisc_halton_map;
int halton_counter = 0;

int lowdisc_halton_map_add ( Halton * seq )
{
	int token;
	token = halton_counter;
	halton_counter = halton_counter + 1;
	lowdisc_halton_map[token] = seq;
	return token;
}

void lowdisc_halton_map_remove ( int token )
{
	lowdisc_halton_map_type::iterator it;
	it = lowdisc_halton_map.find (token);
	lowdisc_halton_map.erase(it);
}

Halton * lowdisc_halton_map_getobject ( int token )
{
	Halton * seq = NULL;
	if ( lowdisc_halton_map.size()!=0 ) {
		lowdisc_halton_map_type::iterator it;
		it = lowdisc_halton_map.find (token);
		if ( it!= lowdisc_halton_map.end()) {
			seq = it->second;
		}
	}
	return seq;
}

int lowdisc_halton_map_size ()
{
	return lowdisc_halton_map.size();
}

void lowdisc_halton_map_tokens (int * tokens)
{
	int index = 0;
	int token;
	for(lowdisc_halton_map_type::iterator it = lowdisc_halton_map.begin(); it != lowdisc_halton_map.end(); ++it)
	{
		token = it->first;
		tokens[index] = token;
		index ++;
	}
}

int lowdisc_token2halton( char * fname, int ivar , int token, Halton ** seq)
{
	*seq = lowdisc_halton_map_getobject ( token );
	if (*seq==NULL) {
		Scierror(999,_("%s: Wrong halton object %d in argument #%d.\n"),fname,token,ivar);
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}
