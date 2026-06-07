podman run \
	--name geovcs-db \
	-p 3306:3306 \
	-e DOLT_ROOT_PASSWORD="" \
	-e DOLT_ROOT_HOST="%" \
	-d localhost/geovcs-db:latest
