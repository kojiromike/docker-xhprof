all: build launch browse

build: compose Dockerfile conf/*
	docker-compose build

launch: compose
	docker-compose up -d

clean: compose
	docker-compose kill; docker-compose rm -fv

browse: compose
	open http://`docker-machine ip default`:`docker-compose ps -q | xargs docker port | cut -d: -f2`

compose: docker-compose.yml.tmpl
	sed 's;profiles;$(PWD)/profiles;' docker-compose.yml.tmpl > docker-compose.yml
