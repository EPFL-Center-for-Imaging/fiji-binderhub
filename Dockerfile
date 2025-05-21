FROM quay.io/jupyter/base-notebook:x86_64-ubuntu-22.04
ENV DEBIAN_FRONTEND=noninteractive

USER root
WORKDIR /opt

RUN apt-get update -y \
    && apt upgrade -y \
    && apt-get install -yq --no-install-recommends \
    dbus-x11 \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    gnome-terminal \
    fonts-dejavu \
    git-gui \
    gitk \
    emacs \
    ncdu \
    libdbus-1-3 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libxcb-xfixes0\
    nodejs \
    npm \
    websockify \
    gnupg2 \
    curl \
    wget \
    zip \
    unzip \
    && apt-get autoremove --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && find /var/log -type f -exec cp /dev/null \{\} \;

RUN pip install jupyter-server-proxy

# Install TigerVNC & noVNC
RUN curl -sSfL https://sourceforge.net/projects/tigervnc/files/stable/1.10.1/tigervnc-1.10.1.x86_64.tar.gz/download | tar -zxf - -C /usr/local --strip=2
RUN curl -sSfL https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar xvz -C /opt/ && \
    chmod a+rX -R /opt/noVNC-1.1.0

COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/jupyter_notebook_config.py
# RUN wget -O /home/$NB_USER/.jupyter/jupyter_notebook_config.py "https://gitlab.com/epfl-center-for-imaging/jupyterhub-imaging/-/raw/main/jupyterhub-imaging/spawn-images/jupyter_notebook_config.py"
RUN wget -O /opt/noVNC-1.1.0/app/styles/base.css "https://gitlab.com/epfl-center-for-imaging/jupyterhub-imaging/-/raw/main/jupyterhub-imaging/spawn-images/remote_desktop/base.css"
RUN wget -O /opt/noVNC-1.1.0/app/ui.js "https://gitlab.com/epfl-center-for-imaging/jupyterhub-imaging/-/raw/main/jupyterhub-imaging/spawn-images/remote_desktop/ui.js"
RUN wget -O /opt/noVNC-1.1.0/vnc.html "https://gitlab.com/epfl-center-for-imaging/jupyterhub-imaging/-/raw/main/jupyterhub-imaging/spawn-images/remote_desktop/vnc.html"

RUN chmod -R a+rwx /home/$NB_USER/

# Make folders
RUN mkdir /home/$NB_USER/Desktop && chown -R $NB_GID:$NB_GID /home/$NB_USER/Desktop
RUN mkdir /opt/.jupyter

# Install Fiji
# RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-linux64.zip \
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-latest-linux64-jdk.zip \
    && unzip fiji-latest-linux64-jdk.zip -d /opt/ \
    && rm fiji-latest-linux64-jdk.zip \
    && chmod -R a+rwX /opt/Fiji

# # Update sites
# ENV fiji /opt/Fiji.app/ImageJ-linux64
# ENV updateCommand --update update
# RUN ${fiji} ${updateCommand} \
#     && chmod -R a+rwX /opt/Fiji.app

# Install DeconvolutionLab2
RUN wget -O /opt/Fiji/plugins/DeconvolutionLab_2.jar "https://bigwww.epfl.ch/deconvolution/deconvolutionlab2/DeconvolutionLab_2.jar"

# Desktop icon
RUN printf '[Desktop Entry]\nVersion=1.0\nName=ImageJ\nGenericName=ImageJ\nX-GNOME-FullName=ImageJ\nComment=Scientific Image Analysis\nType=Application\nCategories=Education;Science;ImageProcessing;\nExec=/opt/Fiji/fiji-linux-x64 %F\nTryExec=/opt/Fiji/fiji-linux-x64\nTerminal=false\nStartupNotify=true\nMimeType=image/*;\nIcon=/opt/Fiji/images/icon.png\nStartupWMClass=net-imagej-launcher-ClassLauncher\n' > /home/$NB_USER/Desktop/Fiji.desktop

# Copy instructions
COPY instructions.md /home/$NB_USER/instructions.md
COPY credits.txt /home/$NB_USER/credits.txt

# Copy sample image and PSF onto the desktop
COPY Drosophila.tif /home/$NB_USER/Desktop/Drosophila.tif
COPY psf_drosophila.tif /home/$NB_USER/Desktop/psf_drosophila.tif

# Final chown and chmod
RUN chown -R $NB_GID:$NB_GID /home/$NB_USER/ \
    && chmod -R a+rwx /home/$NB_USER/

# Also on the jupyter config folder
RUN chown -R $NB_GID:$NB_GID /opt/.jupyter/ \
    && chmod -R a+rwx /opt/.jupyter/

USER $NB_USER
WORKDIR /home/$NB_USER

CMD [ "jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--allow-root" ]
