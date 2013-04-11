// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

//
// lowdisc_ssobol_map.hxx
//
#ifndef __LOWDISC_SSOBOL_MAP_H__
#define __LOWDISC_SSOBOL_MAP_H__

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

#include "ssobol.h"

__BEGIN_DECLS

/**
* Add a ssobol to the map.
* Returns the token.
* @param[in] token : the token of the current object
*/
int lowdisc_ssobol_map_add ( Ssobol * seq );

/**
* Remove a ssobol from the map.
* @param[in] token : the token of the current object
*/
void lowdisc_ssobol_map_remove ( int token );

/**
* Returns the number of Objects in the map
*/
int lowdisc_ssobol_map_size ();

/**
* Set "tokens", the array of tokens which are currently in use.
*/
void lowdisc_ssobol_map_tokens (int * tokens);

/**
* Sets the object corresponding to the token
*/
Ssobol * lowdisc_ssobol_map_getobject ( int token );

int lowdisc_token2Ssobol( char * fname, int ivar , int token, Ssobol ** seq);

__END_DECLS

#endif /* !__LOWDISC_SSOBOL_MAP_H__ */