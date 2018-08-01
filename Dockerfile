FROM docker:18.05

MAINTAINER Martin Kvapil <martin@qapil.cz>

ARG user=jenkins
ARG group=jenkins
ARG uid=1009
ARG gid=1009
ARG docker_group=docker
ARG docker_gid=997
ARG JENKINS_SWARM_VERSION=3.13

ENV HOME /home/${user}

# alpine's wget does not work correctly with https, so we use curl instead
# install iputils to have correct ping behavior
# install java and jenkins swarm client
RUN apk --update add curl iputils openjdk8-jre git \
	&& mkdir -p /usr/share/jenkins \
	&& chmod 755 /usr/share/jenkins \
	&& curl -fL -o /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# create jenkins group and user
RUN addgroup -S -g ${gid} ${group}
RUN adduser -S -u ${uid} -h $HOME -G ${group} ${user}

# create docker group and assign jenkins user to that group to be able to execute docker
RUN addgroup -S -g ${docker_gid} ${docker_group}
RUN adduser ${user} ${docker_group}


# run container as jenkins user
USER ${user}

VOLUME ${HOME}
WORKDIR ${HOME}

ENTRYPOINT ["/entrypoint.sh"]
