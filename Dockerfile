FROM kalka/steamcmd

ENV UID=1000
ENV GID=1000

RUN mkdir -p tf2

COPY ./docker-entrypoint.sh .

RUN chmod +x ./docker-entrypoint.sh

USER steam

ENTRYPOINT ["./docker-entrypoint.sh"]