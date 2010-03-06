
pkgdatadir=$(datadir)/eterbuild

all: QuickHelp.txt QuickHelp.utf8.txt
	$(MAKE) -C po

QuickHelp.utf8.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; $$i -h ; done | grep -v "^Note:" | grep -v "^Target" >$@

QuickHelp.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; LANG=C $$i -h ; done | grep -v "^Note:" | grep -v "^Target" >$@

install: 
	$(MAKE) -C po install
	mkdir -p $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(sysconfdir)/rpm
	mkdir -p $(DESTDIR)$(sysconfdir)/eterbuild/apt
	mkdir -p $(DESTDIR)$(sysconfdir)/eterbuild/repos
	mkdir -p $(DESTDIR)$(sysconfdir)/bashrc.d/
	mkdir -p $(DESTDIR)$(pkgdatadir)/functions/
	mkdir -p $(DESTDIR)$(pkgdatadir)/pkgrepl $(DESTDIR)$(pkgdatadir)/grprepl/
	install -m 755 bin/* $(DESTDIR)$(bindir)
	install -m 644 etc/apt/* $(DESTDIR)$(sysconfdir)/eterbuild/apt/
	install -m 644 etc/rpm/* $(DESTDIR)$(sysconfdir)/rpm/
	install -m 644 etc/config $(DESTDIR)$(sysconfdir)/eterbuild/
	install -m 644 etc/repos/* $(DESTDIR)$(sysconfdir)/eterbuild/repos/
	install -m 644 etc/bashrc.d/* $(DESTDIR)$(sysconfdir)/bashrc.d/
	install -m 644 share/eterbuild/pkgrepl/pkgrepl.* $(DESTDIR)$(pkgdatadir)/pkgrepl/
	install -m 644 share/eterbuild/grprepl/grprepl.* $(DESTDIR)$(pkgdatadir)/grprepl/
	install -m 644 share/eterbuild/eterbuild $(DESTDIR)$(pkgdatadir)/
	install -m 644 share/eterbuild/functions/* $(DESTDIR)$(pkgdatadir)/functions/
