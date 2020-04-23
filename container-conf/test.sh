#!/bin/bash
set -euo pipefail
docker rm --force jupyter-vagrant >& /dev/null || true
docker rm --force jupyterhub >& /dev/null || true
rm -rf run
export USER_D=$PWD/run/user
export TLS_DIR=/srv/jupyterhub
export PUBLIC_IP=$(hostname -i)
mkdir -p run/{localhost.localdomain,user/vagrant}
cd run/localhost.localdomain
sudo cat /etc/docker/tls/cert.pem > cert.pem
sudo cat /etc/docker/tls/key.pem > key.pem
cp cert.pem cacert.pem
cd ../..
perl -p -e 's/\$([A-Z_]+)/$ENV{$1}/eg' test_jupyterhub_config.py > run/jupyterhub_config.py
args=(
    --rm
    --tty
    --name jupyterhub
    --network=host
    --workdir=/srv/jupyterhub
    -u vagrant
    -v $PWD/run:/srv/jupyterhub
)
d=$HOME/src/radiasoft/rsdockerspawner/rsdockerspawner
if [[ -d $d ]]; then
    echo "Mount: $d"
    args+=(
        -v "$d:$(python -c 'from distutils.sysconfig import get_python_lib as x; print(x())')"/rsdockerspawner
    )
fi
args+=(
    radiasoft/jupyterhub
    bash -l -c 'jupyterhub -f /srv/jupyterhub/jupyterhub_config.py'
)
exec docker run "${args[@]}"
