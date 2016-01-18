#!/bin/bash

set -e

while getopts ":hd:" options
do
    case $options in
        d ) LDIR=$OPTARG ;;
        h ) echo "Usage: `basename $0` [OPTIONS] "
            echo "  -d  Fetch blobs from local directory"
            echo "  -h  Show this help"
            exit ;;
        * ) ;;
    esac
done

function extract() {
    for FILE in `egrep -v '(^#|^$)' $1`; do
        OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
        FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
        DEST=${PARSING_ARRAY[1]}
        if [ -z $DEST ]; then
            DEST=$FILE
        fi
        DIR=`dirname $DEST`
        if [ ! -d $2/$DIR ]; then
            mkdir -p $2/$DIR
        fi
        if [ -z $LDIR ]; then
            # Try CM target first
            adb pull /system/$DEST $2/$DEST
            # if file does not exist try OEM target
            if [ "$?" != "0" ]; then
                adb pull /system/$FILE $2/$DEST
            fi
        else
            # Try CM target first
            cp $LDIR/system/$DEST $2/$DEST
            # if file does not exist try OEM target
            if [ "$?" != "0" ]; then
                cp $LDIR/system/$FILE $2/$DEST
            fi
        fi
    done
}


BASE=../../../vendor/iuni/msm8974-common/proprietary
rm -rf $BASE/*

DEVBASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $DEVBASE/*

<<<<<<< HEAD
extract ../../oppo/msm8974-common/proprietary-files.txt $BASE
extract ../../oppo/msm8974-common/device-proprietary-files.txt $DEVBASE
=======
extract ../../iuni/msm8974-common/proprietary-files-qc.txt $BASE
extract ../../iuni/msm8974-common/proprietary-files.txt $DEVBASE
>>>>>>> b8a5e9eec8e0371269399d39a3aea4e3353a5bbf
extract ../../$VENDOR/$DEVICE/device-proprietary-files.txt $DEVBASE

./../../iuni/msm8974-common/setup-makefiles.sh
