docker ps -aq | xargs docker rm -f
if [ "$?" -ne "0" ]; then
 exit 1;
fi 
docker images -q | xargs docker rmi -f
