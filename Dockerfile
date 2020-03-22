# Docker image for poliastro development
FROM python:3.7-slim
LABEL maintainer="Juan Luis Cano Rodríguez <hello@juanlu.space>"

# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/

RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

RUN python -m pip install -U pip setuptools
RUN python -m pip install flit pygments wheel

# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

WORKDIR ${HOME}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

ENV FLIT_ROOT_INSTALL=1
RUN flit install --symlink --extras dev
USER ${NB_USER}
