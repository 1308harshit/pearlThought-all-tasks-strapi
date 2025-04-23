FROM node:18

WORKDIR /app

COPY strapi/package*.json ./

RUN npm install --production

COPY strapi/ ./

EXPOSE 1337

RUN npm run build

CMD ["npm", "run", "start"]