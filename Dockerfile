FROM ubuntu:noble

# update and install dependencies
RUN echo "update and install dependencies" && \ 
    apt update && apt install -y --no-install-recommends \
    wget \
    lsb-release \
    software-properties-common \
    git && \
    apt clean

# Configuring R repository
RUN echo "Configuring R repository" && \ 
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | \ 
    tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# Install R and dependencies
RUN echo "installing R dependencies" && \     
    apt update && apt install -y --no-install-recommends \
    dirmngr \
    r-base &&\
    apt clean

# Install R packages
RUN echo "installing R packages" && \     
    Rscript -e "install.packages(c('XML', 'openxlsx', 'cld2', 'ineq'), repos='https://cloud.r-project.org')"


# Create user stilabs
RUN useradd -ms /bin/bash stilabs

USER stilabs

WORKDIR /application
# clone the repository
RUN git clone https://github.com/jalvesaq/PontuarLattes.git .

# Run tail to keep the container running
CMD ["tail", "-f", "/dev/null"]




