#!/bin/bash
#
# release.sh -- Release the book with a cover image specified in .mkbok.yml
#


# Get book name and language
bookName=`cat .mkbok.yml | grep name | cut -d':' -f2 | tr -d ' '`
bookLang=`cat .mkbok.yml | grep lang: | cut -d':' -f2 | tr -d ' '`
bookCover=`cat .mkbok.yml | grep cover: | cut -d':' -f2 | tr -d ' '`
pdf_merger=./pdf-merge.py

# To update the version, please write version
bookVersion=`cat version`

# Clean the temp files of latex in latex/zh/
./mkclean

# Convert makrdowns to pdf
./mkbok
[ $? -ne 0 ] && echo "ERR: Convert failed with ./mkbok" && exit 1

# Generate the cover pdf page from cover picture
convert -page A4 $bookCover -gravity center -format pdf pdf/cover.pdf

# Insert the cover page
bookInput=pdf/${bookName}.${bookLang}.pdf
bookOutput=pdf/${bookName}.${bookLang}.book.${bookVersion}.pdf

# Update the bookmarks with the right page offsets
chmod a+x $pdf_merger
$pdf_merger pdf/cover.pdf $bookInput --output $bookOutput 

echo
echo "release:"
echo
echo -e "\tpdf/${bookName}.${bookLang}.pdf --> pdf/${bookName}.${bookLang}.book.${bookVersion}.pdf"
