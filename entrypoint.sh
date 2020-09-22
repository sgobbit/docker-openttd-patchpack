#!/bin/sh

# This script is based fairly heavily off bateau84/openttd's. Thanks, man!
savegame_path="/config/save"
scenario_path="/config/scenario"

LOADGAME_CHECK="${loadgame}x"
SCENARIO_CHECK="${scenario}x"
BANLIST_CHECK="${BAN_LIST}x"
CONFIG_CHECK="${COPY_CONFIG}x"


if [ ${CONFIG_CHECK} != "x" ]; then
	echo "Copying static configuration from ${COPY_CONFIG}"
	cp -Lr ${COPY_CONFIG}/* /config/
fi


if [ ! -f /config/openttd.cfg ]; then
	# we start the server then kill it quickly to write a config file
	# yes this is a horrific hack but whatever
	echo "No config file found: generating one"
	timeout 3 /app/bin/openttd -D > /dev/null 2>&1
fi


if [ ${BANLIST_CHECK} != "x" ]; then
	echo "Merging external Ban List from /config/${BAN_LIST}"
	banread /config/openttd.cfg /config/${BAN_LIST}
fi


savegame_target="x"
if [ ${LOADGAME_CHECK} != "x" ]; then
	case ${loadgame} in
		'false')
			#Do nothing, is default
		;;
        'last-autosave')
			savegame_target=${savegame_path}/autosave/`ls -rt ${savepath}/autosave/ | tail -n1`
		;;
		'exit')
			savegame_target="${savegame_path}/autosave/exit.sav"
		;;
		*)
			savegame_target="${savegame_path}/${loadgame}"
	esac
fi


scenario_target="x"
if [ ${LOADGAME_CHECK} != "x" ]; then
	scenario_target="${scenario_path}/${scenario}"
fi


if [ ${savegame_target} != "x" ] && [ -r ${savegame_target} ]; then
	echo "Loading from savegame - ${savegame_target}"
	exec /app/bin/openttd -D -g ${savegame_target} -x -d ${DEBUG}
elif [ ${SCENARIO_CHECK} != "x" ] && [ -r ${scenario_target} ]; then
	echo "Creating a new game. Start scenario ${scenario}"
	exec /app/bin/openttd -D -g ${scenario_target} -x -d ${DEBUG}
else
	echo "Creating a new game. Start random map."
	exec /app/bin/openttd -D -x -d ${DEBUG}
fi

exit 0
