FROM kalka/steamcmd

RUN mkdir -p tf2

COPY ./docker-entrypoint.sh /home/steam/tf2

WORKDIR /home/steam/tf2

USER root

RUN chmod +x ./docker-entrypoint.sh

USER steam

ENTRYPOINT ["./docker-entrypoint.sh"]