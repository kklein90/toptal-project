FROM node:25

ENV PORT=80 \
    DB= \
    DBUSER= \
    DBPASS= \
    DBHOST= \
    DBPORT=

WORKDIR /app

COPY . /app/

RUN cd /app && npm install

EXPOSE 80

ENTRYPOINT [ "/app/entry-point.sh" ]