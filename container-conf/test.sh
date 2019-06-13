#!/bin/bash
set -euo pipefail
docker rm --force jupyter-vagrant 2>& /dev/null || true
docker rm --force jupyterhub 2>& /dev/null || true
rm -rf run
export HOST=$(hostname -f)
export USER_D=$PWD/run/user
mkdir -p run/{"$HOST",user/vagrant}
cd run/"$HOST"
export TLS_DIR=/srv/jupyterhub
sudo cat /etc/docker/tls/cert.pem > cert.pem
sudo cat /etc/docker/tls/key.pem > key.pem
cp cert.pem cacert.pem
cd ../..
perl -p -e 's/\$([A-Z_]+)/$ENV{$1}/eg' test_jupyterhub_config.py > run/jupyterhub_config.py
args=(
    --rm
    --tty
    --name jupyterhub
    -u vagrant
    -p 8000:8000
    -v $PWD/run:/srv/jupyterhub
    -v $PWD/run:/var/db/jupyterhub
    radiasoft/jupyterhub
    jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
)
docker run "${args[@]}"
