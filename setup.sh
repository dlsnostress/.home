#!/bin/bash
#------------------------------------------------------------------------------
# Patch ~/.bashrc and install symlinks to configuration in ~ and subdirectories.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Line to insert into ~/.bashrc.

SOURCE=". ~/.home/.bashrc.source"
if ! grep "$SOURCE" ~/.bashrc >&/dev/null; then
    printf >> ~/.bashrc "\n$SOURCE\n"
    echo "Updated ~/.bashrc."
fi

#------------------------------------------------------------------------------
# Set up symlinks.

ESC_RED='\e[31;1m'
ESC_RST='\e[0m'
ESC_GRN='\e[32;1m'

cd $HOME/.home/links && find . -type f | while read LINK; do
    RELATIVE=${LINK#./}
    DIR=~/$(dirname "$RELATIVE")
    if [ ! -d "$DIR" ]; then
        mkdir $DIR && echo "Created directory $DIR" \
                   || echo -e "$ESC_REDFailed to create directory $DIR$ESC_RST"
    fi
    if [ -f "$HOME/$RELATIVE" -a ! -L "$HOME/$RELATIVE" ]; then
        echo -e "$ESC_RED\"~/$RELATIVE\" already exists as an ordinary file.$ESC_RST"
    else
        if [ ! -L "$HOME/$RELATIVE" ]; then
            echo -n "NEW      "
        else
            echo -n "UPDATED  "
        fi
        if ln -fs ~/".home/links/$RELATIVE" ~/"$RELATIVE" >&/dev/null; then
            echo -e "$ESC_GRN~/$RELATIVE  $ESC_RST--->  $ESC_GRN~/.home/link/$RELATIVE$ESC_RST"
        else
            echo -e "$ESC_REDFailed to update link ~/$RELATIVE$ESC_RST"
        fi
    fi
done
