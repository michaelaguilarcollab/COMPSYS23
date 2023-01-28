DOC_NAME=COMPSYS23

TEX_SECTIONS=\
introduction.tex \
related.tex \
abstract.tex \
methods.tex \
results.tex \
discussion.tex \
experimental-design.tex \
conclusion.tex \
#00-Introduction.tex \
#01-RelatedWork.tex \
#02-Motivation \
#03-Approach.tex \
#04-Performance.tex \
#conclusion.tex \
#hplior.tex \
#pf3d.tex \
#lessons.tex \
#results.tex

#SVG_FIGURES=\
#	svg/ldms.svg \
#	svg/cdsl2.svg \

#PNG_FIGURES=\
#	png/Fuego64.png \
#	$(SVG_FIGURES:svg/%.svg=png/%.png)

FIGURES=\
	$(PNG_FIGURES) \
        multinode-hpl-runtime-impact.pdf \
	multinode-95ci-lustre-beeond.pdf

# NOTE: manually doing the gnuplot files

all: $(DOC_NAME).pdf

$(DOC_NAME).pdf: $(DOC_NAME).tex $(TEX_SECTIONS) $(FIGURES) $(DOC_NAME).bbl
	pdflatex $(DOC_NAME)
	pdflatex $(DOC_NAME)
	-@(grep Reference $(DOC_NAME).log ; exit 0)
	-@(grep Citation $(DOC_NAME).log ; exit 0)


$(DOC_NAME).bbl: $(DOC_NAME).bib
	pdflatex $(DOC_NAME)
	pdflatex $(DOC_NAME)
	bibtex $(DOC_NAME)
	pdflatex $(DOC_NAME)

png/%.png: svg/%.svg png
	inkscape --export-png=$@ -D -d 400 --export-background=ffffffff $<

png:
	mkdir png

clean:
	rm -f $(DOC_NAME).pdf *~ *.bbl *.blg *.toc *.ilg \
	*.ind *.idx *.lof *.log *.lot *.aux *.out *.tpt

.PHONY: spellcheckaspell
spellcheckaspell:
	find . -name "*.tex" -type f -exec /usr/bin/aspell -c '{}' --lang=en_US --mode=tex \;

.PHONY: spellcheckhunspell
spellcheckhunspell:
	find . -name "*.tex" -type f -exec /usr/bin/hunspell -t -d en_US '{}' \;

.PHONY: latexmk
latexmk:
	latexmk -pdf beegfs_on_stria_initial_integration_and_experiments

.PHONY: latexmk_clean
latexmk_clean:
	latexmk -C
