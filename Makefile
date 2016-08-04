DOCNAME = gps-cheatsheet
DEPS_DIR = .deps
LATEXMK = latexmk -recorder -use-make -deps -interaction=nonstopmode \
	-e 'warn qq(In Makefile, turn off custom dependencies\n);' \
	-e '@cus_dep_list = ();' \
	-e 'show_cus_dep();'

.PHONY: clean realclean

all: pdf
	@echo
	@echo "    ===== SUMMARY ====="
	@echo
	@ls -1ks $(DOCNAME).pdf | awk '{printf "%6dk %s\n", $$1, $$2}'

pdf: $(DOCNAME).pdf

# This pulls in latex-generated dependencies
$(foreach file,$(TARGETS),$(eval -include $(DEPS_DIR)/$(file)P))

%.pdf: %.tex
	@mkdir -p $(DEPS_DIR)
	$(LATEXMK) -pdf -ps- -dvi- -deps-out=$(DEPS_DIR)/$@P $<

fontsetup:
	autoinst -target=`kpsexpand '$$TEXMFLOCAL'` $(FONTLIST)
	sudo mktexlsr
	sudo updmap-sys

clean:
	latexmk -c
	rm -f *.upa *.upb pdfx.xmpi
	rm -f $(DOCNAME).pdf

print-%: ;@echo $*=$($*)
