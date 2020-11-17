#!/usr/bin/bash
H2="Authorization: token "`cat public_repo_token`

varAns=0
for x in 1 2
do
varx=$(curl -s -H "$H2" 'https://api.github.com/repos/datamove/linux-git2/pulls?state=all&page='"$x"'&per_page=100'  | jq 'map(select(.user.login=="'"$1"'")) | length')
varAns=$(($varAns+$varx))
done
echo "PULLS ${varAns}"


NEW=()
for x in 1 2
do
var=$(curl -s -H "$H2" 'https://api.github.com/repos/datamove/linux-git2/pulls?state=all&page='"$x"'&per_page=100'  | jq 'map(select(.user.login=="'"$1"'")) | .[].number')
NEW+=(`echo ${var[@]}`)
done
echo "EARLIEST ${NEW[0]}"

NEW=()
for x in 1 2
do
var=$(curl -s -H "$H2" 'https://api.github.com/repos/datamove/linux-git2/pulls?state=all&page='"$x"'&per_page=100'  | jq 'map(select(.user.login=="'"$1"'")) | .[].merged_at')
NEW+=(`echo ${var[@]}`)
done
if [ "${NEW[0]}" = "null" ]
then
echo "MERGED 0"
else
echo "MERGED 1"
fi
