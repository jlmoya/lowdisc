// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license :
// http://www.gnu.org/copyleft/lesser.html


//
// lowdisc_nied_map.cpp --
//   A map to manage Niederreiter for the lowdisc Scilab Toolbox
//

extern "C" {
#include "Scierror.h"
#include "localization.h"
}

#include <stdlib.h>
#include <map>

#include "niederreiter.h"

#include "lowdisc_nied_map.hxx"
#include "gw_lowdisc_support.h" 

using namespace std;
typedef map<int , Niederreiter *> lowdisc_nied_map_type;
lowdisc_nied_map_type lowdisc_nied_map;
int Niederreiter_counter = 0;

int lowdisc_nied_map_add ( Niederreiter * seq )
{
	int token;
	token = Niederreiter_counter;
	Niederreiter_counter = Niederreiter_counter + 1;
	lowdisc_nied_map[token] = seq;
	return token;
}

void lowdisc_nied_map_remove ( int token )
{
	lowdisc_nied_map_type::iterator it;
	it = lowdisc_nied_map.find (token);
	lowdisc_nied_map.erase(it);
}

Niederreiter * lowdisc_nied_map_getobject ( int token )
{
	Niederreiter * seq = NULL;
	if ( lowdisc_nied_map.size()!=0 ) {
		lowdisc_nied_map_type::iterator it;
		it = lowdisc_nied_map.find (token);
		if ( it!= lowdisc_nied_map.end()) {
			seq = it->second;
		}
	}
	return seq;
}

int lowdisc_nied_map_size ()
{
	return lowdisc_nied_map.size();
}

void lowdisc_nied_map_tokens (int * tokens)
{
	int index = 0;
	int token;
	for(lowdisc_nied_map_type::iterator it = lowdisc_nied_map.begin(); it != lowdisc_nied_map.end(); ++it)
	{
		token = it->first;
		tokens[index] = token;
		index ++;
	}
}

int lowdisc_token2Niederreiter( char * fname, int ivar , int token, Niederreiter ** seq)
{
	*seq = lowdisc_nied_map_getobject ( token );
	if (*seq==NULL) {
		Scierror(999,_("%s: Wrong nied object %d in argument #%d.\n"),fname,token,ivar);
		return LOWDISC_GWSUPPORT_ERROR;
	}
	return LOWDISC_GWSUPPORT_OK;
}
