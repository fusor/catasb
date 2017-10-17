docker ps -aq | xargs docker rm -v
docker images -q | xargs docker rmi -f
