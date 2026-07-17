FROM ubuntu:24.04

# 0. Prevent interactive prompts during installation and delete base ubuntu user
ENV DEBIAN_FRONTEND=noninteractive
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu && groupdel ubuntu 2>/dev/null || true

# 1. Add 32-bit architecture support
RUN dpkg --add-architecture i386

# 2. Add the multiverse repository
RUN apt-get update && apt-get install -y software-properties-common \
    && apt-add-repository multiverse

# 3. Pre-accept the Steam EULA license
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note "" | debconf-set-selections

# 4. Install steamcmd and certificate utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    steamcmd \
    ca-certificates \
    gosu procps \
    && rm -rf /var/lib/apt/lists/*

# 5. Create a symlink so 'steamcmd' is accessible globally in your terminal
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /scripts/*

# 1. Create and setup default user
ARG PUID=1000
ARG PGID=1000
RUN groupadd -g ${PGID} -r dayz-docker && useradd -u ${PUID} -g dayz-docker -r -s /bin/bash -m dayz-docker
WORKDIR /home/dayz-docker
RUN chown -R dayz-docker:dayz-docker /home/dayz-docker
USER dayz-docker

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]