// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = lowdisc_new ()
  // Create a new object.
  //
  // Calling Sequence
  //   this = lowdisc_new ()
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This function requires to take the current object both as an input
  //   and an output argument.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  this = tlist([
    "LOWDISC"
    "verbose"
    "dimension"
    "method"
    "sequenceindex"
    "vdcbasis"
    "primeslist"
    "startedup"
    "primessize"
    "fauredim2prime"
    "fauredimmax"
    "sobolv"
    "sobolmaxcol"
    "sobollastq"
    "sobolrecipd"
    "sobolcount"
    "NR_cj"
    "NR_seed"
    "NR_nextq"
    "NR_recip"
    "NR_nbits"
    "skip"
    "leap"
    ])
  //
  // Configurable options
  this.verbose=%f
  this.dimension=1
  this.method="halton"
  this.sequenceindex=0
  this.vdcbasis = 2
  // List computed with primes(x)
  // List extracted from :
  // http://en.wikipedia.org/wiki/List_of_prime_numbers
  this.primeslist = [2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509 521 523 541]
  this.skip = 0
  this.leap = 0
  //
  // Non Configurable options
  this.primessize = size(this.primeslist,2)
  this.startedup = 0
  this.fauredim2prime = [2 2 3 5 5 7 7 11 11 11 11 13 13 17 17 17 17 19 19 23 23 23 23 29 29 29 29 29 29 31 31 37 37 37 37 37 37 41 41 41 41 43 43 47 47 47 47 53 53 53]
  this.fauredimmax = size(this.fauredim2prime,2)
endfunction


