#!/bin/bash
#
# release.sh -- Release the book
#


# Get book name and language
bookName=`cat .mkbok.yml | grep name | cut -d':' -f2 | tr -d ' '`
bookLang=`cat .mkbok.yml | grep lang: | cut -d':' -f2 | tr -d ' '`
bookCover=`cat .mkbok.yml | grep cover: | cut -d':' -f2 | tr -d ' '`

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
pdftk A=pdf/cover.pdf B=pdf/${bookName}.zh.pdf cat A B output pdf/${bookName}.zh.book.${bookVersion}.pdf

echo
echo "release:"
echo
echo -e "\tpdf/${bookName}.zh.pdf --> pdf/${bookName}.zh.book.${bookVersion}.pdf"
