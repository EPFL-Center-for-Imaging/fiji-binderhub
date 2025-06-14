import os

xstartup = "cd ~/; dbus-launch xfce4-session"

vnc_socket = os.path.join(os.getenv("HOME"), ".vnc", "socket")

noVNC_version = "1.1.0"

# from https://github.com/jupyterlab-contrib/jupyter-archive
c.JupyterArchive.stream_max_buffer_size = (
    104857600  # The max size of tornado IOStream buffer
)
c.JupyterArchive.handler_max_buffer_length = (
    10240  # The max length of chunks in tornado RequestHandler
)
c.JupyterArchive.archive_download_flush_delay = (
    100  # The delay in ms at which we send the chunk of data to the client.
)

c.ServerApp.root_dir = f"/home/{os.getenv('NB_USER')}"

# https://jupyter-server-proxy.readthedocs.io/en/latest/server-process.html#server-process
c.ServerProxy.servers = {
    "vnc": {
        "command": [
            "/usr/bin/websockify",
            "-v",
            "--web",
            "/opt/noVNC-" + noVNC_version,
            "--heartbeat",
            "30",
            "5901",
            "--unix-target",
            vnc_socket,
            "--",
            "vncserver",
            "-verbose",
            "-xstartup",
            xstartup,
            "-geometry",
            "1024x768",
            "-SecurityTypes",
            "None",
            "-rfbunixpath",
            vnc_socket,
            "-fg",
            ":1",
        ],
        "absolute_url": False,
        "port": 5901,
        "timeout": 3600,
        "mappath": {"/": "/vnc.html"},
        "launcher_entry": {"enabled": True, "title": "Desktop"},
        "new_browser_tab": False,
    }
}