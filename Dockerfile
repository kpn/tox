FROM ubuntu:19.04
ENV pythonVersions='python2.7 python3.7 python3.8'
ENV pythonVenvVersions='python3.7 python3.8'

COPY docker-compose /usr/local/bin/docker-compose
RUN ln -s /usr/local/bin/virtualenv-2.7 /usr/local/bin/virtualenv

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends $pythonVersions \
    && apt-get install -y $(for pyver in $pythonVersions; do echo ${pyver}-dev; done) \
    && apt-get install -y $(for pyver in $pythonVenvVersions; do echo ${pyver}-venv; done) \
    && apt-get install -y python3-pip \
    && apt-get install time netcat gettext libjpeg-dev curl git-core build-essential \
         make build-essential libssl-dev zlib1g-dev libbz2-dev \
         libreadline-dev libsqlite3-dev -y \
    && for pybin in $pythonVersions; do ${pybin} -m pip install -U pip tox; done \
    && apt-get remove -y python3-pip \
    && apt-get install -y \
         apt-transport-https \
         ca-certificates \
         software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get install -y docker-ce \
    && rm -rf /var/lib/apt/lists/*

