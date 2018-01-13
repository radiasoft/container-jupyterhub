#!/bin/bash
set -e -u -o pipefail
set -x
ip=$(dig +short $(hostname -f))
docker service rm jupyterhub || true
docker swarm leave -f || true
docker network rm jupyterhub || true
docker swarm init --advertise-addr=$ip
docker network create --driver=overlay --subnet=192.168.222.0/20 --attachable jupyterhub
echo 'ADD another node with above command (if you want)'
rm -rf run
mkdir -p run/{conf,{scratch,jupyterhub}/vagrant}
perl -p -e 's/\$([A-Z_]+)/$ENV{$1}/eg' swarm_jupyterhub_config.py > run/conf/jupyterhub_config.py
args=(
     --restart-condition=none
     --replicas=1
     --name=jupyterhub
     --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock
     --mount type=bind,source=$PWD/run/conf/jupyterhub_config.py,destination=/srv/jupyterhub/jupyterhub_config.py,readonly
     --publish 8000:8000
     --network jupyterhub
     radiasoft/jupyterhub:20180113.013231
     jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
)
docker service create "${args[@]}" | tee
echo "connect to http://$ip:8000"
echo "login as vagrant/vagrant"
