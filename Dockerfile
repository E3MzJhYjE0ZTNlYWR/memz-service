FROM node:5.5.0-slim

ADD package.zip.enc package.json /home/

RUN apt-get update -y && \
	apt-get install openssl unzip -y && \
	apt-get clean && \
	cd /home && \
	npm install --production

EXPOSE 3000

CMD cd /home && \
	openssl enc -d -aes-256-cbc -in package.zip.enc -out package.zip -pass pass:$UNLOCK_KEY && \
	unzip package.zip && \
	mv package/* . && \
	mkdir data && \ 
	export NODE_PATH=./src && \ 
	node src/service/Service.js
	