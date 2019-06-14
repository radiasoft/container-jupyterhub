#!/bin/bash
build_image_base=jupyterhub/jupyterhub:1.0.0
build_simply=1
build_docker_cmd='[]'
build_is_public=1

build_as_root() {
    umask 022
    apt-get update
    apt-get -y install build-essential
    pip install 'ipython[all]'
    pip install git+git://github.com/jupyterhub/oauthenticator.git@0.8.2
    pip install git+git://github.com/jupyterhub/dockerspawner.git@0.11.1
    pip install git+git://github.com/radiasoft/pykern.git
    pip install git+git://github.com/radiasoft/rsdockerspawner.git
    echo '# Real cfg in conf/jupyterhub_config.py' > /srv/jupyterhub/jupyterhub_config.py
    build_create_run_user
    apt-get remove --purge -y build-essential
    apt-get autoremove --purge -y
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    rm -rf /root/.cache
    rm -rf /src
}
