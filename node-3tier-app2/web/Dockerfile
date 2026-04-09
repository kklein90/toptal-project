FROM node:25

ENV PORT=80 \
    API_HOST=api

WORKDIR /app

COPY . /app/

RUN cd /app && npm install

EXPOSE 80

ENTRYPOINT [ "/app/entry-point.sh" ]
