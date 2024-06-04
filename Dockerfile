FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y wget gnupg && \
    wget -qO - https://package.perforce.com/perforce.pubkey | gpg --dearmor -o /usr/share/keyrings/perforce.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu focal release" > /etc/apt/sources.list.d/perforce.list && \
    apt-get update && \
    apt-get install -y helix-p4d

COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]