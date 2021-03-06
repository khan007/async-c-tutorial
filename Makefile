###############################################################################
##  SETTINGS                                                                 ##
###############################################################################

OS = $(shell uname)
ARCH = $(shell uname -m)
PLATFORM = $(OS)-$(ARCH)

CFLAGS = -std=gnu99 -g -Wall -fPIC -O3
CFLAGS += -fno-common -fno-strict-aliasing
CFLAGS += -march=nocona -DMARCH_$(ARCH)
CFLAGS += -D_FILE_OFFSET_BITS=64 -D_REENTRANT -D_GNU_SOURCE
CFLAGS += -DAS_USE_LIBEV -I/usr/local/include

ifeq ($(OS),Darwin)
  CFLAGS += -D_DARWIN_UNLIMITED_SELECT
else
  CFLAGS += -rdynamic
endif

LDFLAGS = -L/usr/local/lib -laerospike -lev -lssl -lcrypto -lpthread -lm -lz

ifneq ($(OS),Darwin)
  LDFLAGS += -lrt -ldl
endif

###############################################################################
##  OBJECTS                                                                  ##
###############################################################################

OBJECTS = async_tutorial.o

###############################################################################
##  MAIN TARGETS                                                             ##
###############################################################################

all: build

.PHONY: build
build: target/async_tutorial

.PHONY: clean
clean:
	@rm -rf target

target:
	mkdir $@

target/%.o: %.c | target
	cc $(CFLAGS) -o $@ -c $^

target/async_tutorial: $(addprefix target/,$(OBJECTS)) | target
	cc -o $@ $^ $(LDFLAGS)
