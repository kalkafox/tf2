FROM kalka/steamcmd

RUN mkdir -p tf2

COPY ./docker-entrypoint.sh .

RUN chmod +x ./docker-entrypoint.sh

USER steam

ENTRYPOINT ["./docker-entrypoint.sh"]