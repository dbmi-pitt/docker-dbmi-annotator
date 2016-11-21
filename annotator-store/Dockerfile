# base.docker
FROM ubuntu:14.04

RUN echo "deb http://ppa.launchpad.net/pypy/ppa/ubuntu trusty main" > \
    /etc/apt/sources.list.d/pypy-ppa.list

RUN apt-key adv --keyserver keyserver.ubuntu.com \
                --recv-keys 2862D0785AFACD8C65B23DB0251104D968854915
RUN apt-get update

RUN apt-get install -qyy \
    -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
    python-virtualenv pypy libffi6 openssl


# Create app directory
RUN mkdir -p /home/yin2/annotator-store
WORKDIR /home/yin2/annotator-store

# Bundle app source
COPY . /home/yin2/annotator-store

# Install dependencies
RUN apt-get install -y php5-mcrypt python-pip

RUN virtualenv -p /usr/bin/pypy /pyenv
RUN . /pyenv/bin/activate; pip install pip==6.0.8

RUN pip install -e .[flask]

# EXPOSE 5000
# RUN python run.py
