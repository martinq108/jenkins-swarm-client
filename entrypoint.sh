#!/bin/sh
set -e

LABELS="${LABELS:-docker}"
EXECUTORS="${EXECUTORS:-3}"
FSROOT="${FSROOT:-/var/jenkins_home}"

JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

mkdir -p $FSROOT
java -jar $JAR -labels=$LABELS -executors=$EXECUTORS -fsroot=$FSROOT -name=docker-$(hostname) "$@"
