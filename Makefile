
MY_CFLAGS= $(shell pkg-config --cflags ao)
MY_LDFLAGS= $(shell pkg-config --libs ao)
ifeq ($(shell uname),FreeBSD)
MY_LDFLAGS+= -lssl
else
MY_CFLAGS+= $(shell pkg-config --cflags openssl)
MY_LDFLAGS+= $(shell pkg-config --libs openssl)
endif

CFLAGS:=-O2 -Wall $(MY_CFLAGS)
LDFLAGS:=-lm -lpthread $(MY_LDFLAGS)

OBJS=http.o alac.o hairtunes.o
all: shairport_helper

shairport_helper: hairtunes.c alac.o http.o
	$(CC) $(CFLAGS) -DHAIRTUNES_STANDALONE hairtunes.c alac.o http.o -o $@ $(LDFLAGS)

clean:
	-@rm -rf shairport_helper $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


prefix=/usr/local
install: shairport_helper
	install -D -m 0755 shairport_helper $(DESTDIR)$(prefix)/bin/shairport_helper

.PHONY: all clean install

.SILENT: clean

