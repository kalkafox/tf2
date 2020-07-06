FROM kalka/steamcmd

ENV UID=1000
ENV GID=1000

# The chonkiest of them all... it's here!

USER steam

RUN /usr/games/steamcmd +login anonymous +force_install_dir /home/steam/tf2_temp +app_update 232250 +quit

COPY ./docker-entrypoint.sh .

RUN sudo chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]