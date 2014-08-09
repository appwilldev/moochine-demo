#!/bin/bash
# utils functions and variables
# author: KDr2

if [[ $MOOCHINE_HOME = "" ]] || [[ $OPENRESTY_HOME = "" ]]; then
    source ~/.bashrc
fi

path_in_p(){
    if [[ $2 == $1 ]] || [[ $2 == *:$1 ]] || [[ $2 == $1:* ]] || [[ $2 == *:$1:* ]]; then
        export PATH_IN_P=1
        echo 1
    else
        export PATH_IN_P=0
        echo 0
    fi
}

APP_ROOT=`dirname $0`/..
APP_ROOT=$(realpath $APP_ROOT)
