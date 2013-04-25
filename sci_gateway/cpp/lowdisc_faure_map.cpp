// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html


//
// lowdisc_faure_map.cpp --
//   A map to manage Faure for the lowdisc Scilab Toolbox
//

extern "C" {
#include "Scierror.h"
#include "localization.h"
}

#include <stdlib.h>
#include <map>

#include "faure.h"

#include "lowdisc_faure_map.hxx"

using namespace std;
typedef map<int , Faure *> lowdisc_faure_map_type;
lowdisc_faure_map_type lowdisc_faure_map;
int Faure_counter = 0;

int lowdisc_faure_map_add ( Faure * seq )
{
	int token;
	token = Faure_counter;
	Faure_counter = Faure_counter + 1;
	lowdisc_faure_map[token] = seq;
	return token;
}

void lowdisc_faure_map_remove ( int token )
{
	lowdisc_faure_map_type::iterator it;
	it = lowdisc_faure_map.find (token);
	lowdisc_faure_map.erase(it);
}

Faure * lowdisc_faure_map_getobject ( int token )
{
	Faure * seq = NULL;
	if ( lowdisc_faure_map.size()!=0 ) {
		lowdisc_faure_map_type::iterator it;
		it = lowdisc_faure_map.find (token);
		if ( it!= lowdisc_faure_map.end()) {
			seq = it->second;
		}
	}
	return seq;
}

int lowdisc_faure_map_size ()
{
	return lowdisc_faure_map.size();
}

void lowdisc_faure_map_tokens (int * tokens)
{
	int index = 0;
	int token;
	for(lowdisc_faure_map_type::iterator it = lowdisc_faure_map.begin(); it != lowdisc_faure_map.end(); ++it)
	{
		token = it->first;
		tokens[index] = token;
		index ++;
	}
}

int lowdisc_token2Faure( char * fname, int ivar , int token, Faure ** seq)
{
	*seq = lowdisc_faure_map_getobject ( token );
	if (*seq==NULL) {
		Scierror(999,_("%s: Wrong faure object %d in argument #%d.\n"),fname,token,ivar);
		return 0;
	}
	return 1;
}
