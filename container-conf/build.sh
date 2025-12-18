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
    npm install --global configurable-http-proxy
    install_pip_install ipywidgets oauthenticator dockerspawner
    # For testing, pull from local
    install_pip_install pykern
    install_pip_install git+https://github.com/radiasoft/rsdockerspawner.git
    install_pip_install sirepo
}

_jupyterhub_nvm() {
    # Required when NVM_DIR is set
    mkdir -p "$NVM_DIR"
    PROFILE=/dev/null install_download https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh '' nvm 0.40.3 | PROFILE=/dev/null bash
    install_source_bashrc
    nvm install 24.5.0
}
