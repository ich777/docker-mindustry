FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/mindustry
ENV GAME_V="latest"
ENV SRV_NAME="DockerMindustry"
ENV GAME_PARAMS=""
ENV RUNTIME_NAME="basicjre"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID mindustry && \
	chown -R mindustry $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R mindustry /opt/scripts

USER mindustry

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]