FROM kalka/steamcmd

ENV UID=1000
ENV GID=1000

COPY ./docker-entrypoint.sh .

USER root

RUN chmod +x ./docker-entrypoint.sh

USER steam

ENTRYPOINT ["./docker-entrypoint.sh"]