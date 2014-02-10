#!/bin/sh
#
# md5checker.sh
#
#
# This function is a substitution of md5sum -c for OS which couldn't have md5sum
#
#
# Copyright (c) 2011, Joris Berthelot
# Joris Berthelot <admin@eexit.net>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

VERSION=1.00
DATE=2011-12-10
QUIET=false

while getopts ":qhv" OPT; do
    case $OPT in
        q)
            QUIET=true
            ;;
        v)
            echo "md5checker -- v$VERSION -- $DATE"
            exit 0
            ;;
        h)
            echo "\t\t\tmd5checker -- v$VERSION"
            echo
            echo "SYNOPSIS"
            echo "\tmd5checker [-q] source_file"
            echo "\tmd5checker [-v] [-h]"
            echo
            echo "DESCRIPTION"
            echo "\tReads MD5 (128-bits) checksums in the file and compare them to the files"
            echo
            echo "\t-q"
            echo "\t\tQuiet mode. Don't print OK messages or warnings messages"
            echo
            echo "\t-h"
            echo "\t\tDisplays this help and exits"
            echo
            echo "\t-v"
            echo "\t\tOutputs the version information and exits"
            echo
            echo "AUTHOR"
            echo "\tWritten by Joris Berthelot <admin@eexit.net>"
            echo "\thttp//www.eexit.net/projects/md5checker.html"
            echo
            echo "COPYRIGHT"
            cat << EOT
        Copyright (c) 2011, Joris Berthelot
        
        Permission is hereby granted, free of charge, to any person obtaining a copy of
        this software and associated documentation files (the "Software"), to deal in
        the Software without restriction, including without limitation the rights to
        use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
        of the Software, and to permit persons to whom the Software is furnished to do
        so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        
        http://www.opensource.org/licenses/mit-license.php MIT License
EOT
            echo
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo
            echo "SYNOPSIS"
            echo "\tmd5checker [-q] source_file"
            echo "\tmd5checker [-v] [-h]"
            exit 0
            ;;
    esac
done

# Loops on each args
for ARG in $*; do
    
    # Checkes arg filename existence
    if [ ! -e "$ARG" ]; then
        if [[ "-q" != "$ARG" ]]; then
            echo "md5checker: "$ARG": No such filename"
        fi
        continue
    fi
    
    # Checkes if file content has at least one checksum pattern
    if [ 0 -eq "$(grep -csxP "^\w{32}\s(\s|\*).+$" "$ARG")" ]; then
        if ! $QUIET ; then
            echo "[  \033[0;33m!!\033[0m  ] "$ARG": No valid MD5 checksum entry found"
        fi
        continue
    fi
    
    # Loops on file lines
    while read LINE; do
        
        # Checkes if the current line has a checksum pattern
        if [[ $(echo "$LINE" | grep -sxP "^\w{32}\s(\s|\*).+$") ]]; then
            
            # Gets the file name of the line
            CFILE=$(echo "$LINE" | cut -c 35-)
            
            # If the file does not exist
            if [ ! -e "$CFILE" ]; then
                # If verbose output
                if ! $QUIET ; then
                    echo "[  \033[0;33m!!\033[0m  ] "$CFILE": File is missing"
                fi
                continue
            fi
            
            # Checkes if the MD5 sum of the file is the expected one
            if [[ "$LINE" == $(openssl dgst -md5 -r "$CFILE") ]]; then
                # If verbose output
                if ! $QUIET ; then
                    echo "[  \033[0;32mOK\033[0m  ] "$CFILE""
                fi
            else # File checksum failed
                echo "[\033[0;31mFAILED\033[0m] "$CFILE""
            fi
            
        fi
    done < $ARG
done
exit 0
