# Kong + Prometheus + Grafana
API Gateway with monitoring using Prometheus + Grafana

port running
|container nam|port|description|
|-|-|-|
|kong-db|9009 -> 5432|-|
|kong-app|9000 -> 8000|api gateway|
|kong-app|9001 -> 8001|manager api|
|konga-app|9010 -> 1337|manager api (GUI)|
|prometheus-app|9015 -> 9090|-|
|grafana-app|9020 -> 3000|-|

## Kong Gateway

### Preparing
1. copy `.env.example` to `.env`
2. set `KONG_PG_USER`, `KONG_PG_PASSWORD`, and `TOKEN_SECRET`
3. create docker network named `kong_network`
4. create docker volume named `kong_postgres`
5. use `Makefile` to control installation
6. run `make kong-build` to build kong

### Manual Installation
1. run `make kong-db` first to generate enviroment db kong
2. run `make kong-migration` to generate table for kong and konga
3. run `make kong-app` to build kong and konga

### Update Or Re-build
do manual compose like `docker-compose up -d kong-app` if had other update to app

### Konga Login
if konga not first create admin, maybe it has default user

username: `admin`

password: `adminadminadmin`

### Konga Connection
use name of container and port admin (default is 8001)

`Name`: `Kong`

`Kong Admin Url`: `http://kong-app:8001`

## Grafana

### Preparing
1. kong is ready
2. run `make grafana-build` to build prometheus + grafana
3. check plugin prometheus on konga is something problem

### Grafana Login
if grafana not first create admin, maybe it has default user

username: `admin`

password: `admin`

### Create Prometheus New Connection
1. click `Connections`
2. click `Add new connection` and search Prometheus
3. on `Prometheus server URL` fill with `http://prometheus-app:9090`
4. click `Save & Test`

### Grafana Import Dashboard
1. click `Dashboard` on left side
2. click `New` and select `Import`
3. insert `7424` on `Import via grafana.com` and click `Load` on right side, after that click `Import`
3. or upload `kong.json` from folder `grafana/dashboard` and click `Import`
4. don't forget to select Prometheus connection