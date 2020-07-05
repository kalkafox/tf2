FROM kalka/steamcmd

COPY ./docker-entrypoint.sh /home/steam

RUN mkdir -p tf2

WORKDIR /home/steam/tf2

ENTRYPOINT ["docker-entrypoint.sh"]