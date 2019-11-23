#!/bin/bash
CUR_V="$(find ${DATA_DIR} -name mindustryinstalled-* | cut -d '-' -f 2 | cut -c2-)"
LAT_V="$(curl -s https://api.github.com/repos/Anuken/Mindustry/releases/latest | grep tag_name | cut -d '"' -f4 | cut -c2-)"
if [ "${GAME_V}" == "latest" ]; then
	GAME_V=$LAT_V
fi
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for 'runtime' folder---"
if [ ! -d ${DATA_DIR}/runtime ]; then
	echo "---'runtime' folder not found, creating...---"
	mkdir ${DATA_DIR}/runtime
else
	echo "---"runtime" folder found---"
fi

echo "---Checking if Runtime is installed---"
if [ -z "$(find ${DATA_DIR} -name jre*)" ]; then
    if [ "${RUNTIME_NAME}" == "jre1.8.0_211" ]; then
    	echo "---Downloading and installing Runtime---"
		cd ${DATA_DIR}/runtime
		wget -qi ${RUNTIME_NAME} https://github.com/ich777/docker-minecraft-basic-server/raw/master/runtime/8u211.tar.gz
        tar --directory ${DATA_DIR}/runtime -xvzf ${DATA_DIR}/runtime/8u211.tar.gz
        rm -R ${DATA_DIR}/runtime/8u211.tar.gz
    else
    	if [ ! -d ${DATA_DIR}/runtime/${RUNTIME_NAME} ]; then
        	echo "---------------------------------------------------------------------------------------------"
        	echo "---Runtime not found in folder 'runtime' please check again! Putting server in sleep mode!---"
        	echo "---------------------------------------------------------------------------------------------"
        	sleep infinity
        fi
    fi
else
	echo "---Runtime found---"
fi

echo "---Checking for Mindustry Server executable ---"
if [ -z "$CUR_V" ]; then
    cd ${DATA_DIR}
   	echo "---Mindustry Server not found, downloading v${GAME_V}---"
    if wget https://github.com/Anuken/Mindustry/releases/download/v$GAME_V/server-release.jar ; then
    	echo "---Sucessfully downloaded Mindustry---"
       	touch mindustryinstalled-v$GAME_V
        rm ${DATA_DIR}/.wget-hst
    else
    	echo "---Something went wrong, can't download Mindustry, putting server in sleep mode---"
       	sleep infinity
	fi
else
	if [ "${GAME_V}" != "$CUR_V" ]; then
		echo "---Version missmatch v${CUR_V} installed, installing v${GAME_V}---"
    	rm ${DATA_DIR}/mindustryinstalled-v${CUR_V}
        rm ${DATA_DIR}/server-release.jar
		cd ${DATA_DIR}
		if wget https://github.com/Anuken/Mindustry/releases/download/v${GAME_V}/server-release.jar ; then
	    	echo "---Sucessfully downloaded Mindustry---"
    	   	touch mindustryinstalled-v$GAME_V
            rm ${DATA_DIR}/.wget-hsts
    	else
    		echo "---Something went wrong, can't download Mindustry, putting server in sleep mode---"
        	sleep infinity
    	fi
	elif [ "${GAME_V}" == "$CUR_V" ]; then
		echo "---Versions match! Installed: v$CUR_V | Preferred: v${GAME_V}---"
	fi
fi

echo "---Preparing Server---"
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;

chmod -R 777 ${DATA_DIR}

echo "---Starting Server---"
screen -S Mindustry -L -Logfile ${DATA_DIR}/masterLog.0 -d -m ${DATA_DIR}/runtime/${RUNTIME_NAME}/bin/java -jar ${DATA_DIR}/server-release.jar name ${SRV_NAME} host ${GAME_PARAMS}
tail -F ${DATA_DIR}/masterLog.0