#!/bin/bash
#

# Get book name and language
bookName=`cat .mkbok.yml | grep name | cut -d':' -f2 | tr -d ' '`
bookLang=`cat .mkbok.yml | grep lang: | cut -d':' -f2 | tr -d ' '`

# Clean the temp files of latex in latex/zh/
./mkclean

# Convert markdowns to pdf
./mkbok
[ $? -ne 0 ] && echo "ERR: Convert failed with ./mkbok" && exit 1

# Read it
evince ${bookName}.${bookLang}.pdf 
