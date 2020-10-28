function gch --wraps "git checkout"
    set --local BRANCH_NAME "$argv[1]"
    git checkout $BRANCH_NAME
    git push --set-upstream origin $BRANCH_NAME
end
