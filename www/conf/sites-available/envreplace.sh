#!/bin/bash

# https://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for file in $DIR/*.conf.var; do
    # we only replace occurances of the variables specified below as first argument
    envsubst '$BOILERPLATE_DOMAIN' < $file > $DIR/`basename $file .var`
done

cp $DIR/*.conf $DIR/../sites-enabled