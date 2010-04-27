// This file is released into the public domain
// This help file was generated using helpupdate at 2010/4/27 - 22:2:59
demopath = get_absolute_file_path("lowdisc.dem.gateway.sce");
subdemolist = [
"lowdisc_cget", "lowdisc_cget.sce"; ..
"lowdisc_get", "lowdisc_get.sce"; ..
"lowdisc_configure", "lowdisc_configure.sce"; ..
"lowdisc_destroy", "lowdisc_destroy.sce"; ..
"lowdisc_new", "lowdisc_new.sce"; ..
"lowdisc_next", "lowdisc_next.sce"; ..
"lowdisc_reset", "lowdisc_reset.sce"; ..
"lowdisc_startup", "lowdisc_startup.sce"; ..
"lowdisc_primes1000", "lowdisc_primes1000.sce"; ..
"lowdisc_primes10000", "lowdisc_primes10000.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)
