# Makefile
# 
# Converts Markdown to other formats (HTML, PDF, DOCX, RTF, ODT, EPUB) using Pandoc
# <http://johnmacfarlane.net/pandoc/>
#
# Run "make" (or "make all") to convert to all other formats
#
# Run "make clean" to delete converted files

# Convert all files in this directory that have a .md suffix

SOURCE_DOCS := $(sort $(wildcard content/docs/[0-9]*.md))
EPUB_DOCS := resources/metadata.yaml
PDF_DOCS := 

EXPORTED_DOCS=\
 $(SOURCE_DOCS:.md=.html) \
 $(SOURCE_DOCS:.md=.epub) 

RM=/bin/rm

AWS=/usr/bin/aws
AWS_CMD=s3 sync
AWS_SOURCE=public
AWS_TARGET=s3://kitap.eminresah.com/akil-ve-ilham


PANDOC=/usr/bin/pandoc

PANDOC_OPTIONS=--standalone -f markdown+smart

PANDOC_HTML_OPTIONS=--to html5
PANDOC_PDF_OPTIONS=--pdf-engine=xelatex
PANDOC_EPUB_OPTIONS=--to epub3


HUGO=/usr/bin/hugo
HUGO_OPTIONS=--theme=erbook --minify
HUGO_SERVER_OPTIONS=server --theme=erbook --minify

# Pattern-matching Rules

all: static/akil-ve-ilham.epub static/akil-ve-ilham.pdf site publish

server: 
	$(HUGO) $(HUGO_SERVER_OPTIONS)

static/akil-ve-ilham.html : $(SOURCE_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $(SOURCE_DOCS)

# %.html : %.md
# 		$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) -o $@ $<

static/akil-ve-ilham.epub : $(SOURCE_DOCS) $(EPUB_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $@ $(EPUB_DOCS) $(SOURCE_DOCS) 

# %.epub : %.md
# $(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_EPUB_OPTIONS) -o $@ $<

static/akil-ve-ilham.pdf: $(SOURCE_DOCS)
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_PDF_OPTIONS) -o $@ $(PDF_DOCS) $(SOURCE_DOCS) 

site: 
	$(HUGO) $(HUGO_OPTIONS)

publish:
	$(AWS) $(AWS_CMD) $(AWS_SOURCE) $(AWS_TARGET)
	
# Targets and dependencies

.PHONY: all clean site server

# all : $(EXPORTED_DOCS)

clean:
	$(RM) $(EXPORTED_DOCS) static/akil-ve-ilham.html static/akil-ve-ilham.epub static/akil-ve-ilham.pdf
