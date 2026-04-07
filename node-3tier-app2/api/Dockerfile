#  PORT: the listening PORT
# - DB: Name of the database to connect
# - DBUSER: Database user
# - DBPASS: DB user password,
# - DBHOST: Database hostname,
# - DBPORT: Database server listening port

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

CMD ["npm", "start"]
