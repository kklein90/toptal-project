FROM node:25

ENV PORT=8082 \
    API_HOST=api

WORKDIR /app

COPY . /app/

RUN cd /app && npm install

EXPOSE 8082

CMD ["npm", "start"]
