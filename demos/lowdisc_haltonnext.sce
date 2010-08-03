mode(1)
//
// Demo of lowdisc_halton.sci
//

// Get a matrix of 100 primes
primemat = lowdisc_primes100 ( );
dimension = 2;
// Generate element #0 of the Halton sequence in dimension 2
next = lowdisc_halton ( dimension , 0 , primemat )
// Generate element #1 of the Halton sequence in dimension 2
next = lowdisc_halton ( dimension , 1 , primemat )
// Generate element #2 of the Halton sequence in dimension 2
next = lowdisc_halton ( dimension , 2 , primemat )
halt()   // Press return to continue
 
// Generate some elements
for i = 0 : 2^7-1
next(i+1,1:dimension) = lowdisc_halton ( dimension , i , primemat );
end
// Plot them
plot ( next(:,1) , next(:,2) , "bo" )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_halton.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
