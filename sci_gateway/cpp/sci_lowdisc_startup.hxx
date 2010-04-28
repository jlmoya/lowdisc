
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU Lesser General Public License license
// http://www.gnu.org/copyleft/lesser.html

//
// sci_lowdisc_startup.h
//   Header for sci_nisp_startup.cpp
//
#ifndef __SCI_LOWDISC_STARTUP_H__
#define __SCI_LOWDISC_STARTUP_H__

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

__BEGIN_DECLS

/**
 * sci_lowdisc_startup_flag:
 * = 0 if the library has never been started up yet.
 * = 1 if the library has already been started up.
 */
extern int sci_lowdisc_startup_flag;

__END_DECLS

#endif /* !__SCI_LOWDISC_STARTUP_H__ */