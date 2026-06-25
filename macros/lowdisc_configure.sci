// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = lowdisc_configure (this,key,value)
    // Configure a field of the object and returns the modified object.
    //
    // Calling Sequence
    //   this = lowdisc_configure (this,key,value)
    //
    // Parameters
    //   this: the current object
    //   key: a string. The name of the option to get. All options which can be set with lowdisc_configure can be get with lowdisc_cget.
    //   value: the value associated with the key. Its type depends on the value of the key.
    //
    // Description
    //   This command allows to configure the state of the current object.
    //   It requires to take the current object both as an input
    //   and output argument.
    //
    //   To get a global overview of the supported options, 
    //   please use 
    //   <screen>
    //   help lowdisc_options
    //   </screen>
    //
    //  The following keys are available: <literal>"-dimension"</literal>, 
    // <literal>"-skip"</literal>, <literal>"-leap"</literal>, <literal>"-verbose"</literal>, <literal>"-coordinate"</literal>.
    //  <itemizedlist>
    //   <listitem>
    //     <para>
    //     <literal>"-dimension"</literal> : a positive floating point integer, 
    //     the dimension of the space, i.e.
    //     the size of the vector returned by the command lowdisc_next (default = 1).
    //     </para>
    //   </listitem>
    //   <listitem>
    //     <para>
    //     <literal>"-skip"</literal> : a positive floating point integer, 
    //     the number of terms to skip at startup. 
    //     When the sequence is started up at the first call to lowdisc_next,
    //     then skip elements are ignored in the sequence, so that the 
    //     next point will be generated at index <literal>skip+1</literal>.
    //     For example, Fox recommends to skip the <literal>qs^4 - 2</literal> first terms in the 
    //     Faure sequence, where qs is the prime number associated with the 
    //     sequence. This number can be retrieved with 
    //     <literal>qs=lowdisc_get(lds,"-faureprime")</literal>.
    //     </para>
    //   </listitem>
    //   <listitem>
    //      <para>
    //      <literal>"-leap"</literal> : a positive floating point integer, 
    //      the number of elements to ignore from element to element (default = 0).
    //      Each time the lowdisc_next function is called, the immediate element
    //      is retrieved. Then, in order to prepare for the next call,
    //      there are leap elements which are generated and immediately
    //      discarded. This option allows to generate alternative 
    //      sequences based on the same basic generator.
    //      </para>
    //    </listitem>
    //    <listitem>
    //      <para>
    //      <literal>"-verbose"</literal> : a boolean, the verbose mode (default : %f).
    //      </para>
    //    </listitem>
    //    <listitem>
    //      <para>
    //      <literal>"-coordinate"</literal> : a boolean (default : %f). 
    //        By default, coordinate is false, meaning that all coordinates 
    //        1,2,...,dimension are computed, as usual.
    //        If coordinate is true, only one single coordinate is computed 
    //        and returned by lowdisc_next(), which then returns 
    //        a vector instead of a matrix. 
    //        The indice of this coordinate is specified by the 
    //        "-dimension" option. 
    //        This allows to directly get the dimension-th coordinate of the 
    //        sequence, without generating the dimensions 1,2,...,dimension-1.
    //        This can be useful in cases where the number of dimensions is 
    //        not known in advance, e.g. in dynamic simulations.
    //      </para>
    //    </listitem>
    //  </itemizedlist>
    //
    // Some sequences can be configured in order to increase their maximum
    // dimension. 
    // These sequences accept the <literal>"-primeslist"</literal> option.
    // The sequences which are sensitive to this option are : "halton", 
    // "faure".
    //  <itemizedlist>
    //    <listitem>
    //     <para>
    //     <literal>"-primeslist"</literal> : a 1-by-n array of positive 
    //     floating point integers, where n is greater than 2, 
    //     a matrix of prime numbers used in several low discrepancy sequences.
    //     The default value is made of the 100 first prime numbers, from 2 
    //     to 541, which enables the user to generate sequences up to 100 
    //     dimensions.
    //     If a larger dimension problem is to manage, the -primeslist option 
    //     enables users to customize the list to meet the required dimension.
    //     The user should be warned that the Halton sequence may produce 
    //     poor convergence rate if the dimension is larger than 15.
    //     </para>
    //    </listitem>
    //  </itemizedlist>
    //
    //  For the "niederreiter" sequence (Fast Niederreiter sequence in arbitrary base), 
    //  we can configure the base as following. 
    //  <itemizedlist>
    //  <listitem>
    //     <para>
    //     <literal>"-base"</literal> : a floating point number, greater than 2.
    //     The base can be an odd or even integer.
    //     The default value is 2. 
    //     It may be the smallest prime larger than the dimension as in the 
    //     Faure sequence, although it does not guarantee that this 
    //     leads to a lower discrepancy.
    //     See the <literal>lowdisc_niedersuggest</literal> function for a suggestion of the optimal 
    //     base, depending on the dimension.
    //     </para>
    //  </listitem>
    //  </itemizedlist>
    //
    //  For the "halton" sequence, 
    //  we can configure the scrambling as following. 
    //  <itemizedlist>
    //  <listitem>
    //     <para>
    //     <literal>"-scrambling"</literal> : a 1-by-1 matrix of strings, the 
    //     empty string "" (no scrambling), 
    //     "RR2" for the scrambling of Kocis-Whiten [1] 
    //     or "Reverse" for the scrambling of Vandewoestyne and Cools [2]. 
    //     The default is "" (no scrambling). 
    //     The scrambling can improve the correlation in high dimensions, 
    //     leading to better low-dimensionnal projections. 
    //     These are deterministic scramblings. 
    //     </para>
    //  </listitem>
    //  </itemizedlist>
    //
    //  For the "sobol" sequence, 
    //  we can configure the scrambling as following. 
    //  <itemizedlist>
    //  <listitem>
    //     <para>
    //     <literal>"-scrambling"</literal> : a 1-by-1 matrix of strings, 
    //     the empty string "" (no scrambling), 
    //     <literal>"Owen"</literal> for the scrambling (digit permutation) of Owen, 
    //     <literal>"Faure-Tezuka"</literal> or 
    //     <literal>"Owen-Faure-Tezuka"</literal>. 
    //     The default is "" (no scrambling). 
    //     The scrambling can improve the correlation in high dimensions, 
    //     leading to better low-dimensionnal projections.
    //     </para>
    //  </listitem>
    //  <listitem>
    //     <para>
    //     <literal>"-seeds"</literal> : a 1-by-24 or 24-by-1 matrix of doubles, 
    //     the seeds used in the random number generator used in the 
    //     scrambling (if scrambling is enabled). 
    //     The default is 
    //     <screen>
    //     seeds= [.8804418,.2694365,.0367681,.4068699,..
    //     .4554052,.2880635,.1463408,.2390333,.6407298,..
    //     .1755283,.713294,.4913043,.2979918,.1396858,..
    //     .3589528,.5254809,.9857749,.4612127,.2196441,..
    //     .7848351,.40961,.9807353,.2689915,.5140357]
    //     </screen>
    //     This option can be used in order to generate 
    //     a scrambled Sobol sequences different from the default.
    //     In order to generate a seeds matrix, we can use the statement:
    //     <screen>
    //     seeds=distfun_unifrnd(0,1,1,24)
    //     </screen>
    //     The "-seeds" option only acts on the "sobol" sequence.
    //     </para>
    //  </listitem>
    //  </itemizedlist>
    //
    //  Some expertise is required to configure the <literal>skip</literal> 
    //  and <literal>leap</literal> options.
    //  The <literal>skip</literal> option can improve the Faure, Sobol and 
    //  Niederreiter sequences.
    //  The <literal>leap</literal> option can improve the Halton sequence, although 
    //  Kocis and Whiten also tried to leap the Faure and Sobol sequences.
    //  This can lead to some trouble for non-experts.
    //  For that purpose, we designed the following functions.
    //  <itemizedlist>
    //  <listitem><para> <literal>lowdisc_haltonsuggest</literal> : provides 
    //    settings for the (unscrambled) Halton sequence,</para></listitem>
    //  <listitem><para> <literal>lowdisc_fauresuggest</literal> : provides 
    //    settings for the Faure sequence,</para></listitem>
    //  <listitem><para> <literal>lowdisc_sobolsuggest</literal> : provides 
    //    settings for the (unscrambled) Sobol sequence,</para></listitem>
    //  <listitem><para> <literal>lowdisc_niedersuggest</literal> : provides 
    //    settings for the Niederreiter sequence.</para></listitem>
    //  </itemizedlist>
    //
    //  These functions have been designed to include suggestions by various 
    //  authors to improve the sequences.
    //  In the situation where we have no knowledge of the settings to use, these 
    //  functions may be used. Still, these have not been included as defaults, 
    //  which authorizes a more aware choice of the parameters.
    //
    //  Some sequences are limited in the maximum number of dimensions, 
    //  because they use internally fixed tables of parameters (e.g. the Sobol 
    //  sequence).
    //  Some other sequences can be extended with the <literal>"-primeslist"</literal> option.
    //  The <literal>"-primeslist"</literal> option can be configure with a table of 
    //  primes computed with the <literal>number_primes100()</literal>, <literal>number_primes1000()</literal>
    //  or <literal>number_primes10000()</literal> functions. The maximum dimension 
    //  which can be attained with these tables depends on the sequence.
    //  See the specific settings of each sequence below for detail.
    //
    // Examples
    //   lds = lowdisc_new("faure");
    //   lds = lowdisc_configure(lds,"-dimension",3);
    //   method = lowdisc_cget(lds,"-method")
    //   nbdim = lowdisc_cget(lds,"-dimension")
    //   i = lowdisc_get(lds,"-index")
    //   verbose = lowdisc_cget(lds,"-verbose")
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    // // See a Scrambled Halton sequence.
    // lds = lowdisc_new("halton");
    // lds = lowdisc_configure(lds,"-dimension",44);
    // lds = lowdisc_configure(lds,"-scrambling","RR2");
    // [lds,u] = lowdisc_next (lds,500);
    // lds = lowdisc_destroy(lds);
    // scf();
    // plot(u(:,43),u(:,44),"b.");
    //
    // Authors
    //   Copyright (C) 2013 - 2014 - Michael Baudin
    //   Copyright (C) 2008 - 2009 - INRIA - Michael Baudin
    //   Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
    //
    // Bibliography
    // [1] Kocis, L., and W. J. Whiten. "Computational Investigations of Low-Discrepancy Sequences." ACM Transactions on Mathematical Software. Vol. 23, No. 2, 1997, pp. 266–294.
    // [2] B. Vandewoestyne and R. Cools, "Good permutations for deterministic scrambled Halton sequences in terms of L2-discrepancy", Computational and Applied Mathematics 189, 2006.

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_configure" , rhs , 3:3 )
    apifun_checklhs ( "lowdisc_configure" , lhs , 1 )
    //
    apifun_checktype ( "lowdisc_configure" , this , "this" , 1 , "LOWDISC" )
    apifun_checktype ( "lowdisc_configure" , key , "key" , 2 , "string" )
    apifun_checkscalar ( "lowdisc_configure" , key , "key" , 2 )
    //
    select this.method
    case "niederreiter" then
        this.sequence     = ldniedf_configure ( this.sequence , key , value )
    case "sobol" then
        this.sequence     = ldsobolf_configure ( this.sequence , key , value )
    case "faure" then
        this.sequence     = ldfauref_configure ( this.sequence , key , value )
    case "halton" then
        this.sequence     = ldhaltonf_configure ( this.sequence , key , value )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_configure" , this.method);
        error(errmsg);
    end
endfunction

function this = ldhaltonf_configure (this,key,value)

    select key
    case "-primeslist" then
        apifun_checktype ( "ldhaltonf_configure" , value , "value" , 3 , "constant" )
        apifun_checkvector ( "ldhaltonf_configure" , value , "value" , 3 )
        apifun_checkflint ( "ldhaltonf_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldhaltonf_configure" , value , "value" , 3 , 1 )
        this.primeslist = value(:)';
        this.primessize = size(value,"*");
    case "-scrambling" then
        apifun_checktype ( "ldhaltonf_configure" , value , "value" , 3 , "string" )
        apifun_checkscalar ( "ldhaltonf_configure" , value , "value" , 3 )
        apifun_checkoption ( "ldhaltonf_configure" , value , "value" , 3 , ["" "RR2" "Reverse"])
        this.scrambling = value
    else
        // Delegate to ldbase
        this.baseobj = ldbase_configure ( this.baseobj , key ,value )
    end
endfunction

function this = ldniedf_configure (this,key,value)

    select key
    case "-base" then
        apifun_checktype ( "ldniedf_configure" , value , "value" , 3 , "constant" )
        apifun_checkscalar ( "ldniedf_configure" , value , "value" , 3 )
        apifun_checkflint ( "ldniedf_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldniedf_configure" , value , "value" , 3 , 1 )
        this.base = value;
    else
        // Delegate to ldbase
        this.baseobj = ldbase_configure ( this.baseobj , key ,value )
    end
endfunction

function this = ldfauref_configure (this,key,value)

    select key
    case "-primeslist" then
        apifun_checktype ( "ldfauref_configure" , value , "value" , 3 , "constant" )
        apifun_checkvector ( "ldfauref_configure" , value , "value" , 3 )
        apifun_checkflint ( "ldfauref_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldfauref_configure" , value , "value" , 3 , 1 )
        this.primeslist = value(:)';
        this.primessize = size(value,"*");
    else
        // Delegate to ldbase
        this.baseobj = ldbase_configure ( this.baseobj , key ,value )
    end
endfunction

function this = ldsobolf_configure (this,key,value)
    select key
    case "-scrambling" then
        apifun_checktype ( "ldsobolf_configure" , value , "value" , 3 , "string" )
        apifun_checkscalar ( "ldsobolf_configure" , value , "value" , 3 )
        apifun_checkoption ( "ldsobolf_configure" , value , "value" , 3 , ["" "Owen" "Faure-Tezuka" "Owen-Faure-Tezuka"])
        select value
        case ""
            dimmax = 1111
        else
            dimmax = 40
        end
        this.dimmax=dimmax
        this.scrambling = value
    case "-seeds" then
        apifun_checktype ( "ldsobolf_configure" , value , "value" , 3 , "constant" )
        apifun_checkvector ( "ldsobolf_configure" , value , "value" , 3 ,24)
        apifun_checkrange ( "ldsobolf_configure" , value , "value" , 3,0,1)
        this.seeds = value
    else
        // Delegate to ldbase
        this.baseobj = ldbase_configure ( this.baseobj , key ,value )
    end
endfunction

function this = ldbase_configure (this,key,value)

    [lhs, rhs] = argn()
    apifun_checkrhs ( "ldbase_configure" , rhs , 3:3 )
    apifun_checklhs ( "ldbase_configure" , lhs , 1 )
    //
    apifun_checktype ( "ldbase_configure" , this , "this" , 1 , "LDBASE" )
    apifun_checktype ( "ldbase_configure" , key , "key" , 2 , "string" )
    apifun_checkscalar ( "ldbase_configure" , key , "key" , 2 )
    //
    select key
    case "-verbose" then
        apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "boolean" )
        apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
        this.verbose = value
    case "-dimension" then
        apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
        apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 1 )
        this.dimension = value
    case "-skip" then
        apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
        apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 0 )
        this.skip = value;
    case "-leap" then
        apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
        apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
        apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 0 )
        this.leap = value;
    case "-coordinate" then
        apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "boolean" )
        apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
        this.coordinate = value
    else
        errmsg = msprintf ( gettext ( "%s: Unknown key %s" ) , "ldbase_configure" , key)
        error(errmsg)
    end
endfunction
