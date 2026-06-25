// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

//
// lowdisc_nied_map.hxx
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

#include "niederreiter.h"

__BEGIN_DECLS

/**
* Add a nied to the map.
* Returns the token.
* @param[in] token : the token of the current object
*/
int lowdisc_nied_map_add ( Niederreiter * seq );

/**
* Remove a nied from the map.
* @param[in] token : the token of the current object
*/
void lowdisc_nied_map_remove ( int token );

/**
* Returns the number of Objects in the map
*/
int lowdisc_nied_map_size ();

/**
* Set "tokens", the array of tokens which are currently in use.
*/
void lowdisc_nied_map_tokens (int * tokens);

/**
* Sets the object corresponding to the token
*/
Niederreiter * lowdisc_nied_map_getobject ( int token );

// 
// lowdisc_token2Snied --
//   Sets into seq the Snied object which corresponds to the token.
//   Returns 0 in case of error, returns 1 in case of regular run.
//
int lowdisc_token2Niederreiter( char * fname, int ivar , int token, Niederreiter ** seq);

__END_DECLS

#endif /* !__LOWDISC_FAURE_MAP_H__ */