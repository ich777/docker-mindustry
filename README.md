# Mindustry Server in Docker optimized for Unraid
This is a Basic Mindustry Server.

UPDATE NOTICE: If you set the GAME_V to 'latest' the container will always check on startup for a new version or you can set it to whatever version you preferr eg: '100', '90',... (without quotes, upgrading and downgrading also possible).

>**CONSOLE:** To connect to the console open up the terminal for this docker and type in: 'screen -xS Mindustry' (without quotes).

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for gamefile | /mindustry |
| RUNTIME_NAME | Enter your extracted Runtime folder name. Don't change unless you are knowing what you are doing! | jre1.8.0_211 |
| GAME_V | Preferred game version goes here (set to 'latest' to download the latest) | latest |
| SRV_NAME | Servername goes here (you need to set a servername) | DockerMindustry |
| GAME_PARAMS | Extra startup Parameters if needed (leave empty if not needed) | |
| UMASK | Permissions for newly created files. Don't change unless you are knowing what you are doing! | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name MinecraftBasicServer -d \
	-p 6567:6567 -p 6567:6567/udp \
	--env 'RUNTIME_NAME=jre1.8.0_211' \
	--env 'GAME_V=latest' \
	--env 'SRV_NAME=DockerMindustry' \
	--env 'UMASK=000' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/mindustry:/mindustry \
	ich777/mindustry-server
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/