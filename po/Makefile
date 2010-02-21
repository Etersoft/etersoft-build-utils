MSGFMT = msgfmt -v
MSGMERGE = msgmerge
MSGMERGE_UPDATE = msgmerge --update
MSGINIT = msginit
MSGCONV = msgconv
MSGFILTER = msgfilter

SCRIPTLIST = ../share/eterbuild/functions/common \
	../share/eterbuild/functions/rpm ../share/eterbuild/functions/hasher ../share/eterbuild/functions/spec

all: etersoft-build-utils.mo
	

etersoft-build-utils.mo: etersoft-build-utils.po
	$(MSGFMT) -c -o t-$@ $< && mv t-$@ $@

etersoft-build-utils.pot: $(SCRIPTLIST) Makefile
	ls -1 -d ../bin/* | xargs xgettext -a -o $@ -L Shell --from-code=koi8-r $^ || :

etersoft-build-utils.po: etersoft-build-utils.pot
	$(MSGMERGE_UPDATE) $@ $<

install: etersoft-build-utils.mo
	install -D $< $(DESTDIR)$(datadir)/locale/ru/LC_MESSAGES/$<

clean:
	rm -f etersoft-build-utils.mo
