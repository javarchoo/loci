#!/bin/bash -ex

$(dirname $0)/download.sh

git init /tmp/${PROJECT}
git --git-dir /tmp/${PROJECT}/.git fetch ${PROJECT_REPO} ${PROJECT_REF}
git --work-tree /tmp/${PROJECT} --git-dir /tmp/${PROJECT}/.git checkout FETCH_HEAD

curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm get-pip.py

pip install --no-cache-dir --no-index --no-compile --find-links /tmp/packages --constraint /tmp/packages/upper-constraints.txt \
        /tmp/${PROJECT} \
        pymysql \
        python-memcached \
        uwsgi

groupadd -g 42424 ${PROJECT}
useradd -u 42424 -g ${PROJECT} -M -d /var/lib/${PROJECT} -s /usr/sbin/nologin -c "${PROJECT} user" ${PROJECT}

mkdir -p /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT}
chown ${PROJECT}:${PROJECT} /etc/${PROJECT} /var/log/${PROJECT} /var/lib/${PROJECT} /var/cache/${PROJECT}

$(dirname $0)/cleanup.sh
