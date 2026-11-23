from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import declarative_base

Base = declarative_base()


class Community(Base):
    __tablename__ = "communities"

    id = Column(Integer, primary_key=True)
    name = Column(String)
    address = Column(String)
