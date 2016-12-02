TARGET=GPIMAKEMAKE

all: $(patsubst %.md,%.pdf,$(wildcard *.md))

# Generalized rule: how to build a .pdf from each .md
%.pdf: %.md template.tex
	pandoc --template template.tex -f markdown+tex_math_single_backslash -t latex --latex-engine=xelatex -o $@ $<

# Generalized rule: how to build a .tex from each .md
%.tex: %.md
	pandoc --standalone --template template.tex -f markdown+tex_math_single_backslash -t latex -o $@ $<

touch:
	touch *.md

again: touch all

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.toc *.vrb || true

veryclean: clean
	rm -f *.pdf

view: $(TARGET).pdf
	if [ "Darwin" = "$(shell uname)" ]; then open $(TARGET).pdf ; else evince $(TARGET).pdf ; fi

submit: $(TARGET).pdf
	cp $(TARGET).pdf ../

print: $(TARGET).pdf
	lpr $(TARGET).pdf

.PHONY: all again touch clean veryclean view print
