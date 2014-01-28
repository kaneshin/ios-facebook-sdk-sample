# File:         Makefile
# Maintainer:   Shintaro Kaneko <kaneshin0120@gmail.com>
# Last Change:  28-Jan-2014.

COCOAPODS = pod

all: install

# install
install:
	$(COCOAPODS)

# shell
shell:
	which $(SHELL)

clean:

purge:

