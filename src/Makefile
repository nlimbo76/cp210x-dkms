obj-m = cp210x.o

KERNEL_UNAME ?= $(shell uname -r)
KERNEL_MODLIB := /lib/modules/$(KERNEL_UNAME)
KDIR := $(shell test -d $(KERNEL_MODLIB)/source && echo $(KERNEL_MODLIB)/source || echo $(KERNEL_MODLIB)/build)

# SRCDIR = $(PWD)
# try this instead if you don't have PWD defined
# SRCDIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
