
SHELL := /bin/sh
UNAME := $(shell uname)
.SUFFIXES:
.SUFFIXES: .pdf .tex .dvi

TEX := platex

TEX_FILE  := $(wildcard *.tex)
PDF_FILE  := $(patsubst %.tex, %.pdf, $(TEX_FILE))

COMPILE_CNT := 1

all: pdf

%.dvi: %.tex
	@for i in `seq 1 $(COMPILE_CNT)`; do \
		yes q | head | $(TEX) $<; \
	done
	@for i in `seq 1 3`; do \
		if grep -F 'Rerun to get cross-references right.' $(<:.tex=.log) || \
			grep -F 'Package rerunfilecheck Warning' $(<:.tex=.log); \
		then \
			yes q | head | $(TEX) $<; \
		else \
			exit 0; \
		fi; \
	done

%.pdf: %.dvi
	dvipdfmx -d5 $<

pdf: $(PDF_FILE)

clean:
	$(RM) *.{aux,log,dvi,fls}

distclean: clean
	$(RM) $(PDF_FILE)

rebuild re:
	touch $(TEX_FILE)
	$(MAKE) pdf
