FROM node:14-alpine

ARG VERSION
ENV VERSION ${VERSION}

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

CMD ["npm", "start"]
