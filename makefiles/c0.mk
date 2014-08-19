SOURCES=GPIMAKEMAKE_SOURCE
TARGET=GPIMAKEMAKE_TARGET

# add libraries here
C0FLAGS=

all: nodebug $(TARGET)

$(TARGET): $(SOURCES)
	cc0 $(C0FLAGS) $(SOURCES) -o $(TARGET)

# add runtime checking and leave intermediate files for debugging reference
debug: C0FLAGS+= -d -s
debug: yesdebug $(TARGET)

# nasty hack to figure out whether the program was built with debugging...

yesdebug:
	[[ -e .debug ]] || (touch .debug; make veryclean)

nodebug:
	[[ ! -e .debug ]] || (rm .debug; make veryclean)

run: $(TARGET)
	./$(TARGET)

%.c0:

clean:
	find . -name '*.c0.c' -exec rm {} \;
	find . -name '*.c0.h' -exec rm {} \;

veryclean: clean
	-rm $(TARGET)

.PHONY: all debug yesdebug nodebug run clean veryclean
