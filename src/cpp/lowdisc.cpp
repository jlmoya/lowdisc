// Copyright (C) 2009-2010 - Digiteo - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include <ctime>
#include <sstream>
#include <fstream>

using namespace std;

#include "lowdisc.h"
#include "lowdisc_shared.h"

//****************************************************************************80
// Set the error function
void lowdisc_errorsetfunction ( void (* f)(char * message) ) {
	lowdisc_errorfunction = f;
}
//****************************************************************************80
// Set the message function
void lowdisc_msgsetfunction ( void (* f)(char * message) ) {
	lowdisc_messagefunction = f;
}


