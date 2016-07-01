IMAGE := ednity/rails

build:
	docker build -t $(IMAGE) .
