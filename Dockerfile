FROM rocker/rstudio:latest

RUN apt-get install -y curl \
libxtst6 \
libgit2-dev \
libxml2-dev \
libgsl0-dev \
  && mkdir git \
  && cd git \
  && wget https://www.lactame.com/visualizer/latest.tar.gz \
  && mkdir visualizer \
  && mv latest.tar.gz visualizer/. \
  && cd visualizer \
  && tar xvfz latest.tar.gz \
  && cd /git 

# install nodejs and babel-proxy-server
RUN rm /bin/sh \
  && ln -s /bin/bash /bin/sh \
  && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
RUN . /root/.nvm/nvm.sh \
  && nvm install node \
  && cd /git \
  && git clone https://github.com/cheminfo/babel-proxy-server \
  && cd babel-proxy-server \
  && npm i 

# install R pacakges
COPY install.R /home/rstudio/install.R
RUN R -e "source('/home/rstudio/install.R')" \
  && cd /usr/local/lib/R/site-library/hastaLaVista/visu/data \
  && mkdir json \
  && chmod 775 json

RUN mkdir /etc/services.d/babel
COPY ./babel /etc/services.d/babel

#CMD ["/init2"]
EXPOSE 5474 8787
