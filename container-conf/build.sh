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
    install_yum_install libffi-devel
}

build_as_run_user() {
    install_source_bashrc
    umask 022
    mkdir -p "$HOME"/.local/{bin,lib}
    _jupyterhub_nvm
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

_jupyterhub_nvm() {
    # Required when NVM_DIR is set
    mkdir -p "$NVM_DIR"
    install_download https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh '' nvm 0.40.3 | PROFILE=/dev/null bash
    install_source_bashrc
    # Matches nodejs on fedora 36
    nvm install node 16.18.1
}
