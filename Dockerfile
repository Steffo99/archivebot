FROM python:3.10-bullseye AS metadata
LABEL maintainer="Stefano Pigozzi <me@steffo.eu>"

FROM metadata AS system
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install p7zip -y
RUN pip install "poetry==1.1.12"

FROM system AS dependencies
WORKDIR /usr/src/archivebot
COPY pyproject.toml ./pyproject.toml
COPY poetry.lock ./poetry.lock
RUN poetry install --no-root --no-dev

FROM dependencies AS package
WORKDIR /usr/src/archivebot
COPY . .
RUN poetry install

FROM package AS environment
ENV PYTHONUNBUFFERED=1

FROM environment AS app
WORKDIR /root
CMD ["/usr/src/archivebot/.venv/bin/python", "-OO", "/usr/src/archivebot/main.py"]
