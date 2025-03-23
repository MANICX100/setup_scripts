function gitPromoteAndMerge
	echo "This will attempt to merge an existing branch with master. Any existing in master and not in the branch will be attempted to be preserved"
	git checkout -b "$argv"
	git status
	git commit -a --allow-empty-message -m " "
	git checkout master
	git merge --no-ff "$argv"
	git push origin master
  end
  
function gitDeleteBranch
	git branch -d "$argv"
	git push origin --delete "$argv"
end

function gitRenameBranch
	echo "Please run the following commands in sequence"
	echo 'git branch -m "$old" "$new" '
	echo 'git branch --unset-upstream "$new" '
	echo 'git push origin "$new" '
	echo 'git push origin -u "$new" '
end
