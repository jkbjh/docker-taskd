FROM debian:bookworm-slim
MAINTAINER Jens Erat <email@jenserat.de>

ARG USERNAME=Debian-taskd
ARG UID=129
ARG GID=147
# Remove SUID programs
RUN for i in `find / -perm +6000 -type f 2>/dev/null`; do chmod a-s $i; done

RUN addgroup --gid $GID Debian-taskd --allow-bad-names && \
    adduser --uid $UID --gid $GID --disabled-password --allow-bad-names --gecos "Debian-taskd" Debian-taskd && \
    usermod -L Debian-taskd


# Taskd user, volume and port, logs
RUN mkdir -p /var/taskd && \
    chmod 700 /var/taskd && \
    ln -sf /dev/stdout /var/log/taskd.log && \
    chown Debian-taskd:Debian-taskd /var/taskd /var/log/taskd.log
VOLUME /var/taskd
# EXPOSE $UID

# Fetch taskd and dependencies, build and install taskd, remove build chain and source files
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends taskd taskwarrior bash \
    #    git ca-certificates build-essential cmake gnutls-bin libgnutls28-dev
    && \
    # git clone https://git.tasktools.org/TM/taskd.git /opt/taskd && \
    # cd /opt/taskd && \
    # git checkout 1.1.0 && \
    # cmake . && \
    # make && \
    # make install && \
    # rm -rf /opt/taskd && \
    DEBIAN_FRONTEND=noninteractive apt-get remove -y --auto-remove git build-essential cmake && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TASKDDATA=/var/taskd
COPY taskd.sh /opt/taskd.sh
USER Debian-taskd
#CMD /usr/bin/bash
CMD /opt/taskd.sh
