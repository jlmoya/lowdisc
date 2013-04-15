// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#ifndef _LOWDISC_SSOBOL_H_
#define _LOWDISC_SSOBOL_H_

#ifdef _MSC_VER
#if LIBLOWDISC_EXPORTS 
#define LOWDISC_IMPORTEXPORT __declspec (dllexport)
#else
#define LOWDISC_IMPORTEXPORT __declspec (dllimport)
#endif
#else
#define LOWDISC_IMPORTEXPORT
#endif

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS // empty 
# define __END_DECLS // empty 
#endif

__BEGIN_DECLS


//! Class of Scrambled Sobol Sequence
class LOWDISC_IMPORTEXPORT Ssobol {
public :
	int ssobol_poly[39];
	int ssobol_vinit[40][8];
	double ssobol_recipd;
	int ssobol_lastq[40];
	int ssobol_maxcol;
	int ssobol_count;
	int ssobol_s;
	int ssobol_sv[40][31];
	int ssobol_tau[13];
	unsigned int ssobol_unifseed;

	// Variables for the random number generator.
	int ssobol_seedi;
	int ssobol_seedj;
	double ssobol_seedcarry;
	double ssobol_seedseeds[24];

public:
	/*
	Startup the Scrambled Sobol sequence.

	Parameters

	INPUTS : 
	dimen : the number of dimensions, DIMEN in {1,2,...,40}
	atmost : the maximum number of elements in the sequence, ATMOST in {1,2,...,2^30=1073741824}
	maxd : Maximum Digits of Scrambling Of Owen type Scrambling (suggestion : maxd=30)
	iflag: the scrambling type
	iflag = 0 : No Scrambling
	iflag = 1 : Owen type Scrambling
	iflag = 2 : Faure-Tezuka type Scrambling
	iflag = 3 : Owen + Faure-Tezuka type Scrambling

	OUTPUTS : 
	quasi : the first element in the sequence
	taus : to determine favorable number of calls (see below)

	Description
	THIS IS MODIFIED ROUTINE OF "INSOBL". 
	FIRST CHECK WHETHER THE USER-SUPPLIED 
	DIMENSION "DIMEN" OF THE QUASI-RANDOM 
	VECTORS IS STRICTLY BETWEEN 1 AND 41. 

	CHECK "ATMOST", AN UPPER BOUND ON THE NUMBER 
	OF CALLS THE USER INTENDS TO MAKE ON "GOSOBL".  IF 
	THIS IS POSITIVE AND LESS THAN 2**30, THEN FLAG(2) = .TRUE. 
	(WE ASSUME WE ARE WORKING ON A COMPUTER WITH 
	WORD LENGTH AT LEAST 31 BITS EXCLUDING SIGN.) 
	THE NUMBER OF COLUMNS OF THE ARRAY V WHICH 
	ARE INITIALIZED IS 
	MAXCOL = NUMBER OF BITS IN ATMOST. 
	IN "GOSOBL" WE CHECK THAT THIS IS NOT EXCEEDED. 

	THE LEADING ELEMENTS OF EACH ROW OF V ARE 
	INITIALIZED USING "VINIT" FROM "BDSOBL". 
	EACH ROW CORRESPONDS TO A PRIMITIVE POLYNOMIAL 
	(AGAIN, SEE "BDSOBL").  IF THE POLYNOMIAL HAS 
	DEGREE M, ELEMENTS AFTER THE FIRST M ARE CALCULATED. 

	THE NUMBERS IN V ARE ACTUALLY BINARY FRACTIONS. 
	LSM ARE LOWER TRIAUGULAR SCRAMBLING MATRICES. 
	USM ARE UPPER TRIAUGULAR SCRMABLING MATRIX. 
	SV ARE SCAMBLING GENERATING MATRICES AND THE NUMBERS 
	ARE BINARY FRACTIONS. 
	"RECIPD" HOLDS 1/(THE COMMON DENOMINATOR OF ALL 
	OF THEM). 


	"INSSOBL" IMPLICITLY COMPUTES THE FIRST SHIFTED 
	VECTOR "LASTQ", AND RETURN IT TO THE CALLING 
	PROGRAM. SUBSEQUENT VECTORS COME FROM "GOSSOBL". 
	"LASTQ" HOLDS NUMERATORS OF THE LAST VECTOR GENERATED. 

	"TAUS" IS FOR DETERMINING "FAVORABLE" VALUES. AS 
	DISCUSSED IN BRATLEY/FOX, THESE HAVE THE FORM 
	N = 2**K WHERE K .GE. (TAUS+S-1) FOR INTEGRATION 
	AND K .GT. TAUS FOR GLOBAL OPTIMIZATION. 

	*/

	//! Constructor from a set of stochastic variables, where ny is the number of output
	Ssobol(int dimen, int atmost, int iflag, int maxd, int *taus);

	// Destructor (free the allocated memory)
	~Ssobol();

	// Next element in the Scrambled Sobol Sequence
	//
	// Parameters
	// quasi : an array of doubles, quasi[0,1,...,dimen-1]
	void next(double *quasi);

	// Reset the seed of the random number generator.
	// This is automatically done the first time the 
	// ssobol_startup function is called or the first time the 
	// function ssobol_seedreset is called. 
	// This can be done when required, for example, when 
	// generating a new sequence. 
	// The suggested steps are:
	//
	// seedreset(); // Optionnal
	// startup(...);
	// next(...);
	// delete seq;
	//
	void seedreset();

	//  ssobol_isstart --
	//     Returns true if the sequence is already started up.
	//
	//  Parameters:
	//    startup, output : true if the sequence is already started up.
	bool isstart ( );

	// dim_num_get -- 
	// gets the spatial dimension for a leaped Halton subsequence.
	int dim_num_get ( void );
	//
	// seedset --
	// Sets the seed of the random number generator
	void seedset(double newseeds[24]);
private:
	int exor(int *iin, int *jin);
	int genscrml(int maxd, int lsm[][31], int *shift);
	int genscrmu(int usm[][31], int *ushift);
	double unirnd(void);
	int lbitbits(int a, int b, int len);
};

__END_DECLS

#endif /* _LOWDISC_SSOBOL_H_ */

