FROM node:5.5.0-wheezy

ADD package.zip.enc package.json /home/

RUN apt-get update -y && \
	apt-get install openssl unzip -y && \
	apt-get clean && \
	mkdir -p /home/service/data && \
	cp /home/package.json /home/service && \
	cd /home/service && \
	npm install --production

EXPOSE 3000

CMD cd /home && \
	openssl enc -d -aes-256-cbc -in package.zip.enc -out package.zip -pass pass:$UNLOCK_KEY && \
	unzip package.zip && \
	cp -r package/* . && \
	rm -rf package && \
	cd service && \
	npm install --production && \
	node src/Service.js
	