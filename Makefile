all: clean deploy

deploy: 
				bin/deploy.sh

clean: 
				rm -rf dist/*

