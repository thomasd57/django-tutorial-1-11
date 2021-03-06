run:
	docker run --env-file secrets.env -p 8000:80 -it polls

run_azure:
	./az-container-create.sh

build:
	docker build -t polls .
	docker tag polls ampervuecontainers.azurecr.io/ampervue-polls

build_azure:
	docker build -t azure -f Dockerfile.azure .

