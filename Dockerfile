
FROM tensorflow/tensorflow:1.13.2-gpu-py3-jupyter

LABEL maintainer="drakec"

# run as root user
USER root

ENV DEBIAN_FRONTEND noninteractive

# Install Python 3 packages
####################################################

# Install python3 and pip package manager
RUN pip install --upgrade pip 

# Copy requirements for python3 [requirements3.txt]
COPY requirements3.txt /app/

# Install python3 packages ... (only neo 0.5.2 will import Spike2 files)
RUN pip install \
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
