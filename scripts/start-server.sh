#!/bin/bash
CUR_V="$(find -name mindustryinstalledv-* | cut -d '-' -f 2)"
LAT_V="$(curl -s https://api.github.com/repos/Anuken/Mindustry/releases/latest | grep tag_name | cut -d '"' -f4)"
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Sleep zZz---"
sleep infinity

echo "---Preparing Server---"
chmod -R 777 ${DATA_DIR}

echo "---Starting Server---"