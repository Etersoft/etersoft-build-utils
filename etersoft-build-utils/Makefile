MSGFMT = msgfmt -v
MSGMERGE = msgmerge
MSGMERGE_UPDATE = msgmerge --update
MSGINIT = msginit
MSGCONV = msgconv
MSGFILTER = msgfilter

#.po.mo:
all: QuickHelp.txt QuickHelp.koi8-r.txt etersoft-build-utils.mo
	

po/etersoft-build-utils.mo: po/etersoft-build-utils.po
	$(MSGFMT) -c -o t-$@ $< && mv t-$@ $@

po/etersoft-build-utils.pot: Makefile share/common tools/upload-to-alt
	ls -1 -d bin/* | grep -v "CVS" | xargs xgettext -a -o $@ -L Shell --from-code=koi8-r share/commons tools/upload-to-alt || :
#	ls -1 -d bin/* etersoft-build-functions upload-to-alt | grep -v "CVS" | xargs grep echo | xgettext -a -o $@ -L Shell --from-code=koi8-r - || :

QuickHelp.koi8-r.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; $$i -h ; done >$@

QuickHelp.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; LANG=C $$i -h ; done >$@

po/etersoft-build-utils.po: po/etersoft-build-utils.pot
	$(MSGMERGE_UPDATE) $@ $<

install: po/etersoft-build-utils.mo
	install -D $< $(DESTDIR)/usr/share/locale/ru/LC_MESSAGES/$<
