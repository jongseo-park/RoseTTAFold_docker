FROM nvidia/cuda:11.3.1-base-ubuntu20.04

MAINTAINER Jongseo_Park jongseopark@gist.ac.kr


# Initial setup
RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    vim \
    python3 \
    python3-pip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \ 
    && wget -q -P /tmp \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash -c "source ~/.bashrc"


# Git clone
WORKDIR /opt/
RUN git clone https://github.com/RosettaCommons/RoseTTAFold.git


# Generate conda envs
WORKDIR /opt/RoseTTAFold
ENV PATH="/opt/conda/condabin:$PATH"
RUN conda env create -f RoseTTAFold-linux.yml \
    && conda env create -f folding-linux.yml


# Copy PyRosetta from local (./)
# WORKDIR /opt/RoseTTAFold
# COPY PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2 /opt/RoseTTAFold
# RUN tar -vjxf PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2 \
#    && rm -rf PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2


# Download PyRosetta from server
WORKDIR /opt/RoseTTAFold
RUN wget --user=name --password=passwd https://graylab.jhu.edu/download/PyRosetta4/archive/release/PyRosetta4.Release.python37.ubuntu/PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2 \
    && tar -vjxf PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2 \
    && rm -rf PyRosetta4.Release.python37.ubuntu.release-294.tar.bz2


# Install RoseTTAFold
WORKDIR /opt/RoseTTAFold
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate folding" >> ~/.bashrc \ 
    && ./install_dependencies.sh


# Install PyRosetta
WORKDIR /opt/RoseTTAFold/PyRosetta4.Release.python37.ubuntu.release-294/setup
RUN /opt/conda/envs/folding/bin/python setup.py install


# Setup directory and symbolic links
WORKDIR /home
RUN mkdir run \
    && mkdir run/DAT \
    && mkdir run/DAT/UniRef30_2020_06 \
    && mkdir run/DAT/bfd \
    && mkdir run/DAT/pdb100_2021Mar03 \
    && mkdir run/DAT/weights \
    && ln -sf /home/run/DAT/UniRef30_2020_06 /opt/RoseTTAFold \
    && ln -sf /home/run/DAT/bfd /opt/RoseTTAFold \
    && ln -sf /home/run/DAT/pdb100_2021Mar03 /opt/RoseTTAFold \
    && ln -sf /home/run/DAT/weights /opt/RoseTTAFold


# Finalize
WORKDIR /home/run/
ENV PATH="/opt/RoseTTAFold:$PATH"
