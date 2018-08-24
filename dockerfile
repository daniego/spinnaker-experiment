FROM ubuntu:16.04

ADD https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh /InstallHalyard.sh
RUN useradd -g users --no-create-home spinnaker
# RUN addgroup spinnaker && useradd -g spinnaker --no-create-home spinnaker
# USER spinnaker
RUN apt update
RUN apt install -y \
      software-properties-common \
      curl \
      apt-transport-https \
      wget
RUN bash /InstallHalyard.sh --user spinnaker -y
RUN hal config deploy edit --type localdebian
# RUN hal config version edit --version $SPINNAKER_VERSION

# storage

# RUN hal deploy apply

ADD entrypoint.sh /entrypoint.sh
