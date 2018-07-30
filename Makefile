DOCKER_IMAGE=maiha/gdrive-rest:0.1.0

.PHONY : image
image:
	docker build -t $(DOCKER_IMAGE) .

.PHONY : httpd
httpd:
	docker run --rm -it -v $(PWD):/mnt -w /mnt -e APP_ENV=production --net host $(DOCKER_IMAGE) httpd -p 8080 -o 0.0.0.0

.PHONY : run
run:
	docker run --rm -it -v $(PWD):/mnt -w /mnt --net host $(DOCKER_IMAGE) httpd -p 8080

.PHONY : exec
exec:
	docker run --rm -it -v $(PWD):/mnt -w /mnt $(DOCKER_IMAGE) sh

.PHONY : auth
auth:
	docker run --rm -it -v $(PWD):/mnt -w /mnt $(DOCKER_IMAGE) auth
