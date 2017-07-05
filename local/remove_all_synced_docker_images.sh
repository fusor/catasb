docker ps -aq | xargs docker rm -f
docker images -q | xargs docker rmi -f
