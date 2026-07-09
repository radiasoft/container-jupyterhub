#!/bin/bash
build_image_base=radiasoft/python3
build_docker_cmd=
build_is_public=1
build_passenv='PYKERN_BRANCH SIREPO_BRANCH'

build_as_root() {
    # POSIT: This is sirepo.srdb_root
    mkdir -p /srv/sirepo/db /srv/jupyterhub
    echo '# Real cfg in conf/jupyterhub_config.py' > /srv/jupyterhub/jupyterhub_config.py
    # libffi-devel needed by devel
    install_yum_install libffi-devel
}

build_as_run_user() {
    install_source_bashrc
    mkdir -p "$HOME"/.local/{bin,lib}
    _jupyterhub_nvm
    # POSIT: same version in radiasoft/sirepo/etc/run.sh
    npm install --global configurable-http-proxy@5.1.0
    declare x=(
        # POSIT same as beamsim-jupyter
        'docker==7.1.0'
        'traitlets==5.14.3'
        'tornado==6.5.2'
        'jupyterhub==5.4.3'
        'oauthenticator==17.3.0'
        'dockerspawner==14.0.0'
        "git+https://github.com/radiasoft/pykern.git${PYKERN_BRANCH:+@$PYKERN_BRANCH}"
        "git+https://github.com/radiasoft/sirepo.git${SIREPO_BRANCH:+@$SIREPO_BRANCH}"
        'git+https://github.com/radiasoft/rsdockerspawner.git'
    )
    install_pip_install "${x[@]}"
}

_jupyterhub_nvm() {
    # POSIT: same as rpm-code/codes/common.sh (_common_nvm)
    # Required to exist when NVM_DIR is set
    mkdir -p "$NVM_DIR"
    PROFILE=/dev/null install_download https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh '' nvm 0.40.3 | PROFILE=/dev/null bash
    install_source_bashrc
    nvm install 24.5.0
}
