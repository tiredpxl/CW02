FROM node:6.14.2
WORKDIR /app
EXPOSE 8080
COPY server.js .
CMD node server.js


