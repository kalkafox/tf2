FROM kalka/steamcmd

ENV UID=1000
ENV GID=1000
ENV USER=tf2

COPY ./docker-entrypoint.sh .

RUN sudo apt update && sudo apt -y install wget && sudo apt clean

RUN sudo chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]