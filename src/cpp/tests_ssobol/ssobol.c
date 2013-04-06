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
int genscrml_(int *maxd, int *lsm, int *shift);
int genscrmu_(int *usm, int *ushift);
double uni_(void);
int lbit_bits(int a, int b, int len);

// Static variables
static int ssobol_poly[39] = {
	3, 7, 11, 13, 19, 25, 37, 59, 47, 61, 55, 41, 67, 97, 91, 
	109, 103, 115, 131, 193, 137, 145, 143, 241, 157, 185, 167, 229, 
	171, 213, 191, 253, 203, 211, 239, 247, 285, 369, 299
};

static int ssobol_vinit[40][8];
static double ssobol_recipd;
static int ssobol_lastq[40];
static int ssobol_maxcol;
static int ssobol_count;
static int ssobol_s;
static int ssobol_sv[40][31];
static int ssobol_tau[13] = { 0,0,1,3,5,8,11,15,19,23,27,31,35 };


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

int ssobol_startup(int dimen, int atmost, int *taus, double *quasi, int *maxd, int *iflag)
{
	/* Initialized data */


	/* System generated locals */
	int i__4;
	double r__1;

	/* Local variables */
	static int i, j, k, l, m, p;
	static int v[1240]	/* was [40][31] */;
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

	/* Function Body */

	/*     CHECK PARAMETERS */
	ssobol_s = dimen;
	if (ssobol_s < 1 || ssobol_s > 40) {
		printf("ssobol_next : wrong dimension : %d (must be in [1,40]).",ssobol_s);
		exit(-1);
	}
	if (atmost <= 0 || atmost >= 1073741824) {
		printf("ssobol_next : wrong number of calls : %d (must be in [1,1073741823]).",atmost);
		exit(-1);
	}
	if (ssobol_s <= 13) {
		*taus = ssobol_tau[ssobol_s - 1];
	} else {
		*taus = -1;
		/*     RETURN A DUMMY VALUE TO THE CALLING PROGRAM */
	}

	// Initialise ssobol_vinit;
	for (j = 0; j < 8; j++)
	{
		for (i = 1; i < 40; i++) 
		{
			ssobol_vinit[i][j] = 0;
		}
	}
#include "ssobol_poly.h"

	/*     FIND NUMBER OF BITS IN ATMOST */

	i = atmost;
	ssobol_maxcol = 0;
L10:
	++ssobol_maxcol;
	i /= 2;
	if (i > 0) {
		goto L10;
	}

	/*     INITIALIZE ROW 1 OF V */

	for (i = 1; i <= ssobol_maxcol; ++i) {
		v[i * 40 - 40] = 1;
	}

	/*     INITIALIZE REMAINING ROWS OF V */

	for (i = 2; i <= ssobol_s; ++i) {

		/*     THE BIT PATTERN OF POLYNOMIAL I GIVES ITS FORM */
		/*     (SEE COMMENTS TO "BDSOBL") */
		/*     FIND DEGREE OF POLYNOMIAL I FROM BINARY ENCODING */

		j = ssobol_poly[i - 2];
		m = 0;
L30:
		j /= 2;
		if (j > 0) {
			++m;
			goto L30;
		}

		/*     WE EXPAND THIS BIT PATTERN TO SEPARATE COMPONENTS */
		/*     OF THE LOGICAL ARRAY INCLUD. */

		j = ssobol_poly[i - 2];
		for (k = m; k >= 1; --k) {
			includ[k - 1] = j % 2 == 1;
			j /= 2;
		}

		/*     THE LEADING ELEMENTS OF ROW I COME FROM VINIT */

		for (j = 1; j <= m; ++j) {
			v[i + j * 40 - 41] = ssobol_vinit[i-1][j-1];
		}

		/*     CALCULATE REMAINING ELEMENTS OF ROW I AS EXPLAINED */
		/*     IN BRATLEY AND FOX, SECTION 2 */

		for (j = m + 1; j <= ssobol_maxcol; ++j) {
			newv = v[i + (j - m) * 40 - 41];
			l = 1;
			for (k = 1; k <= m; ++k) {
				l <<= 1;
				if (includ[k - 1]) {
					i__4 = l * v[i + (j - k) * 40 - 41];
					newv = exor_(&newv, &i__4);
				}
				/*     IF A FULL-WORD EXCLUSIVE-OR, SAY .XOR., IS AVAILABLE, */
				/*     THEN REPLACE THE PRECEDING STATEMENT BY */
				/*         IF (INCLUD(K)) NEWV = NEWV .XOR. (L * V(I, J-K)) */
				/*     TO GET A FASTER, EXTENDED FORTRAN PROGRAM */
			}
			v[i + j * 40 - 41] = newv;
		}
	}

	/*     MULTIPLY COLUMNS OF V BY APPROPRIATE POWER OF 2 */

	l = 1;
	for (j = ssobol_maxcol - 1; j >= 1; --j) {
		l <<= 1;
		for (i = 1; i <= ssobol_s; ++i) {
			v[i + j * 40 - 41] *= l;
		}
	}

	/* COMPUTING GENERATOR MATRICES OF USER CHOICE */

	if (*iflag == 0) {
		for (i = 1; i <= ssobol_s; ++i) {
			for (j = 1; j <= ssobol_maxcol; ++j) {
				ssobol_sv[i-1][j-1] = v[i + j * 40 - 41];
			}
			shift[i - 1] = 0;
		}
		ll = pow(2.0, ssobol_maxcol);
	} else {
		if (*iflag == 1 || *iflag == 3) {
			genscrml_(maxd, lsm, shift);
			for (i = 1; i <= ssobol_s; ++i) {
				for (j = 1; j <= ssobol_maxcol; ++j) {
					l = 1;
					temp2 = 0;
					for (p = *maxd; p >= 1; --p) {
						temp1 = 0;
						for (k = 1; k <= ssobol_maxcol; ++k) {
							temp1 += lbit_bits(lsm[i + p * 40 - 41], k - 1, 
								(int)1) * lbit_bits(v[i + j * 40 - 
								41], k - 1, (int)1);
						}
						temp1 %= 2;
						temp2 += temp1 * l;
						l <<= 1;
					}
					ssobol_sv[i-1][j-1] = temp2;
				}
			}
			ll = pow(2.0, *maxd);
		}
		if (*iflag == 2 || *iflag == 3) {
			genscrmu_(usm, ushift);
			if (*iflag == 2) {
				maxx = ssobol_maxcol;
			} else {
				maxx = *maxd;
			}
			for (i = 1; i <= ssobol_s; ++i) {
				for (j = 1; j <= ssobol_maxcol; ++j) {
					p = maxx;
					for (k = 1; k <= maxx; ++k) {
						if (*iflag == 2) {
							tv[i + (p + j * 31) * 40 - 1281] = lbit_bits(v[
								i + j * 40 - 41], k - 1, (int)1);
						} else {
							tv[i + (p + j * 31) * 40 - 1281] = lbit_bits(
								ssobol_sv[i-1][j-1], k - 1, (
								int)1);
						}
						--p;
					}
				}
				r__1 = (double) ssobol_maxcol;
				for (pp = 1.f; pp <= r__1; pp += 1.f) {
					temp2 = 0;
					temp4 = 0;
					l = 1;
					for (j = maxx; j >= 1; --j) {
						temp1 = 0;
						temp3 = 0;
						for (p = 1; p <= ssobol_maxcol; ++p) {
							temp1 += tv[i + (j + p * 31) * 40 - 1281] * usm[
								p + (int) pp * 31 - 32];
								if (pp == 1.f) {
									temp3 += tv[i + (j + p * 31) * 40 - 1281] * 
										ushift[p - 1];
								}
						}
						temp1 %= 2;
						temp2 += temp1 * l;
						if (pp == 1.f) {
							temp3 %= 2;
							temp4 += temp3 * l;
						}
						l <<= 1;
					}
					ssobol_sv[i-1][(int) pp-1] = temp2;
					if (pp == 1.f) {
						if (*iflag == 3) {
							shift[i - 1] = exor_(&temp4, &shift[i - 1]);
						} else {
							shift[i - 1] = temp4;
						}
					}
				}
			}
			ll = pow(2.0, maxx);
		}
	}

	/*     RECIPD IS 1/(COMMON DENOMINATOR OF THE ELEMENTS IN V) */

	ssobol_recipd = 1.0 / ll;

	/*     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL" */

	ssobol_count = 0;
	for (i = 1; i <= ssobol_s; ++i) {
		ssobol_lastq[i - 1] = shift[i - 1];
		quasi[i] = ssobol_lastq[i - 1] * ssobol_recipd;
	}
	return 0;
}

/* Subroutine */ int genscrml_(int *maxd, int *lsm, int *shift)
{
	/* Local variables */
	static int i, j, l, p, ll;
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
	for (p = 1; p <= ssobol_s; ++p) {
		shift[p] = 0;
		l = 1;
		for (i = *maxd; i >= 1; --i) {
			lsm[p + i * 40] = 0;
			stemp = (int) (uni_() * 1e3f) % 2;
			shift[p] += stemp * l;
			l <<= 1;
			ll = 1;
			for (j = ssobol_maxcol; j >= 1; --j) {
				if (j == i) {
					temp = 1;
				} else if (j < i) {
					temp = (int) (uni_() * 1e3f) % 2;
				} else {
					temp = 0;
				}
				lsm[p + i * 40] += temp * ll;
				ll <<= 1;
			}
		}
	}
	return 0;
} /* genscrml_ */

/* Subroutine */ int genscrmu_(int *usm, int *ushift)
{
	/* Local variables */
	static int i, j;
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
	for (i = 1; i <= ssobol_maxcol; ++i) {
		stemp = (int) (uni_() * 1e3f) % 2;
		ushift[i] = stemp;
		for (j = 1; j <= ssobol_maxcol; ++j) {
			if (j == i) {
				temp = 1;
			} else if (j > i) {
				temp = (int) (uni_() * 1e3f) % 2;
			} else {
				temp = 0;
			}
			usm[i + j * 31] = temp;
		}
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

int ssobol_next(double *quasi)
{
	/* Local variables */
	static int i, l;


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
	i = ssobol_count;
L1:
	++l;
	if (i % 2 == 1) {
		i /= 2;
		goto L1;
	}

	/*     CHECK THAT THE USER IS NOT CHEATING ! */

	if (l > ssobol_maxcol) {
		printf("ssobol_next : too many calls.");
		exit(-1);
	}

	/*     CALCULATE THE NEW COMPONENTS OF QUASI, */
	/*     FIRST THE NUMERATORS, THEN NORMALIZED */

	for (i = 1; i <= ssobol_s; ++i) 
	{
		ssobol_lastq[i - 1] = exor_(&ssobol_lastq[i - 1], &ssobol_sv[i-1][l-1]);

		/*     IF A FULL-WORD EXCLUSIVE-OR, SAY .XOR., IS AVAILABLE */
		/*     THEN REPLACE THE PRECEDING STATEMENT BY */
		/*         LASTQ(I) = LASTQ(I) .XOR. SV(I,L) */
		/*     TO GET A FASTER, EXTENDED FORTRAN PROGRAM */
		quasi[i] = ssobol_lastq[i - 1] * ssobol_recipd;
	}

	++ssobol_count;

	return 0;
}

int exor_(int *iin, int *jin)
{
	/* System generated locals */
	int ret_val;

	/* Local variables */
	static int i, j, k, l;


	/*     THIS FUNCTION CALCULATES THE EXCLUSIVE-OR OF ITS */
	/*     TWO INPUT PARAMETERS */

	i = *iin;
	j = *jin;
	k = 0;
	l = 1;

L1:
	if (i == j) {
		ret_val = k;
		return ret_val;
	}

	/*     CHECK THE CURRENT RIGHT-HAND BITS OF I AND J. */
	/*     IF THEY DIFFER, SET THE APPROPRIATE BIT OF K. */

	if (i % 2 != j % 2) {
		k += l;
	}
	i /= 2;
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


int main(void)
{
	/* Local variables */
	int i, j, sam, maxd;
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
	maxd = 30;
	dimen = 5;
	iflag = 3;
	atmost = 50;
	printf("iflag=%d\n",iflag);
	printf("atmost=%d\n",atmost);
	printf("dimen=%d\n",dimen);
	printf("maxd=%d\n",maxd);
	ssobol_startup(dimen, atmost, &taus, quasi, &maxd, &iflag);
	for (i = 2; i <= atmost; i++) {
		ssobol_next(quasi);
		printf("quasi(%d)=",i);
		for (j= 0; j < dimen; j++) {
			printf(" %f",quasi[j]);
		}
		printf("\n");
	}
	return 0;
}


