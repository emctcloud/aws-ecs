FROM node:20-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY index.js index.html package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "node", "index.js"]