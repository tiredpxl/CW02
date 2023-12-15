FROM node:14
WORKDIR /CW02
EXPOSE 8080
COPY server.js .
CMD node server.js


