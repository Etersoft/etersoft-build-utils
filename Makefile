
all: QuickHelp.txt QuickHelp.koi8-r.txt
	$(MAKE) -C po

QuickHelp.koi8-r.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; $$i -h ; done | grep -v "^Note:" | grep -v "^Target" >$@

QuickHelp.txt:
	for i in bin/* ; do echo -e "\n\n---------------------------"; LANG=C $$i -h ; done | grep -v "^Note:" | grep -v "^Target" >$@

install: 
	$(MAKE) -C po install
	mkdir -p $(bindir) $(sysconfdir)/eterbuild/apt $(sysconfdir)/rpm
	mkdir -p $(datadir)/eterbuild/functions/
	mkdir -p $(datadir)/eterbuild/pkgrepl $(datadir)/eterbuild/grprepl/
	install -m 755 bin/* $(bindir)
	install -m 644 etc/apt/* $(sysconfdir)/eterbuild/apt/
	install -m 644 etc/rpm/* $(sysconfdir)/rpm/
	install -m 644 etc/config $(sysconfdir)/eterbuild/
	install -m 644 etc/repos $(sysconfdir)/eterbuild/
	#install -m 644 apt/apt.conf.* apt/sources.list.* %buildroot/%_sysconfdir/apt/
	install -m 644 share/eterbuild/pkgrepl/pkgrepl.* $(datadir)/eterbuild/pkgrepl/
	install -m 644 share/eterbuild/grprepl/grprepl.* $(datadir)/eterbuild/grprepl/
	install -m 644 share/eterbuild/eterbuild $(datadir)/eterbuild/
	install -m 644 share/eterbuild/functions/* $(datadir)/eterbuild/functions/
