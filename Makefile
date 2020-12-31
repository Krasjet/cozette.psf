include config.mk

UNI1    = $(B2P_DIR)/fontsets/Uni1.512
ASCII   = $(B2P_DIR)/ascii.set
LINUX   = $(B2P_DIR)/linux.set
USEFUL  = $(B2P_DIR)/useful.set
SYMBOLS_DEF = $(UNI1)+:$(ASCII)+:$(LINUX)+:$(USEFUL)
EQUIV_DEF   = $(B2P_DIR)/standard.equivalents

TMP = \
	cozette.bdf   \
	cozette2x.bdf \
	cozette.set

OUT = \
	cozette.psf   \
	cozette2x.psf

all: $(OUT)

custom: custom.set custom.equivalents

custom.set: cozette.set
	cp cozette.set $@

custom.equivalents: $(EQUIV_DEF)
	cp $(EQUIV_DEF) $@

cozette.bdf:
	curl -O -L $(COZETTE_URL)
	patch -p1 < ./fixspace.patch

cozette2x.bdf: cozette.bdf
	bdfresize -f2 cozette.bdf > $@

.SUFFIXES: .bdf .psf .set
.bdf.psf:
	./mkpsf $(EQUIV_DEF) $(SYMBOLS_DEF) $< $@

.bdf.set:
	./bdfdump $< > $@

install: cozette.psf cozette2x.psf
	install -d $(PSFDIR)/
	gzip < cozette.psf > $(DESTDIR)$(PSFDIR)/cozette.psf.gz
	gzip < cozette2x.psf > $(DESTDIR)$(PSFDIR)/cozette2x.psf.gz

uninstall:
	rm -f $(PSFDIR)/cozette.psf.gz $(PSFDIR)/cozette2x.psf.gz

clean:
	rm -f $(TMP)

nuke: clean
	rm -f $(OUT) custom.set custom.equivalents

.PHONY: clean nuke install all custom install uninstall
