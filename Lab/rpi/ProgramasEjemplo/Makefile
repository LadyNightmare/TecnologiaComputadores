CFLAGS = -g
LDFLAGS = -g
LDLIBS = -lwiringPi

SRCS  = $(wildcard *.s)
EXES = $(SRCS:.s=) 

.PHONY: clean
all: $(EXES)

clean:
	-rm -fv $(EXES)
