


#PACKAGE=cp210x
#PACK_FOR_DKMS=$(PACKAGE)-dkms
#VERSION=$(shell sed -ns '/^PACKAGE_VERSION/ s/.*="\(.*\)"/\1/p' src/dkms.conf)
#PACKAGE_FULL_NAME=$(PACK_FOR_DKMS)_$(VERSION)
#WORKDIR=$(PACK_FOR_DKMS)/$(PACKAGE)-$(VERSION)

WORKDIR=$(shell pwd)/build/

SOURCES= cp210x.c \
		 Makefile

#DKMS_FILES= common.postinst

prepare:
	@rm -rf $(WORKDIR)/
	@mkdir -p $(WORKDIR)/src; \
		for f in $(addprefix src/,$(SOURCES)); do cp $$f $(WORKDIR)/src/; done; \
		cp -a debian $(WORKDIR)/;

_mk_debpackage_for_test: prepare
	cd $(WORKDIR); \
		dpkg-buildpackage -us -uc

# *_source.(build | buildinfo | changes)
mk_srcpackage: prepare
	cd $(WORKDIR); \
		debuild -S -sa

ppa_upload:
	@file=$(shell find . -maxdepth 1 -name '*_source.changes' | sort -r | head -n 1); \
		[ -f "$$file" ] && ( echo "Upload file : $$file"; echo dput ppa:nlimbo76/ppa $$file ) \
						|| echo "Can't found xxx_source.changes file"

fix_changelog:
	@echo -e ">> Have to update \e[41m debian/changlog \e[0m file................"
	@debchange --check-dirname-level 0 -q 


_all:
	make fix_changelog
	make prepare
	make mk_srcpackage

######################################################################333

dh-init_for_starting_pack: prepare
	cd $(WORKDIR); dh_make --createorig

dh-1: prepare
	cd $(WORKDIR); dh_make -f ../cp210x-dkms_3.0~nl2.tar.gz


__pgp_key:
	gpg --list-keys
	#gpg --full-gen-key
	#gpg --send-key --keyserver keyserver.ubuntu.com XXXXXXXXXX
	#gpg --fingerprint
	#gpg --import-key


######################################################################333

clean:
	cd $(WORKDIR); dh_clean

distclean:
	rm -rf $(WORKDIR)



#debmake
#debuild


#dkms build
#dkms mkdeb

