FROM python:3.10-bullseye AS metadata
LABEL maintainer="Stefano Pigozzi <me@steffo.eu>"
WORKDIR /usr/src/archivebot

FROM metadata AS system
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install p7zip -y
RUN pip install "poetry==1.1.12"

FROM system AS dependencies
COPY pyproject.toml ./pyproject.toml
COPY poetry.lock ./poetry.lock
RUN poetry install --no-root --no-dev

FROM dependencies AS package
COPY . .
RUN poetry install

FROM package AS environment
ENV PYTHONUNBUFFERED=1

FROM environment AS app
WORKDIR /root
ENTRYPOINT ["poetry", "run", "python", "-OO"]
CMD ["./main.py"]
