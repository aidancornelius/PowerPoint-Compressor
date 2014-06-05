#!/bin/bash
args=("$@")
## (c) 2009, 2010, 2011, 2012, 2013, 2014 Department for Education and Child Development.
##
## Produced by Aidan Cornelius-Bell for DECD starting 20th May 2014.
##
## This script is entirely designed for UNIX BSD, SunOS / MacOS. 
## Expecting compatability with Linux is probably not a great idea, 
## something might break. Good luck and have fun.
##

# Some constants...
readonly SCRIPT_NAME="PPTXKey Compression Software " # Name it whatever
readonly SCRIPT_VERSION="v1.1"                       # Give it a version
readonly WORKING_DIRECTORY="./"                      # Why not relative?
readonly OPERATING_SYSTEM=$(uname -s 2>&1)

function RENAME_INPUT_FILE {
    cp ${args[0]} ./file.zip
    echo -e "Your input file will now have the extension .presentationbackup, remove it to restore your original.\n"
    mv ${args[0]} ${args[0]}.presentationbackup
    mkdir ./tmp
    return 1;
}

function UNZIP_INPUT_FILE {
    unzip ./file.zip -d ./tmp
    return 1;
}

function FIND_MEDIA_FILES {
    if [ -d "./tmp/ppt/media" ]; then
    chmod -R +rwx ./tmp/ppt
        for f in `find ./tmp/ppt/media -type f -regex ".*\mov"`; do
        echo ${f}
            if [ -f ${f} ]; then
                ./handbrake -i ${f} -o ${f}.tmp
                mv ${f}.tmp ${f}
            fi
        done
        for f in `find ./tmp/ppt/media -type f -regex ".*\mp4"`; do
            if [ -f ${f} ]; then
                ./handbrake -i ${f} -o ${f}.tmp
                mv ${f}.tmp ${f}
            fi
        done
        for f in `find ./tmp/ppt/media -type f -regex ".*\m4v"`; do
            if [ -f ${f} ]; then
                ./handbrake -i ${f} -o ${f}.tmp
                mv ${f}.tmp ${f}
            fi
        done
        for f in `find ./tmp/ppt/media -type f -regex ".*\avi"`; do
            if [ -f ${f} ]; then
                ./handbrake -i ${f} -o ${f}.tmp
                mv ${f}.tmp ${f}
            fi
        done
    fi
    
    return 1;
}

function PACKAGE_PRESENTATION_FILES {
    cd ./tmp
    zip -r ${args[0]}.zip *
    mv ${args[0]}.zip ../compressed_${args[0]}
    cd ..
    rm -r ./tmp
    rm file.zip
    rm ${args[0]}.zip
    return 1;
}

echo -e $SCRIPT_NAME $SCRIPT_VERSION "running on" $OPERATING_SYSTEM "with scissors."

echo -e "(c) 2009, 2010, 2011, 2012, 2013, 2014 Department for Education and Child Development.\n"

if [[ ${args[0]} ]] ; then
    cd /Applications/PPTXKey.app/Contents/Resources/
    echo -e "Copying and renaming input:\n"
    RENAME_INPUT_FILE
    echo -e "Unzipping copied file:\n"
    UNZIP_INPUT_FILE
    echo -e "Finding compatible media files and reencoding them:\n"
    FIND_MEDIA_FILES
    echo -e "Repackaging modified files... Rebuilding presentation as source:\n"
    PACKAGE_PRESENTATION_FILES
    echo -e "Completed."
else 
  echo -e "PPKey expects a PPTX or KEY file to continue. Unexpected input, or no input received."  
fi
