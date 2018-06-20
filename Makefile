# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR = .
DOCS = $(DIR)/docs
J = $(DOCS)/journals
R = $(DOCS)/reports
P = $(DOCS)/presentations
FIGS = $(DIR)/figures
DATA = $(DIR)/data
PROCESSED = $(DATA)/processed


# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:   $(J)/journal.pdf 
		-rm $(wildcard ./docs/*/tex2pdf*) -fr

  
# top level dependencies ######################################################
# make file .dot
$(PROCESSED)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/functions/makefile2dot.py < $< > $@

# make chart from .dot
$(FIGS)/make.png : $(PROCESSED)/make.dot
	Rscript -e "require(DiagrammeR); require(DiagrammeRsvg); require(rsvg); png::writePNG(rsvg(charToRaw(export_svg(grViz('$<')))), '$@')"


# journal (with graph) render to  pdf
$(J)/journal.pdf:  $(J)/journal.Rmd $(FIGS)/make.png
	$(KNIT-PDF)
