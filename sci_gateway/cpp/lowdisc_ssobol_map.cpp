// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html


//
// lowdisc_ssobol_map.cpp --
//   A map to manage Ssobol for the lowdisc Scilab Toolbox
//

extern "C" {
#include "Scierror.h"
#include "localization.h"
}

#include <stdlib.h>
#include <map>

#include "ssobol.h"

#include "lowdisc_ssobol_map.hxx"

using namespace std;
typedef map<int , Ssobol *> lowdisc_ssobol_map_type;
lowdisc_ssobol_map_type lowdisc_ssobol_map;
int Ssobol_counter = 0;

int lowdisc_ssobol_map_add ( Ssobol * seq )
{
	int token;
	token = Ssobol_counter;
	Ssobol_counter = Ssobol_counter + 1;
	lowdisc_ssobol_map[token] = seq;
	return token;
}

void lowdisc_ssobol_map_remove ( int token )
{
	lowdisc_ssobol_map_type::iterator it;
	it = lowdisc_ssobol_map.find (token);
	lowdisc_ssobol_map.erase(it);
}

Ssobol * lowdisc_ssobol_map_getobject ( int token )
{
	Ssobol * seq = NULL;
	if ( lowdisc_ssobol_map.size()!=0 ) {
		lowdisc_ssobol_map_type::iterator it;
		it = lowdisc_ssobol_map.find (token);
		if ( it!= lowdisc_ssobol_map.end()) {
			seq = it->second;
		}
	}
	return seq;
}

int lowdisc_ssobol_map_size ()
{
	return lowdisc_ssobol_map.size();
}

void lowdisc_ssobol_map_tokens (int * tokens)
{
	int index = 0;
	int token;
	for(lowdisc_ssobol_map_type::iterator it = lowdisc_ssobol_map.begin(); it != lowdisc_ssobol_map.end(); ++it)
	{
		token = it->first;
		tokens[index] = token;
		index ++;
	}
}

// 
// lowdisc_token2Ssobol --
//   Sets into seq the Ssobol object which corresponds to the token.
//   Returns 0 in case of error, returns 1 in case of regular run.
//
int lowdisc_token2Ssobol( char * fname, int ivar , int token, Ssobol ** seq)
{
	*seq = lowdisc_ssobol_map_getobject ( token );
	if (*seq==NULL) {
		Scierror(999,_("%s: Wrong ssobol object %d in argument #%d.\n"),fname,token,ivar);
		return 0;
	}
	return 1;
}
