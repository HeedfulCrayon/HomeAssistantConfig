#!/bin/bash
args=("$@")
# files_to_delete=$(git status -s | awk '/^ D/{print "\"* "substr($0,4,length($0))"\","}') 
# files_to_modify=$(git status -s | awk '/^ M/{print "\"* "substr($0,4,length($0))"\","}') 
# files_to_add=$(git status -s | awk '/^\?/{print "\"* "substr($0,4,length($0))"\","}') 
files_to_delete=$(git status -s | awk '/^ D/{print "\""substr($0,4,length($0))"\","}') 
files_to_modify=$(git status -s | awk '/^ M/{print "\""substr($0,4,length($0))"\","}') 
files_to_add=$(git status -s | awk '/^\?/{print "\""substr($0,4,length($0))"\","}') 
delete_count=$(git status -s | awk '/^ D/{print "\""substr($0,4,length($0))"\","}' | wc -l)
modified_count=$(git status -s | awk '/^ M/{print "\""substr($0,4,length($0))"\","}' | wc -l)
added_count=$(git status -s | awk '/^\?/{print "\""substr($0,4,length($0))"\","}' | wc -l)

generate_post_data()
{
    cat <<EOF
{
    "delete_count": ${delete_count},
    "delete": {
        "delete":
        [
            ${files_to_delete%?}
        ]
    },
    "modify_count": ${modified_count},
    "modify": {
        "modify":
        [
            ${files_to_modify%?}
        ]
    },
    "add_count": ${added_count},
    "add": {
        "add":
        [
            ${files_to_add%?}
        ]
    }
}
EOF
}

echo "$(generate_post_data)" >| git_status.json

curl -X POST -H "Content-Type: application/json"  -d "$(generate_post_data)" ${args[0]}/api/webhook/git_status