FROM jupyter/tensorflow-notebook:d4cbf2f80a2a

#Set the working directory
WORKDIR /home/jovyan/

USER root
# Install system dependencies for gym[atari]
# https://pypi.org/project/gym/0.7.4/#installation
# libav-tools replaced with ffmpeg
# xvfb, xserver-xephyr, vnc4server for pyvirtualdisplay
RUN apt-get update && apt-get install -y \
        python-numpy \
        python-dev \
        cmake \
        zlib1g-dev \
        libjpeg-dev \
        xvfb \
        ffmpeg \
        xorg-dev \
        python-opengl \
        libboost-all-dev \
        libsdl2-dev swig \
        xserver-xephyr \
        vnc4server && \
    conda install -c conda-forge pyglet

# Modules
COPY requirements.txt /home/jovyan/requirements.txt
RUN pip install -r /home/jovyan/requirements.txt

# Add files
COPY notebooks /home/jovyan/notebooks
COPY data /home/jovyan/data
COPY solutions /home/jovyan/solutions

# Allow user to write to directory
USER root
RUN chown -R $NB_USER /home/jovyan \
    && chmod -R 774 /home/jovyan \
    && rm -fR /home/jovyan/work
USER $NB_USER

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --NotebookApp.iopub_data_rate_limit=1.0e10
