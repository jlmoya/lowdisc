// This file is released into the public domain
// This help file was generated using helpupdate at 2010/6/3 - 14:57:42
demopath = get_absolute_file_path("lowdisc.dem.gateway.sce");
subdemolist = [
"test_sobolf.dim4", "test_sobolf.dim4.sce"; ..
"test_sobol.dim4", "test_sobol.dim4.sce"; ..
"test_niedf.base7.dim6", "test_niedf.base7.dim6.sce"; ..
"test_niedf.base2.dim6", "test_niedf.base2.dim6.sce"; ..
"test_niedf.base2.dim4", "test_niedf.base2.dim4.sce"; ..
"test_nied2.dim4", "test_nied2.dim4.sce"; ..
"test_haltonf.dim4", "test_haltonf.dim4.sce"; ..
"test_halton.dim4", "test_halton.dim4.sce"; ..
"test_fauref.dim4", "test_fauref.dim4.sce"; ..
"test_faure.glasserman", "test_faure.glasserman.sce"; ..
"test_faure.dim4", "test_faure.dim4.sce"; ..
"test_faure.dim3", "test_faure.dim3.sce"; ..
"runtests", "runtests.sce"; ..
"lowdisc_terms", "lowdisc_terms.sce"; ..
"lowdisc_stopall", "lowdisc_stopall.sce"; ..
"lowdisc_startup", "lowdisc_startup.sce"; ..
"lowdisc_ridigits", "lowdisc_ridigits.sce"; ..
"lowdisc_reset", "lowdisc_reset.sce"; ..
"lowdisc_radicalinv", "lowdisc_radicalinv.sce"; ..
"lowdisc_primes10000", "lowdisc_primes10000.sce"; ..
"lowdisc_primes1000", "lowdisc_primes1000.sce"; ..
"lowdisc_primes100", "lowdisc_primes100.sce"; ..
"lowdisc_pascal", "lowdisc_pascal.sce"; ..
"lowdisc_next", "lowdisc_next.sce"; ..
"lowdisc_new", "lowdisc_new.sce"; ..
"lowdisc_get", "lowdisc_get.sce"; ..
"lowdisc_destroy", "lowdisc_destroy.sce"; ..
"lowdisc_configure", "lowdisc_configure.sce"; ..
"lowdisc_cget", "lowdisc_cget.sce"; ..
"lowdisc_binomialmod", "lowdisc_binomialmod.sce"; ..
"lowdisc_binomial", "lowdisc_binomial.sce"; ..
"exor", "exor.sce"; ..
"divisionrem", "divisionrem.sce"; ..
"bitlo0", "bitlo0.sce"; ..
"bithi1", "bithi1.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)
