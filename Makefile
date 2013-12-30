# Makefile for open source book

# Get configs
bookCfg := config/basic.yml
bookName := $(shell cat $(bookCfg) | grep name | cut -d':' -f2 | tr -d ' ')
bookLang := $(shell cat $(bookCfg) | grep lang: | cut -d':' -f2 | tr -d ' ')
bookCover:= $(shell cat $(bookCfg) | grep cover: | cut -d':' -f2 | tr -d ' ')
outDir   := pdf

short_fileName := $(bookName).$(bookLang).pdf

# tools
make_pdf := tools/makepdf
pdfmerger:= tools/pdf-merge.py
convert  := convert

# Cover pdf
cover_pdf:= $(outDir)/cover.pdf

# Get release version
bookVersion := $(shell cat version)
long_fileName := $(bookName).$(bookLang).book.$(bookVersion).pdf

# pdf versions
bookInput  := $(outDir)/$(short_fileName)
bookOutput := $(outDir)/$(long_fileName)

# build targets
all: clean
	@$(make_pdf)

read:
	evince $(bookInput)

read-full:
	evince $(bookOutput)

release: clean
	@echo -e "\t*Step1: Build pdf with $(make_pdf)"
	@$(make_pdf) 2>&1 > /dev/null
	@echo -e "\t      : $(bookInput)"
	@echo ""
	@echo -e "\t*Step2: Convert png to pdf with $(convert)"
	@$(convert) -page A4 $(bookCover) -gravity center -format pdf $(cover_pdf)
	@echo -e "\t      : $(cover_pdf)"
	@echo ""
	@echo -e "\t*Step3: Convert from $(cover_pdf), $(bookInput) to $(bookOutput) ..."
	@$(pdfmerger) $(cover_pdf) $(bookInput) --output $(bookOutput) 2>&1 > /dev/null
	@echo -e "\t      : $(outDir)/${bookName}.${bookLang}.book.${bookVersion}.pdf"

clean:
	@rm -rf latex/zh/*

distclean: clean
	@rm -rf pdf/*
