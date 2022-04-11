#!/bin/env python
"""Start the bot."""
from archivebot.archivebot import main
from sqlalchemy_utils.functions import database_exists, create_database
from archivebot.db import engine, base
from archivebot.models.file import File  # noqa
from archivebot.models.subscriber import Subscriber  # noqa
from logging import basicConfig as basicLoggingConfig

basicLoggingConfig(level="DEBUG")

db_url = engine.url
if not database_exists(db_url):
    print("Setting up database...")
    create_database(db_url)
    base.metadata.create_all()

print("Starting up...")
main()
