from cassinyspawner.swarmspawner import SwarmSpawner
from jupyter_client.localinterfaces import public_ips
import base64

c.JupyterHub.spawner_class = SwarmSpawner
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'

c.Authenticator.admin_users = set(['vagrant'])

c.SwarmSpawner.networks = ['jupyterhub']
c.SwarmSpawner.jupyterhub_service_name = 'jupyterhub'

#from docker.types import Mount, ContainerSpec, TaskTemplate, DriverConfig
#driver_cfg = DriverConfig(name=None, options={
#      'o': 'addr=10.x.x.x',
#      'device': ':/docker/pgtest'
#      'type': 'nfs4'
#    })
#m = Mount(type='volume', target='/var/lib/postgresql/data', driver_config=driver_cfg, source=None)
c.SwarmSpawner.container_spec = {
    'args' : [],
    'Image' : "radiasoft/beamsim-jupyter:20180112.210821",
    'mounts': [
        {
            'type': 'bind',
#{username}
            'source': '$PWD/run/jupyterhub/vagrant',
            'target': '/home/vagrant/jupyter',
        },
    ],
}

c.JupyterHub.confirm_no_ssl = True
c.JupyterHub.cookie_secret = base64.b64decode('qBdGBamOJTk5REgm7GUdsReB4utbp4g+vBja0SwY2IQojyCxA+CwzOV5dTyPJWvK13s61Yie0c/WDUfy8HtU2w==')
# No need to test postgres
#c.JupyterHub.db_url = 'postgresql://jupyterhub:Ydt21HRKO7NnMBIC@postgresql-jupyterhub:5432/jupyterhub'
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = 8000
c.JupyterHub.proxy_auth_token = '+UFr+ALeDDPR4jg0WNX+hgaF0EV5FNat1A3Sv0swbrg='

# Debugging only
c.Application.log_level = 'DEBUG'
# Might not want this, but for now it's useful to see everything
#c.JupyterHub.debug_db = True
c.ConfigurableHTTPProxy.debug = True
c.JupyterHub.log_level = 'DEBUG'
c.LocalProcessSpawner.debug = True
c.Spawner.debug = True

# Testing only; Need a passwd for vagrant inside container for PAMAuthenticator
import subprocess
subprocess.check_call('echo vagrant:vagrant|chpasswd', shell=True)
