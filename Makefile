# Copyright (C) 1995-2009, by Peter I. Corke
#
# This file is part of The Machine Vision Toolbox for Matlab (MVTB).
# 
# MVTB is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# MVTB is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Leser General Public License
# along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


DISTDIR = vision2

distrib: doc/vision.pdf
	/bin/rm -rf $(DISTDIR) vision.tar.* vision.zip
	- mkdir $(DISTDIR)
	-cp doc/vision.pdf $(DISTDIR)
	-cp README $(DISTDIR)
	-cp RELEASE $(DISTDIR)
	-cp doc/CITATION $(DISTDIR)
	-cp -r `cat FILES` $(DISTDIR)
	-cp makefile-mex $(DISTDIR)/Makefile
	chmod -R a+r $(DISTDIR)
	tar cvf vision.tar ./$(DISTDIR)
	gzip -f vision.tar
	zip vision ./$(DISTDIR)/*

install:
	scp vision.tar.gz vision.zip doc/vision.pdf bob:tmp
	
doc/vision.pdf:	doc/ref.tex
	cd doc; $(MAKE)

mex:
	mex iwindow.c
	mex ivar.c
	mex imorph.c
	mex irank.c
	mex fhist.c
	mex ilabel.c
	mex imatch.c
	mex firewire.c -ldc1394_control -lraw1394

.c.${EXT}:
	cmex $<

clean:
	/bin/rm *.mex*

