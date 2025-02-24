FROM node:14
WORKDIR /app
COPY . .
RUN npm install express
CMD ["node", "server.js"]
EXPOSE 3000
