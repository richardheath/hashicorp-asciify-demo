FROM node:8
WORKDIR /usr/src/app
COPY package*.json ./

RUN apt update
RUN apt-get -y install build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev
RUN npm install
COPY . .

EXPOSE 8081
CMD [ "npm", "start" ]