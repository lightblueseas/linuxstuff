echo 'Username?'
read username
echo 'Password?'
read -s password  # -s flag hides password text
echo 'Repo name?'
read reponame

echo -e "The username ${username}\n\n"

echo -e "The password ${password}\n\n"
echo -e "The reponame ${reponame}\n\n"

 curl --user $username:$password https://api.bitbucket.org/1.0/repositories/ --data name=$reponame --data is_private='true'
    git remote add origin git@bitbucket.org:$username/$reponame.git
    git push -u origin --all
    git push -u origin --tags