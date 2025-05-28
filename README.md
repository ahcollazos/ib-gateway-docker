docker exec -u root -it ib-gateway-docker-ib-gateway-1 bash

docker restart ib-gateway-docker-ib-gateway-1

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' b-gateway-docker-ib-gateway-1