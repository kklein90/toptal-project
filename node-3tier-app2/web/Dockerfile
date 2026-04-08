FROM node:25

ENV PORT=8081 \
    API_HOST=api

WORKDIR /app

COPY . /app/

RUN cd /app && npm install

EXPOSE 8081

CMD ["npm", "start"]
