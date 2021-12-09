#!/bin/bash
set -eu
for JAR_PATH in "$@"; do
	if [[ $JAR_PATH != *log4j-core*.jar ]] || [ -e "$JAR_PATH.bak" ] || ! [ -f "$JAR_PATH" ]; then
		echo "Skipped $JAR_PATH"
		continue
	fi
	echo "Processing $JAR_PATH"
	cp -p "$JAR_PATH" "$JAR_PATH.bak"
	zip -q -d "$JAR_PATH" org/apache/logging/log4j/core/lookup/JndiLookup.class
done
