#!/bin/bash
build_image_base=radiasoft/python3
build_docker_cmd='[]'
build_is_public=1

build_as_root() {
    umask 022
    # POSIT: This is sirepo.srdb_root
    mkdir -p /srv/sirepo/db
    mkdir -p /srv/jupyterhub
    echo '# Real cfg in conf/jupyterhub_config.py' > /srv/jupyterhub/jupyterhub_config.py
    # libffi-devel needed by devel
    install_yum_install nodejs npm libffi-devel
}

build_as_run_user() {
    umask 022
    mkdir -p "$HOME"/.local/{bin,lib}
    # POSIT: same version in radiasoft/sirepo/etc/run.sh
    npm install --global configurable-http-proxy@4.6.3
    pip install wheel
    # POSIT: versions same in container-beamsim-jupyter/build.sh
    # TODO(robnagler) version need to be the same in sirepo/etc/run.sh
    pip install jupyterhub==1.1.0 jupyterlab==2.1.0
    pip install ipywidgets
    pip install git+https://github.com/jupyterhub/oauthenticator.git@0.10.0
    pip install git+https://github.com/jupyterhub/dockerspawner.git@0.11.1
    pip install git+https://github.com/radiasoft/pykern.git
    pip install git+https://github.com/radiasoft/rsdockerspawner.git
    pip install git+https://github.com/radiasoft/sirepo.git
}
