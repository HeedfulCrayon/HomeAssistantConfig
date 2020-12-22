#!/bin/bash
args=$1
dir=$(git config -l)
generate_data()
{
    cat <<EOF
    {
        "args": ${args},
        "pwd": ${dir}
    }
EOF
}

echo "$(generate_data)" >| test.json