#!/bin/bash
build_image_base=jupyterhub/jupyterhub:0.9.4
build_simply=1
build_docker_cmd='[]'
build_is_public=1

build_as_root() {
    umask 022
    apt-get update
    apt-get -y install build-essential
    pip install 'ipython[all]'
    pip install git+git://github.com/jupyterhub/oauthenticator.git@0.8.1
    pip install git+git://github.com/jupyterhub/dockerspawner.git@0.11.0
    pip install git+git://github.com/radiasoft/pykern.git
    pip install git+git://github.com/radiasoft/rsdockerspawner.git
    echo '# Real cfg in conf/jupyterhub_config.py' > /srv/jupyterhub/jupyterhub_config.py
    # Convenient to have "vagrant" user for development
    build_create_run_user
    apt-get remove --purge -y build-essential
    apt-get autoremove --purge -y
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    rm -rf /root/.cache
    rm -rf /src
}
