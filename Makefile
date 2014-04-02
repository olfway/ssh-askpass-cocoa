#!/usr/bin/make -f

ifeq ($(CC),)
  CC := cc
endif

ifeq ($(BINARY),)
  BINARY := ssh-askpass-cocoa
endif

all:
	$(CC) -framework Cocoa -o $(BINARY) ssh-askpass-cocoa.m

clean:
	-rm -f $(BINARY)

