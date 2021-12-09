#!/bin/sh
for JAR_BAK in *.jar.bak; do
	mv "$JAR_BAK" "${JAR_BAK%.bak}"
done
