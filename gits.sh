# Gits v1.0
# Clone GitHub repositories by name or owner/name
# http://github.com/srcoley/gits
# 
# by Stephen Coley | @coleydotco | http://coley.co
#
# License: MIT, Apache 2
#
# Accepts one parameter with two accepted formats.
# Format 1: gits <repo name> (Performs a search)
# Format 2: gits <repo owner>/<repo name>
#
# Providing the repository owner and name will result
# in a direct clone from github.com/<repo owner>/<repo name>.git.
#
# Providing only the repo name will perform a search at GitHub's
# https://api.github.com/legacy/repos/search API endpoint.
# The repo owner and name of the first result will be used to 
# clone directly from GitHub.
#
function gits() {
	if [[ $1 ]] # If an argument is supplied
	then
		if [[ $1 == */* ]] # If argument contains a "/"
		then
			echo "Cloning https://github.com/$1.git..."
			echo `gits_clone "$1"`
		else # Else
			if [[ -f ~/.gits/cache ]] # If cache file exists
			then
				cache=`grep -m 1 $1 ~/.gits/cache` # Search cache for argument
				if [[ $? -eq 0 ]] # If match
				then
					echo "Cloning https://github.com/$cache.git..."
					echo `gits "$cache"` # Run gits with repo_owner/repo_name formatted argument
				else # No match
					echo "Searching GitHub.com for top result..."
					repo=`gits_search "$1"`
					echo "Cloning https://github.com/$repo.git..."
					echo `gits_cache_and_clone "$repo"`
				fi
			else # Cache GitHub search result and clone repository
				echo "Searching GitHub.com for top result..."
				repo=`gits_search "$1"`
				echo "Cloning https://github.com/$repo.git..."
				echo `gits_cache_and_clone "$repo"`
			fi
		fi
	else # Else no argument is passed
		echo 'To clone a repository from GitHub, simply run gits <repo_name> or gits <repo_owner>/<repo_name>'
	fi
}

# If passed an argument, it will search GitHub for a matching
# repository and return a string formatted like so:
# <repository_owner>/<repository_name>
function gits_search() {
	if [[ $1 ]]
	then
		response=`curl -s https://api.github.com/legacy/repos/search/$1 | ~/.gits/JSON.sh`
		owner=`echo "$response" | egrep '\["repositories",0,"owner"\]' | awk '{split($0, array, "\"")} END{print array[6]}'`
		name=`echo "$response" | egrep '\["repositories",0,"name"\]' | awk '{split($0, array, "\"")} END{print array[6]}'`
		echo "$owner/$name"
	fi
}

# If passed no argument, this function creates ~/.gits/cache if
# it does not exists. Anything passed to the function will be
# saved in the cache file.
function gits_cache() {
	if [[ $1 ]]
	then
		if [[ -f ~/.gits/cache ]]
		then
			echo $1 >> ~/.gits/cache
		else
			`touch ~/.gits/cache`	
			echo $1 >> ~/.gits/cache
		fi
	else
		if [[ ! -f ~/.gits/cache ]]
		then
			`touch ~/.gits/cache`	
		fi
	fi
}

function gits_clone() {
	echo `git clone https://github.com/"$1".git`
}

function gits_cache_and_clone() {
	echo `gits_cache "$1"`
	echo `gits_clone "$1"`
}
