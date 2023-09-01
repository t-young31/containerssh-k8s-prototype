#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

function tf_output(){
    cd $script_dir/aws && terraform output -raw "$1"
}

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rsync -vPr \
    --include=".env" \
    --exclude=".*" \
    --exclude="*.tfstate*" \
    -e "ssh $(tf_output ssh_args)" \
    . "$(tf_output ssh_host):~"
