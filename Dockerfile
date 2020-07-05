FROM kalka/steamcmd

RUN mkdir -p tf2

COPY ./docker-entrypoint.sh /home/steam/tf2

RUN chmod +x ./docker-entrypoint.sh

WORKDIR /home/steam/tf2

ENTRYPOINT ["./docker-entrypoint.sh"]