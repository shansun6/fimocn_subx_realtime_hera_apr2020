iplib=  gausslat.o\
	gcdist.o\
	gdsawt.o\
	gdswiz00.o\
	gdswiz01.o\
	gdswiz03.o\
	gdswiz04.o\
	gdswiz05.o\
	gdswizc9.o\
	gdswizca.o\
	gdswizcb.o\
	gdswiz.o\
	gdswzd00.o\
	gdswzd01.o\
	gdswzd03.o\
	gdswzd04.o\
	gdswzd05.o\
	gdswzdc9.o\
	gdswzdca.o\
	gdswzdcb.o\
	gdswzd.o\
	ijkgds0.o\
	ijkgds1.o\
	ijkgds.o\
	ipmerge2.o\
	ipolates.o\
	ipolatev.o\
	ipsector.o\
	ipspaste.o\
	ipxetas.o\
	ipxwafs2.o\
	ipxwafs.o\
	makgds.o\
	movect.o\
	polateg0.o\
	polateg1.o\
	polateg4.o\
	polates0.o\
	polates1.o\
	polates2.o\
	polates3.o\
	polates4.o\
	polates6.o\
	polatev0.o\
	polatev1.o\
	polatev2.o\
	polatev3.o\
	polatev4.o\
	polatev6.o\
	polfixs.o\
	polfixv.o


iplib.a:	$(iplib)
	touch iplib.a
	rm iplib.a
	ar -rc iplib.a $(iplib)
#	rm *.o

.f.o:
	$(FC) -c $(FFLAGS) $<
