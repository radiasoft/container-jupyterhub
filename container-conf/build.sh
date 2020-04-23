#!/bin/bash
build_image_base=radiasoft/fedora
build_docker_cmd='[]'
build_is_public=1

build_as_root() {
    umask 022
    mkdir -p /srv/jupyterhub
    echo '# Real cfg in conf/jupyterhub_config.py' > /srv/jupyterhub/jupyterhub_config.py
    # libffi-devel needed by devel
    install_yum_install nodejs npm libffi-devel
}

build_as_run_user() {
    umask 022
    mkdir -p ~/.local/{bin,lib}
    npm install -g configurable-http-proxy
    bivio_pyenv_3
    pip install wheel
    # POSIT: versions same in container-beamsim-jupyter/build.sh
    pip install jupyterhub==1.1.0 jupyterlab==2.1.0
    pip install ipywidgets
    pip install git+git://github.com/jupyterhub/oauthenticator.git@0.10.0
    pip install git+git://github.com/jupyterhub/dockerspawner.git@0.11.1
    pip install git+git://github.com/radiasoft/pykern.git
    pip install git+git://github.com/radiasoft/rsdockerspawner.git
}
