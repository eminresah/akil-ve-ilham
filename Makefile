# Makefile
# 
# Converts Markdown to other formats (HTML, PDF, DOCX, RTF, ODT, EPUB) using Pandoc
# <http://johnmacfarlane.net/pandoc/>
#
# Run "make" (or "make all") to convert to all other formats
#
# Run "make clean" to delete converted files

# Convert all files in this directory that have a .md suffix

SOURCE_DOCS := resources/metadata.yaml $(sort $(wildcard content/docs/[0-9]*.md))

EXPORTED_DOCS=\
 $(SOURCE_DOCS:.md=.html) \
 $(SOURCE_DOCS:.md=.epub) 

RM=/bin/rm

PANDOC=/usr/bin/pandoc

PANDOC_OPTIONS=--standalone

PANDOC_HTML_OPTIONS=--to html5
PANDOC_PDF_OPTIONS=--pdf-engine=xelatex
PANDOC_EPUB_OPTIONS=--to epub3


HUGO=/usr/bin/hugo
HUGO_OPTIONS=--theme=erbook --minify
HUGO_SERVER_OPTIONS=server --theme=erbook --minify

# Pattern-matching Rules

all: static/akil-ve-ilham.epub static/akil-ve-ilham.pdf site

server: 
	$(HUGO) $(HUGO_SERVER_OPTIONS)

static/akil-ve-ilham.html : $(SOURCE_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $(SOURCE_DOCS)

# %.html : %.md
# 		$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $<

static/akil-ve-ilham.epub : $(SOURCE_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $@ $(SOURCE_DOCS) 

# %.epub : %.md
# $(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $@ $<

static/akil-ve-ilham.pdf: $(SOURCE_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $(SOURCE_DOCS) 

site: 
	$(HUGO) $(HUGO_OPTIONS)
	
# Targets and dependencies

.PHONY: all clean site server

# all : $(EXPORTED_DOCS)

clean:
	$(RM) $(EXPORTED_DOCS) static/akil-ve-ilham.html static/akil-ve-ilham.epub static/akil-ve-ilham.pdf
