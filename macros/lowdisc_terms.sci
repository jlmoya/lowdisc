// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_terms --
//   Returns a matrix containing imax terms of the 
//   random number sequence, from 1 up to imax.
//   The matrix is organized as follows :
//   result(1,1:dimension) : is the term #1
//   result(i,1:dimension) : is the term #i
//   result(imax,1:dimension) : is the term #imax
//
function [this,result] = lowdisc_terms (this,imax)
  result=zeros(imax,this.dimension)
  for i=1:imax
    [this,result(i,1:this.dimension)]= lowdisc_next(this)
  end
endfunction

