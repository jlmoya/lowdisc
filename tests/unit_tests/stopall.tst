// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

lowdisc_stopall ( );

// Example of what can go wrong...
// We create a Niederreiter sequence.
lds = lowdisc_new("niederreiter");
[lds,computed] = lowdisc_next (lds);
// We create a Niederreiter sequence again.
lds = lowdisc_new("niederreiter");
[lds,computed] = lowdisc_next (lds);
// This creates the error message :
// "Low Discrepancy Module Error ! Startup is already done."
// It would suffice to call lowdisc_destroy(lds).
// But we can use a more brutal function, which resets all sequences.
lowdisc_stopall ( );
// Now it works again.
lds = lowdisc_new("niederreiter");
[lds,computed] = lowdisc_next (lds);
lds = lowdisc_destroy(lds);
