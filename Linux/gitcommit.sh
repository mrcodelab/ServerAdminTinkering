#!/bin/bash
####################################################
#A shorthand for publishing changes to git repos
####################################################

echo "please provide a commit comment."
read -p "" comment

gitpush(){
	git stage -A; git commit -am "$comment"; git push
}

gitpush
echo "git commit successful"
