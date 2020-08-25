#!/bin/bash
set -euo pipefail
docker rm --force jupyter-vagrant >& /dev/null || true
docker rm --force jupyterhub >& /dev/null || true
rm -rf run
export USER_D=$PWD/run/user
export TLS_DIR=/srv/jupyterhub
export PUBLIC_IP=$(hostname -i)
export POOL_HOST=$(hostname -f)
if [[ ! $(sudo cat /etc/docker/daemon.json) =~ $POOL_HOST ]]; then
    export POOL_HOST=localhost.localdomain
    if [[ ! $(sudo cat /etc/docker/daemon.json) =~ $POOL_HOST ]]; then
        echo '/etc/docker/daemon.json not right'
        exit 1
    fi
fi
echo "Connecting to docker via $POOL_HOST"
# don't use $DOCKER_HOST, because docker run below will try to
# use it.
mkdir -p run/{"$POOL_HOST",user/vagrant}
cd run/"$POOL_HOST"
sudo cat /etc/docker/tls/cert.pem > cert.pem
sudo cat /etc/docker/tls/key.pem > key.pem
(sudo cat /etc/docker/tls/cacert.pem 2>/dev/null || sudo cat /etc/docker/tls/cert.pem) > cacert.pem
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
# to test docker
: docker \
    --host=://$POOL_HOST:2376 \
    --tlscacert=run/$POOL_HOST/cacert.pem \
    --tlscert=run/$POOL_HOST/cert.pem \
    --tlskey=run/$POOL_HOST/key.pem \
    --tlsverify \
    ps
exec docker run "${args[@]}"
