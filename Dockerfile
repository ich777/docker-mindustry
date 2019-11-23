FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget curl screen

ENV DATA_DIR=/mindustry
ENV GAME_V=
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID mindustry
RUN chown -R mindustry $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R mindustry /opt/scripts

USER mindustry

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]