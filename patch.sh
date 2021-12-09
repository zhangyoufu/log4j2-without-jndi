#!/bin/bash
set -eu
SCRIPT_DIR=$(cd -- $(dirname -- "$0"); pwd)
for JAR_PATH in "$@"; do
	if [[ $JAR_PATH != *log4j-core*.jar ]] || [ -e "$JAR_PATH.bak" ] || ! [ -f "$JAR_PATH" ]; then
		echo "Skipped $JAR_PATH"
		continue
	fi
	echo "Processing $JAR_PATH"
	WORKSPACE=$(mktemp -d)
	cp -p "$JAR_PATH" "$WORKSPACE/log4j-core.jar"
	(
		cd "$WORKSPACE"
		unzip -q log4j-core.jar org/apache/logging/log4j/core/lookup/Interpolator.class
		(
			cd org/apache/logging/log4j/core/lookup
			"$SCRIPT_DIR/Krakatau/disassemble.py" -out . -roundtrip Interpolator.class >/dev/null
			sed -i -e 's|JndiLookup|NoMoreJndi|' Interpolator.j
		)
		"$SCRIPT_DIR/Krakatau/assemble.py" -out . org/apache/logging/log4j/core/lookup/Interpolator.j >/dev/null
		zip -9fq log4j-core.jar org/apache/logging/log4j/core/lookup/Interpolator.class
	)
	mv "$JAR_PATH" "$JAR_PATH.bak"
	mv "$WORKSPACE/log4j-core.jar" "$JAR_PATH"
	rm -rf "$WORKSPACE"
done
