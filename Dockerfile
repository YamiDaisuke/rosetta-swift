FROM swift:latest

RUN apt-get update
RUN apt-get install -y --no-install-recommends libsqlite3-dev zip
