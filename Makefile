


PACKAGE=cp210x
PACK_FOR_DKMS=$(PACKAGE)-dkms
VERSION=3.0~nl5

PACKAGE_FULL_NAME=$(PACK_FOR_DKMS)_$(VERSION)

#WORKDIR=$(PACK_FOR_DKMS)/$(PACKAGE)-$(VERSION)
WORKDIR=$(shell pwd)/build/

SOURCES= cp210x.c \
		 Makefile

DKMS_FILES= common.postinst


prepare:
	mkdir -p $(WORKDIR)/src; \
		for f in $(addprefix src/,$(SOURCES)); do cp $$f $(WORKDIR)/src/; done; \
		cp -a debian $(WORKDIR)/;
	@echo -e "-> Have to update \e[41mdebian/changlog\e[0m................"

mk_debpackage_for_test: prepare
	cd $(WORKDIR); \
		dpkg-buildpackage -us -uc

# *_source.(build | buildinfo | changes)
mk_srcpackage: prepare
	cd $(WORKDIR); \
		debuild -S -sa

ppa_upload:
	dput ppa:nlimbo76/ppa $(PACKAGE_FULL_NAME)_source.changes


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

