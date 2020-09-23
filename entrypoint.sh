#!/bin/sh

config_target="/config/openttd.cfg"
banlist_target="/config/${BAN_LIST}"
savegame_target="/config/save"
scenario_target="/config/scenario/${SCENARIO}"

# Check if is requested to copy data from another directory
if [ "${COPY_CONFIG}x" != "x" ]; then
	echo "Copying static configuration from ${COPY_CONFIG}"
	cp -Lr ${COPY_CONFIG}/* /config/
fi

# Check if exists a config file
if [ ! -f ${config_target} ]; then
	# we start the server then kill it quickly to write a config file
	# yes this is a horrific hack but whatever
	echo "No config file found: generating one"
	timeout 3 /app/bin/openttd -D > /dev/null 2>&1
fi

# Check if there is a ban list file to load
if [ "${BAN_LIST}x" != "x" ]; then
	echo "Merging external Ban List from ${banlist_target}"
	banread ${config_path} ${banlist_target}
fi


if [ "${LOADGAME}x" != "x" ]; then
	case ${LOADGAME} in
		'false')
			#Do nothing, is default
		;;
        'last-autosave')
			savegame_target=${savegame_target}/autosave/`ls -rt ${savegame_target}/autosave/ | tail -n1`
		;;
		'exit')
			savegame_target="${savegame_target}/autosave/exit.sav"
		;;
		*)
			savegame_target="${savegame_target}/${LOADGAME}"
	esac
fi

if [ "${LOADGAME}x" != "x" ] && [ -r ${savegame_target} ]; then
	echo "Loading from savegame - ${savegame_target}"
	exec /app/bin/openttd -D -g ${savegame_target} -x -d ${DEBUG}
elif [ "${SCENARIO}x" != "x" ] && [ -r ${scenario_target} ]; then
	echo "Creating a new game. Start scenario ${SCENARIO}"
	exec /app/bin/openttd -D -g ${scenario_target} -x -d ${DEBUG}
else
	echo "Creating a new game. Start random map."
	exec /app/bin/openttd -D -x -d ${DEBUG}
fi

exit 0
