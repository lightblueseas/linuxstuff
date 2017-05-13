USER=YOUR_USER; 
curl -s "https://api.github.com/users/$USER/repos?per_page=1000" | grep -o 'git@[^"]*'| cut -d'/' -f2 > repolist.txt