FROM ubuntu:24.04

WORKDIR /servers
VOLUME /servers

# 1. Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

# 2. Add 32-bit architecture support
RUN dpkg --add-architecture i386

# 3. Add the multiverse repository
RUN apt-get update && apt-get install -y software-properties-common \
    && apt-add-repository multiverse

# 4. Pre-accept the Steam EULA license (crucial for Docker!)
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note "" | debconf-set-selections

# 5. Install steamcmd and certificate utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    steamcmd \
    ca-certificates \
    gosu procps \
    && rm -rf /var/lib/apt/lists/*

# 6. Create a symlink so 'steamcmd' is accessible globally in your terminal
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /scripts/*

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]