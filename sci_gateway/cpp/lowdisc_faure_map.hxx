// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

//
// lowdisc_faure_map.hxx
//
#ifndef __LOWDISC_FAURE_MAP_H__
#define __LOWDISC_FAURE_MAP_H__

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

#include "faure.h"

__BEGIN_DECLS

/**
* Add a faure to the map.
* Returns the token.
* @param[in] token : the token of the current object
*/
int lowdisc_faure_map_add ( Faure * seq );

/**
* Remove a faure from the map.
* @param[in] token : the token of the current object
*/
void lowdisc_faure_map_remove ( int token );

/**
* Returns the number of Objects in the map
*/
int lowdisc_faure_map_size ();

/**
* Set "tokens", the array of tokens which are currently in use.
*/
void lowdisc_faure_map_tokens (int * tokens);

/**
* Sets the object corresponding to the token
*/
Faure * lowdisc_faure_map_getobject ( int token );

// 
// lowdisc_token2Sfaure --
//   Sets into seq the Sfaure object which corresponds to the token.
//   Returns 0 in case of error, returns 1 in case of regular run.
//
int lowdisc_token2Faure( char * fname, int ivar , int token, Faure ** seq);

__END_DECLS

#endif /* !__LOWDISC_FAURE_MAP_H__ */