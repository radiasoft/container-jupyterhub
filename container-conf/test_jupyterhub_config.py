import jupyter_client.localinterfaces
import base64

c.Authenticator.admin_users = set(['vagrant'])
import jupyterhub.auth
class _Auth(jupyterhub.auth.Authenticator):
    async def authenticate(self, handler, data):
        if data['password'] == 'testpass':
            return data['username']
        return None
c.JupyterHub.authenticator_class = _Auth
c.JupyterHub.cleanup_servers = False
c.JupyterHub.confirm_no_ssl = True
c.JupyterHub.cookie_secret = base64.b64decode('qBdGBamOJTk5REgm7GUdsReB4utbp4g+vBja0SwY2IQojyCxA+CwzOV5dTyPJWvK13s61Yie0c/WDUfy8HtU2w==')
c.JupyterHub.hub_ip = jupyter_client.localinterfaces.public_ips()[0]
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = 8000
c.ConfigurableHTTPProxy.auth_token = '17992634c6c7489d533c1fb0ea0b95d84a6911a2076c451e1ea9041be7b63de1'
c.DockerSpawner.http_timeout = 60
c.DockerSpawner.image_whitelist = []
c.DockerSpawner.image = 'radiasoft/beamsim-jupyter'
c.DockerSpawner.remove = False
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.volumes = {
    '$USER_D/{username}': {
        # POSIT: notebook_dir in
        # radiasoft/container-beamsim-jupyter/container-conf/build.sh
        # parameterize anyway, because matches above
        'bind': '/home/vagrant/jupyter',
    },
}
# Allow JupyterHub to restart without killing containers
c.DockerSpawner.network_name = 'host'
c.RSDockerSpawner.cfg = '''{
    "pools": {
        "default": {
            "hosts": [
                "$HOST"
            ],
            "min_activity_hours": 1,
            "servers_per_host": 2,
            "users": []
        }
    },
    "port_base": 8100,
    "tls_dir": "$TLS_DIR"
}
'''
from rsdockerspawner import rsdockerspawner
c.JupyterHub.spawner_class = rsdockerspawner.RSDockerSpawner
c.Application.log_level = 'DEBUG'
#c.JupyterHub.debug_db = True
c.ConfigurableHTTPProxy.debug = True
c.JupyterHub.log_level = 'DEBUG'
c.LocalProcessSpawner.debug = True
c.Spawner.debug = True
