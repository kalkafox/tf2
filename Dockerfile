FROM kalka/steamcmd

RUN mkdir -p tf2

COPY ./docker-entrypoint.sh /home/steam/tf2

WORKDIR /home/steam/tf2

RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]