FROM mongo:6.0

EXPOSE 27017

ENV MONGO_INITDB_ROOT_USERNAME=admin
ENV MONGO_INITDB_ROOT_PASSWORD=admin123
ENV MONGO_INITDB_DATABASE=testdb

COPY init-data.js /docker-entrypoint-initdb.d/