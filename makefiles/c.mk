TARGET=GPIMAKEMAKE_TARGET
C=$(shell find . -name '*.c')
OBJS=$(patsubst %.c,%.o,$(C))
DEPS=$(patsubst %.c,%.dep,$(C))

CC=gcc
CPPFLAGS=-I include

all: nodebug $(TARGET)

debug: CFLAGS+= -g
debug: yesdebug $(TARGET)

# nasty hack to figure out whether the objects were built with -g...

yesdebug:
	[ -e .debug ] || (touch .debug; make clean)

nodebug:
	[ ! -e .debug ] || (rm .debug; make clean)

run: $(TARGET)
	./$(TARGET)

# implicit rule used for linking
$(TARGET): $(OBJS)
	gcc $(OBJS) -o $(TARGET)

# implicit rule used for compilation
$(OBJS): %.o: %.dep

# generate dependencies
$(DEPS): %.dep: %.c
	$(CC) $(CPPFLAGS) -M -MF $@ -MT '$@' $<

include $(DEPS)

clean:
	-rm $(OBJS)

veryclean: clean
	-rm $(DEPS) $(TARGET)

.PHONY: all debug yesdebug nodebug run clean veryclean
