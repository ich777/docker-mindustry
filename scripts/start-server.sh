#!/bin/bash
CUR_V="$(find ${DATA_DIR} -name mindustryinstalled-* | cut -d '-' -f 2 | cut -c2-)"
LAT_V="$(curl -s https://api.github.com/repos/Anuken/Mindustry/releases/latest | grep tag_name | cut -d '"' -f4 | cut -c2-)"
if [ "${GAME_V}" == "latest" ]; then
	GAME_V=$LAT_V
fi

if [ -d ${DATA_DIR}/runtime ]; then
  rm -rf ${DATA_DIR}/runtime
fi

echo "---Checking for Mindustry Server executable ---"
if [ -z "$CUR_V" ]; then
    cd ${DATA_DIR}
   	echo "---Mindustry Server not found, downloading v${GAME_V}---"
    if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/Anuken/Mindustry/releases/download/v$GAME_V/server-release.jar ; then
    	echo "---Sucessfully downloaded Mindustry---"
       	touch mindustryinstalled-v$GAME_V
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
		if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/Anuken/Mindustry/releases/download/v${GAME_V}/server-release.jar ; then
	    	echo "---Sucessfully downloaded Mindustry---"
    	   	touch mindustryinstalled-v$GAME_V
    	else
    		echo "---Something went wrong, can't download Mindustry, putting server in sleep mode---"
        	sleep infinity
    	fi
	elif [ "${GAME_V}" == "$CUR_V" ]; then
		echo "---Versions match! Installed: v$CUR_V | Preferred: v${GAME_V}---"
	fi
fi

echo "---Preparing Server---"
if [ ! -f ~/.screenrc ]; then
    echo "defscrollback 30000
bindkey \"^C\" echo 'Blocked. Please use to command \"exit\" to shutdown the server or close this window to exit the terminal.'" > ~/.screenrc
fi

if [ -f ${DATA_DIR}/.wget-hsts ]; then
	rm ${DATA_DIR}/.wget-hsts
fi
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;

chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${DATA_DIR}
screen -S Mindustry -L -Logfile ${DATA_DIR}/masterLog.0 -d -m java -jar ${DATA_DIR}/server-release.jar ${EXTRA_PARAMS}name ${SRV_NAME},host,${GAME_PARAMS}
sleep 5
if [ "${ENABLE_WEBCONSOLE}" == "true" ]; then
    /opt/scripts/start-gotty.sh 2>/dev/null &
fi
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -F ${DATA_DIR}/masterLog.0