/* ssobol.f -- translated by f2c (version 20100827).
You must link the resulting object file with libf2c:
on Microsoft Windows system, link with libf2c.lib;
on Linux or Unix systems, link with .../path/to/libf2c.a -lm
or, if you install libf2c.a in a standard place, with -lf2c -lm
-- in that order, at the end of the command line, as in
cc *.o -lf2c -lm
Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

http://www.netlib.org/f2c/libf2c.zip
*/
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int exor_(int *iin, int *jin);
int genscrml_(int *max__, int *lsm, int *shift);
int genscrmu_(int *usm, int *ushift);
double uni_(void);

/* Common Block Declarations */

struct sobdat_1_ {
	int poly[39], vinit[312]	/* was [39][8] */;
};

#define sobdat_1 (*(struct sobdat_1_ *) &sobdat_)

union {
	struct {
		int s, maxcol, sv[1240]	/* was [40][31] */, count, lastq[40];
		double recipd;
	} _1;
	struct {
		int s, maxcol;
	} _2;
} sobol_;

#define sobol_1 (sobol_._1)
#define sobol_2 (sobol_._2)

/* Initialized data */

struct {
	int e_1[78];
	int fill_2[1];
	int e_3[38];
	int fill_4[2];
	int e_5[37];
	int fill_6[4];
	int e_7[35];
	int fill_8[6];
	int e_9[33];
	int fill_10[12];
	int e_11[27];
	int fill_12[18];
	int e_13[21];
	int fill_14[36];
	int e_15[3];
} sobdat_ = { 3, 7, 11, 13, 19, 25, 37, 59, 47, 61, 55, 41, 67, 97, 91, 
	109, 103, 115, 131, 193, 137, 145, 143, 241, 157, 185, 167, 229, 
	171, 213, 191, 253, 203, 211, 239, 247, 285, 369, 299, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, {0}, 1, 3, 1, 3, 1, 3, 3, 
	1, 3, 1, 3, 1, 3, 1, 1, 3, 1, 3, 1, 3, 1, 3, 3, 1, 3, 1, 3, 1, 3, 
	1, 1, 3, 1, 3, 1, 3, 1, 3, {0}, 7, 5, 1, 3, 3, 7, 5, 5, 7, 7, 1, 
	3, 3, 7, 5, 1, 1, 5, 3, 3, 1, 7, 5, 1, 3, 3, 7, 5, 1, 1, 5, 7, 7, 
	5, 1, 3, 3, {0}, 1, 7, 9, 13, 11, 1, 3, 7, 9, 5, 13, 13, 11, 3, 
	15, 5, 3, 15, 7, 9, 13, 9, 1, 11, 7, 5, 15, 1, 15, 11, 5, 3, 1, 7,
	9, {0}, 9, 3, 27, 15, 29, 21, 23, 19, 11, 25, 7, 13, 17, 1, 25, 
	29, 3, 31, 11, 5, 23, 27, 19, 21, 5, 1, 17, 13, 7, 15, 9, 31, 9, {0}, 37, 33, 7, 5, 11, 39, 63, 27, 17, 15, 23, 29, 3, 21, 13, 31, 
	25, 9, 49, 33, 19, 29, 11, 19, 27, 15, 25, {0}, 13, 33, 115, 41, 
	79, 17, 29, 119, 75, 73, 105, 7, 59, 65, 21, 3, 113, 61, 89, 45, 
	107, {0}, 7, 23, 39 };


/* Table of constant values */

static double c_b15 = 2.f;

/* Subroutine */ int bdsobl_(void)
{
	return 0;
} /* bdsobl_ */

double pow_ri(double *ap, int *bp)
{
	double pow, x;
	int n;
	unsigned long u;

	pow = 1;
	x = *ap;
	n = *bp;

	if(n != 0)
	{
		if(n < 0)
		{
			n = -n;
			x = 1/x;
		}
		for(u = n; ; )
		{
			if(u & 01)
				pow *= x;
			if(u >>= 1)
				x *= x;
			else
				break;
		}
	}
	return(pow);
}


/*     INITIALIZES LABELLED COMMON /SOBDAT/ */
/*     FOR "INSOBL". */

/*     THE ARRAY POLY GIVES SUCCESSIVE PRIMITIVE */
/*     POLYNOMIALS CODED IN BINARY, E.G. */
/*          45 = 100101 */
/*     HAS BITS 5, 2, AND 0 SET (COUNTING FROM THE */
/*     RIGHT) AND THEREFORE REPRESENTS */
/*          X**5 + X**2 + X**0 */

/*     THESE  POLYNOMIALS ARE IN THE ORDER USED BY */
/*     SOBOL IN USSR COMPUT. MATHS. MATH. PHYS. 16 (1977), */
/*     236-242. A MORE COMPLETE TABLE IS GIVEN IN SOBOL AND */
/*     LEVITAN, THE PRODUCTION OF POINTS UNIFORMLY */
/*     DISTRIBUTED IN A MULTIDIMENSIONAL CUBE (IN RUSSIAN), */
/*     PREPRINT IPM AKAD. NAUK SSSR, NO. 40, MOSCOW 1976. */

/*         THE INITIALIZATION OF THE ARRAY VINIT IS FROM THE */
/*     LATTER PAPER. FOR A POLYNOMIAL OF DEGREE M, M INITIAL */
/*     VALUES ARE NEEDED :  THESE ARE THE VALUES GIVEN HERE. */
/*     SUBSEQUENT VALUES ARE CALCULATED IN "INSOBL". */





/* Subroutine */ int inssobl_(int *flag__, int *dimen, int *
	atmost, int *taus, double *quasi, int *max__, int *
	iflag)
{
	/* Initialized data */

	static int tau[13] = { 0,0,1,3,5,8,11,15,19,23,27,31,35 };

	/* System generated locals */
	int i__1, i__2, i__3, i__4;
	double r__1;

	/* Builtin functions */
	double pow_ri(double *, int *);
	int lbit_bits(int, int, int);

	/* Local variables */
	static int i__, j, k, l, m, p, v[1240]	/* was [40][31] */;
	static double ll;
	static double pp;
	static int tv[38440]	/* was [40][31][31] */, lsm[1240]	/* was [40][31] */, usm[961]	/* was [31][31] */;
	static int maxx, newv, temp1, temp2, temp3, temp4, shift[40];
	static int includ[8];
	static int ushift[31];


	/*     THIS IS MODIFIED ROUTINE OF "INSOBL". */
	/*     FIRST CHECK WHETHER THE USER-SUPPLIED */
	/*     DIMENSION "DIMEN" OF THE QUASI-RANDOM */
	/*     VECTORS IS STRICTLY BETWEEN 1 AND 41. */
	/*     IF SO, FLAG(1) = .TRUE. */

	/*     NEXT CHECK "ATMOST", AN UPPER BOUND ON THE NUMBER */
	/*     OF CALLS THE USER INTENDS TO MAKE ON "GOSOBL".  IF */
	/*     THIS IS POSITIVE AND LESS THAN 2**30, THEN FLAG(2) = .TRUE. */
	/*     (WE ASSUME WE ARE WORKING ON A COMPUTER WITH */
	/*     WORD LENGTH AT LEAST 31 BITS EXCLUDING SIGN.) */
	/*     THE NUMBER OF COLUMNS OF THE ARRAY V WHICH */
	/*     ARE INITIALIZED IS */
	/*          MAXCOL = NUMBER OF BITS IN ATMOST. */
	/*     IN "GOSOBL" WE CHECK THAT THIS IS NOT EXCEEDED. */

	/*     THE LEADING ELEMENTS OF EACH ROW OF V ARE */
	/*     INITIALIZED USING "VINIT" FROM "BDSOBL". */
	/*     EACH ROW CORRESPONDS TO A PRIMITIVE POLYNOMIAL */
	/*     (AGAIN, SEE "BDSOBL").  IF THE POLYNOMIAL HAS */
	/*     DEGREE M, ELEMENTS AFTER THE FIRST M ARE CALCULATED. */

	/*     THE NUMBERS IN V ARE ACTUALLY BINARY FRACTIONS. */
	/*     LSM ARE LOWER TRIAUGULAR SCRAMBLING MATRICES. */
	/*     USM ARE UPPER TRIAUGULAR SCRMABLING MATRIX. */
	/*     SV ARE SCAMBLING GENERATING MATRICES AND THE NUMBERS */
	/*     ARE BINARY FRACTIONS. */
	/*     "RECIPD" HOLDS 1/(THE COMMON DENOMINATOR OF ALL */
	/*     OF THEM). */


	/*     "INSSOBL" IMPLICITLY COMPUTES THE FIRST SHIFTED */
	/*     VECTOR "LASTQ", AND RETURN IT TO THE CALLING */
	/*     PROGRAM. SUBSEQUENT VECTORS COME FROM "GOSSOBL". */
	/*     "LASTQ" HOLDS NUMERATORS OF THE LAST VECTOR GENERATED. */

	/*     "TAUS" IS FOR DETERMINING "FAVORABLE" VALUES. AS */
	/*     DISCUSSED IN BRATLEY/FOX, THESE HAVE THE FORM */
	/*     N = 2**K WHERE K .GE. (TAUS+S-1) FOR INTEGRATION */
	/*     AND K .GT. TAUS FOR GLOBAL OPTIMIZATION. */

	/*     INPUTS : */
	/*       FROM USER'S PROGRAM : DIMEN, ATMOST, MAX, IFLAG */
	/*       FROM BLOCK DATA "BDSOBL" : POLY, VINIT */

	/*     OUTPUTS : */
	/*       TO USER'S PROGRAM : FLAG, TAUS, LASTQ,QUASI */
	/*       TO "GOSOBL" VIA /SOBOL/ : */
	/*         SV, S, MAXCOL, COUNT, LASTQ, RECIPD */


	/* Parameter adjustments */
	--quasi;
	--flag__;

	/* Function Body */

	/*     CHECK PARAMETERS */

	sobol_1.s = *dimen;
	flag__[1] = sobol_1.s >= 1 && sobol_1.s <= 40;
	flag__[2] = *atmost > 0 && *atmost < 1073741824;
	if (! (flag__[1] && flag__[2])) {
		return 0;
	}
	if (sobol_1.s <= 13) {
		*taus = tau[sobol_1.s - 1];
	} else {
		*taus = -1;
		/*     RETURN A DUMMY VALUE TO THE CALLING PROGRAM */
	}


	/*     FIND NUMBER OF BITS IN ATMOST */

	i__ = *atmost;
	sobol_1.maxcol = 0;
L10:
	++sobol_1.maxcol;
	i__ /= 2;
	if (i__ > 0) {
		goto L10;
	}

	/*     INITIALIZE ROW 1 OF V */

	i__1 = sobol_1.maxcol;
	for (i__ = 1; i__ <= i__1; ++i__) {
		/* L20: */
		v[i__ * 40 - 40] = 1;
	}

	/*     INITIALIZE REMAINING ROWS OF V */

	i__1 = sobol_1.s;
	for (i__ = 2; i__ <= i__1; ++i__) {

		/*     THE BIT PATTERN OF POLYNOMIAL I GIVES ITS FORM */
		/*     (SEE COMMENTS TO "BDSOBL") */
		/*     FIND DEGREE OF POLYNOMIAL I FROM BINARY ENCODING */

		j = sobdat_1.poly[i__ - 2];
		m = 0;
L30:
		j /= 2;
		if (j > 0) {
			++m;
			goto L30;
		}

		/*     WE EXPAND THIS BIT PATTERN TO SEPARATE COMPONENTS */
		/*     OF THE LOGICAL ARRAY INCLUD. */

		j = sobdat_1.poly[i__ - 2];
		for (k = m; k >= 1; --k) {
			includ[k - 1] = j % 2 == 1;
			j /= 2;
			/* L40: */
		}

		/*     THE LEADING ELEMENTS OF ROW I COME FROM VINIT */

		i__2 = m;
		for (j = 1; j <= i__2; ++j) {
			v[i__ + j * 40 - 41] = sobdat_1.vinit[i__ + j * 39 - 41];
			/* L50: */
		}

		/*     CALCULATE REMAINING ELEMENTS OF ROW I AS EXPLAINED */
		/*     IN BRATLEY AND FOX, SECTION 2 */

		i__2 = sobol_1.maxcol;
		for (j = m + 1; j <= i__2; ++j) {
			newv = v[i__ + (j - m) * 40 - 41];
			l = 1;
			i__3 = m;
			for (k = 1; k <= i__3; ++k) {
				l <<= 1;
				if (includ[k - 1]) {
					i__4 = l * v[i__ + (j - k) * 40 - 41];
					newv = exor_(&newv, &i__4);
				}

				/*     IF A FULL-WORD EXCLUSIVE-OR, SAY .XOR., IS AVAILABLE, */
				/*     THEN REPLACE THE PRECEDING STATEMENT BY */

				/*         IF (INCLUD(K)) NEWV = NEWV .XOR. (L * V(I, J-K)) */

				/*     TO GET A FASTER, EXTENDED FORTRAN PROGRAM */

				/* L60: */
			}
			v[i__ + j * 40 - 41] = newv;
			/* L70: */
		}

		/* L100: */
	}

	/*     MULTIPLY COLUMNS OF V BY APPROPRIATE POWER OF 2 */

	l = 1;
	for (j = sobol_1.maxcol - 1; j >= 1; --j) {
		l <<= 1;
		i__1 = sobol_1.s;
		for (i__ = 1; i__ <= i__1; ++i__) {
			v[i__ + j * 40 - 41] *= l;
			/* L110: */
		}
		/* L120: */
	}

	/* COMPUTING GENERATOR MATRICES OF USER CHOICE */

	if (*iflag == 0) {
		i__1 = sobol_1.s;
		for (i__ = 1; i__ <= i__1; ++i__) {
			i__2 = sobol_1.maxcol;
			for (j = 1; j <= i__2; ++j) {
				sobol_1.sv[i__ + j * 40 - 41] = v[i__ + j * 40 - 41];
				/* L140: */
			}
			shift[i__ - 1] = 0;
			/* L130: */
		}
		ll = pow_ri(&c_b15, &sobol_1.maxcol);
	} else {
		if (*iflag == 1 || *iflag == 3) {
			genscrml_(max__, lsm, shift);
			i__1 = sobol_1.s;
			for (i__ = 1; i__ <= i__1; ++i__) {
				i__2 = sobol_1.maxcol;
				for (j = 1; j <= i__2; ++j) {
					l = 1;
					temp2 = 0;
					for (p = *max__; p >= 1; --p) {
						temp1 = 0;
						i__3 = sobol_1.maxcol;
						for (k = 1; k <= i__3; ++k) {
							temp1 += lbit_bits(lsm[i__ + p * 40 - 41], k - 1, 
								(int)1) * lbit_bits(v[i__ + j * 40 - 
								41], k - 1, (int)1);
							/* L260: */
						}
						temp1 %= 2;
						temp2 += temp1 * l;
						l <<= 1;
						/* L250: */
					}
					sobol_1.sv[i__ + j * 40 - 41] = temp2;
					/* L240: */
				}
				/* L230: */
			}
			ll = pow_ri(&c_b15, max__);
		}
		if (*iflag == 2 || *iflag == 3) {
			genscrmu_(usm, ushift);
			if (*iflag == 2) {
				maxx = sobol_1.maxcol;
			} else {
				maxx = *max__;
			}
			i__1 = sobol_1.s;
			for (i__ = 1; i__ <= i__1; ++i__) {
				i__2 = sobol_1.maxcol;
				for (j = 1; j <= i__2; ++j) {
					p = maxx;
					i__3 = maxx;
					for (k = 1; k <= i__3; ++k) {
						if (*iflag == 2) {
							tv[i__ + (p + j * 31) * 40 - 1281] = lbit_bits(v[
								i__ + j * 40 - 41], k - 1, (int)1);
						} else {
							tv[i__ + (p + j * 31) * 40 - 1281] = lbit_bits(
								sobol_1.sv[i__ + j * 40 - 41], k - 1, (
								int)1);
						}
						--p;
						/* L350: */
					}
					/* L340: */
				}
				r__1 = (double) sobol_1.maxcol;
				for (pp = 1.f; pp <= r__1; pp += 1.f) {
					temp2 = 0;
					temp4 = 0;
					l = 1;
					for (j = maxx; j >= 1; --j) {
						temp1 = 0;
						temp3 = 0;
						i__2 = sobol_1.maxcol;
						for (p = 1; p <= i__2; ++p) {
							temp1 += tv[i__ + (j + p * 31) * 40 - 1281] * usm[
								p + (int) pp * 31 - 32];
								if (pp == 1.f) {
									temp3 += tv[i__ + (j + p * 31) * 40 - 1281] * 
										ushift[p - 1];
								}
								/* L370: */
						}
						temp1 %= 2;
						temp2 += temp1 * l;
						if (pp == 1.f) {
							temp3 %= 2;
							temp4 += temp3 * l;
						}
						l <<= 1;
						/* L360: */
					}
					sobol_1.sv[i__ + (int) pp * 40 - 41] = temp2;
					if (pp == 1.f) {
						if (*iflag == 3) {
							shift[i__ - 1] = exor_(&temp4, &shift[i__ - 1]);
						} else {
							shift[i__ - 1] = temp4;
						}
					}
					/* L341: */
				}
				/* L330: */
			}
			ll = pow_ri(&c_b15, &maxx);
		}
	}

	/*     RECIPD IS 1/(COMMON DENOMINATOR OF THE ELEMENTS IN V) */

	sobol_1.recipd = 1.f / ll;

	/*     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL" */

	sobol_1.count = 0;
	i__1 = sobol_1.s;
	for (i__ = 1; i__ <= i__1; ++i__) {
		sobol_1.lastq[i__ - 1] = shift[i__ - 1];
		quasi[i__] = sobol_1.lastq[i__ - 1] * sobol_1.recipd;
		/* L400: */
	}
	return 0;
} /* inssobl_ */

/* Subroutine */ int genscrml_(int *max__, int *lsm, int *shift)
{
	/* System generated locals */
	int i__1;

	/* Local variables */
	static int i__, j, l, p, ll;
	static int temp, stemp;

	/*     GENERATING LOWER TRIANULAR SCRMABLING MATRICES AND SHIFT VECTORS. */
	/*     INPUTS : */
	/*       FROM INSSOBL : MAX */
	/*       FROM BLOCK DATA "SOBOL" : S, MAXCOL, */

	/*     OUTPUTS : */
	/*       TO INSSOBL : LSM, SHIFT */
	/* Parameter adjustments */
	--shift;
	lsm -= 41;

	/* Function Body */
	i__1 = sobol_2.s;
	for (p = 1; p <= i__1; ++p) {
		shift[p] = 0;
		l = 1;
		for (i__ = *max__; i__ >= 1; --i__) {
			lsm[p + i__ * 40] = 0;
			stemp = (int) (uni_() * 1e3f) % 2;
			shift[p] += stemp * l;
			l <<= 1;
			ll = 1;
			for (j = sobol_2.maxcol; j >= 1; --j) {
				if (j == i__) {
					temp = 1;
				} else if (j < i__) {
					temp = (int) (uni_() * 1e3f) % 2;
				} else {
					temp = 0;
				}
				lsm[p + i__ * 40] += temp * ll;
				ll <<= 1;
				/* L30: */
			}
			/* L20: */
		}
		/* L10: */
	}
	return 0;
} /* genscrml_ */

/* Subroutine */ int genscrmu_(int *usm, int *ushift)
{
	/* System generated locals */
	int i__1, i__2;

	/* Local variables */
	static int i__, j;
	static int temp, stemp;

	/*     GENERATING UPPER TRIANGULAR SCRMABLING MATRICES AND */
	/*     SHIFT VECTORS. */
	/*     INPUTS : */
	/*       FROM BLOCK DATA "SOBOL" : S, MAXCOL, */

	/*     OUTPUTS : */
	/*       TO INSSOBL : USM, USHIFT */
	/* Parameter adjustments */
	--ushift;
	usm -= 32;

	/* Function Body */
	i__1 = sobol_2.maxcol;
	for (i__ = 1; i__ <= i__1; ++i__) {
		stemp = (int) (uni_() * 1e3f) % 2;
		ushift[i__] = stemp;
		i__2 = sobol_2.maxcol;
		for (j = 1; j <= i__2; ++j) {
			if (j == i__) {
				temp = 1;
			} else if (j > i__) {
				temp = (int) (uni_() * 1e3f) % 2;
			} else {
				temp = 0;
			}
			usm[i__ + j * 31] = temp;
			/* L30: */
		}
		/* L20: */
	}
	return 0;
} /* genscrmu_ */

/*
*   PURPOSE
*      Generates random numbers uniform in (0,2147483647)
*      This is the URAND generator: 
*          s <- (a*s + c) mod m
*      with :
*             m = 2^{31} 
*             a = 843314861
*             c = 453816693
*      
*      s must be in [0,m-1] when user changes seed with unifrng_urand_set_state
*      period = m
*/
/* Reference
*   URAND, A UNIVERSAL RANDOM NUMBER GENERATOR 
*   BY, MICHAEL A. MALCOLM, CLEVE B. MOLER, 
*   STAN-CS-73-334, JANUARY 1973, 
*   COMPUTER SCIENCE  DEPARTMENT, 
*   School of Humanities and Sciences, STANFORD UNIVERSITY, 
*   ftp://reports.stanford.edu/pub/cstr/reports/cs/tr/73/334/CS-TR-73-334.pdf
*/
static unsigned int s = 0;

unsigned int myurand_raw()
{
	do
	{
		/* We get a result modulo 2^32 */
		s = 843314861ul * s + 453816693ul;  

		/* This is to get modulo 2^31 */
		if (s >= 2147483648ul) 
		{
			s -= 2147483648ul;
		}
	} while(s==0);

	return ( s );
}

// Returns a double randomly uniform in (0,1).
// This random number is generated according to the current RNG.
double uni_(void)
{
	double output;
	int R;
	// This is factor=1/2147483647
	double factor=4.6566128730773926e-10;
	R = myurand_raw();
	output = (double) R * factor;
	return output;
}

/* Subroutine */ int gossobl_(double *quasi)
{
	/* System generated locals */
	int i__1;

	/* Local variables */
	static int i__, l;


	/*     THIS SUBROUTINE GENERATES A NEW */
	/*     QUASIRANDOM VECTOR WITH EACH CALL */

	/*     IT ADAPTS THE IDEAS OF ANTONOV AND SALEEV, */
	/*     USSR COMPUT. MATHS. MATH. PHYS. 19 (1980), */
	/*     252 - 256 */

	/*     THE USER MUST CALL "INSOBL" BEFORE CALLING */
	/*     "GOSOBL".  AFTER CALLING "INSOBL", TEST */
	/*     FLAG(1) AND FLAG(2);  IF EITHER IS FALSE, */
	/*     DO NOT CALL "GOSOBL".  "GOSOBL" CHECKS */
	/*     THAT THE USER DOES NOT MAKE MORE CALLS */
	/*     THAN HE SAID HE WOULD : SEE THE COMMENTS */
	/*     TO "INSOBL". */

	/*     INPUTS: */
	/*       FROM USER'S CALLING PROGRAM: */
	/*         NONE */

	/*       FROM LABELLED COMMON /SOBOL/: */
	/*         SV        TABLE OF DIRECTION NUMBERS */
	/*         S        DIMENSION */
	/*         MAXCOL   LAST COLUMN OF V TO BE USED */
	/*         COUNT    SEQUENCE NUMBER OF THIS CALL */
	/*         LASTQ    NUMERATORS FOR LAST VECTOR GENERATED */
	/*         RECIPD   (1/DENOMINATOR) FOR THESE NUMERATORS */


	/*     FIND THE POSITION OF THE RIGHT-HAND ZERO IN COUNT */

	/* Parameter adjustments */
	--quasi;

	/* Function Body */
	l = 0;
	i__ = sobol_1.count;
L1:
	++l;
	if (i__ % 2 == 1) {
		i__ /= 2;
		goto L1;
	}

	/*     CHECK THAT THE USER IS NOT CHEATING ! */

	if (l > sobol_1.maxcol) {
		printf(" TOO MANY CALLS ON GOSOBL");
		exit(-1);
	}

	/*     CALCULATE THE NEW COMPONENTS OF QUASI, */
	/*     FIRST THE NUMERATORS, THEN NORMALIZED */

	i__1 = sobol_1.s;
	for (i__ = 1; i__ <= i__1; ++i__) {
		sobol_1.lastq[i__ - 1] = exor_(&sobol_1.lastq[i__ - 1], &sobol_1.sv[
			i__ + l * 40 - 41]);

			/*     IF A FULL-WORD EXCLUSIVE-OR, SAY .XOR., IS AVAILABLE */
			/*     THEN REPLACE THE PRECEDING STATEMENT BY */

			/*         LASTQ(I) = LASTQ(I) .XOR. SV(I,L) */

			/*     TO GET A FASTER, EXTENDED FORTRAN PROGRAM */

			quasi[i__] = sobol_1.lastq[i__ - 1] * sobol_1.recipd;
			/* L2: */
	}

	++sobol_1.count;

	return 0;
} /* gossobl_ */

int exor_(int *iin, int *jin)
{
	/* System generated locals */
	int ret_val;

	/* Local variables */
	static int i__, j, k, l;


	/*     THIS FUNCTION CALCULATES THE EXCLUSIVE-OR OF ITS */
	/*     TWO INPUT PARAMETERS */

	i__ = *iin;
	j = *jin;
	k = 0;
	l = 1;

L1:
	if (i__ == j) {
		ret_val = k;
		return ret_val;
	}

	/*     CHECK THE CURRENT RIGHT-HAND BITS OF I AND J. */
	/*     IF THEY DIFFER, SET THE APPROPRIATE BIT OF K. */

	if (i__ % 2 != j % 2) {
		k += l;
	}
	i__ /= 2;
	j /= 2;
	l <<= 1;
	goto L1;
} /* exor_ */

int lbit_bits(int a, int b, int len)
{
	/* Assume 2's complement arithmetic */

	unsigned long x, y;

	x = (unsigned long) a;
	y = (unsigned long)-1L;
	x >>= b;
	y <<= len;
	return (int)(x & ~y);
	}

typedef long int flag;
typedef long int ftnlen;
typedef long int ftnint;

/*external read, write*/
typedef struct
{       flag cierr;
        ftnint ciunit;
        flag ciend;
        char *cifmt;
        ftnint cirec;
} cilist;
/* Main program */ int main(void)
{
	/* Local variables */
	int i, j, sam, max__;
	int flag__[2];
	int taus, iflag, dimen;
	double quasi[40];
	int atmost;

	/*      User Define: */
	/*        DIMEN : dimension */
	/*        ATMOST : sequence length */
	/*        SAM : Number of replications */
	/*        MAX : Maximum Digits of Scrambling Of Owen type Scrambling */
	/*        IFLAG: User Choice of Sequences */
	/*        IFLAG = 0 : No Scrambling */
	/*        IFLAG = 1 : Owen type Scrambling */
	/*        IFLAG = 2 : Faure-Tezuka type Scrambling */
	/*        IFLAG = 3 : Owen + Faure-Tezuka type Scrambling */

	sam = 1;
	max__ = 30;
	dimen = 2;
	iflag = 1;
	atmost = 50;
	inssobl_(flag__, &dimen, &atmost, &taus, quasi, &max__, &iflag);
	for (i = 2; i <= atmost; i++) {
		gossobl_(quasi);
		printf("quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			printf(" %f",quasi[j]);
		}
		printf("\n");
	}
	return 0;
} /* MAIN__ */


