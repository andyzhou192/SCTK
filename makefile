#########   Main Makefile for the sctk  #############


####  Creation Date:  Aug 7, 1997
#
# version: 0.3
# 2006-02-20 jerome
#  [/] make check, will output the uname
#
# version: 0.2
# 2006-01-11 jerome
#  [/] casper to gaston for CVS
 
MAKE=make

all clean install config:
	(mkdir -p bin)
	(cd src; $(MAKE) $@)

distclean:
	(rm -f bin/*)
	(cd src; $(MAKE) $@)

dist:
	@ echo "Make the distribution"
	@ echo "sctk-"`grep Version: readme.txt | head -1 | perl -pe 's/.*Version:\s+//; s/\s+\$$//; s/\s+/_/g'` > .fname	
	@ echo "Building a release version" `cat .fname`
	@ echo "Verifying and up-to-date CVS copy"
	@ cvs -d gaston:/home/sware/cvs up 
	@ cvs -d gaston:/home/sware/cvs co -d `cat .fname` sctk
	@ echo "Building the TAR file"
	@ echo `cat .fname`"-"`date +%Y%m%d-%H%M`.tar.bz2 > .distname
	@ tar jcf `cat .distname` --exclude CVS  --exclude .svn `cat .fname` 
	@ (cd `cat .fname`; make config all check)
	@ rm -rf `cat .fname` .fname .distname

cvs-tag-current-distribution:
	@ echo "Tagging the current CVS for distribution '"`grep Version: readme.txt | head -1 | perl -pe 's/.*Version:\s+/release-/; s/\s+\$$//; s/\s+/_/g; s/\./-/g'`"'"
	@ cvs -d gaston:/home/sware/cvs tag `grep Version: readme.txt | head -1 | perl -pe 's/.*Version:\s+/release-/; s/\s+\$$//; s/\s+/_/g; s/\./-/g'`

check:
	@ uname -a
	(cd src; $(MAKE) $@)
