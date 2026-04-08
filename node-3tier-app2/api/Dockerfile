FROM node:25

ENV PORT=8082 \
    DB= \
    DBUSER= \
    DBPASS= \
    DBHOST= \
    DBPORT=

WORKDIR /app

COPY . /app/

RUN cd /app && npm install

EXPOSE 8082

ENTRYPOINT [ "/app/entry-point.sh" ]