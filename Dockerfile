
FROM tensorflow/tensorflow:2.1.0-gpu-py3-jupyter

LABEL maintainer="drakec"

# run as root user
USER root

ENV DEBIAN_FRONTEND noninteractive

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


# Install Python 3 packages
####################################################

# Install python3 and pip package manager
RUN cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip 

# Copy requirements for python3 [requirements3.txt]
COPY requirements3.txt /app/

# Install python3 packages ... (only neo 0.5.2 will import Spike2 files)
RUN pip3 install \
  --no-cache-dir \
  -r /app/requirements3.txt


# Configure Jupyter notebook
####################################################

RUN jupyter notebook --generate-config && \
    ipython profile create
# TextFileContentsManager is needed to jupytext
RUN echo "c.NotebookApp.open_browser = False" >>\
    /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.InteractiveShellApp.matplotlib = 'inline'" >>\
    /root/.ipython/profile_default/ipython_config.py && \
    echo "c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'" >>\
    /root/.jupyter/jupyter_notebook_config.py

# set directories and ports
####################################################

WORKDIR /app
RUN pwd

# Expose port to host
EXPOSE 8888
EXPOSE 8889
