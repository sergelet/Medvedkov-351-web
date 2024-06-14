from datetime import datetime
from werkzeug.security import check_password_hash, generate_password_hash
from flask_login import UserMixin
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import String, ForeignKey, DateTime, Text, Integer, MetaData

ADMIN_ROLE_ID = 1
MODER_ROLE_ID = 2

# Будет исправленно

class Base(DeclarativeBase):
    metadata = MetaData(naming_convention={
        "ix": 'ix_%(column_0_label)s',
        "uq": "uq_%(table_name)s_%(column_0_name)s",
        "ck": "ck_%(table_name)s_%(constraint_name)s",
        "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
        "pk": "pk_%(table_name)s"
    })


db = SQLAlchemy(model_class=Base)


class Role(Base):
    __tablename__ = 'roles'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(256), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)

class User(Base, UserMixin):
    __tablename__ = 'users'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    login: Mapped[str] = mapped_column(String(256), nullable=False, unique=True)
    password_hash: Mapped[str] = mapped_column(String(256), nullable=False)
    last_name: Mapped[str] = mapped_column(String(256), nullable=False)
    first_name: Mapped[str] = mapped_column(String(256), nullable=False)
    middle_name: Mapped[str] = mapped_column(String(256), nullable=True)
    roles_id: Mapped[int] = mapped_column(Integer, ForeignKey('roles.id'))

    def is_admin(self) -> bool:
        return self.roles_id == ADMIN_ROLE_ID

    def is_moderator(self) -> bool:
        return self.roles_id == MODER_ROLE_ID

    def can(self, action: str) -> bool:
        if self.roles_id:
            if action == 'create':
                return self.is_admin()
            elif action == 'edit':
                return self.is_admin() or self.is_moderator()
            elif action == 'delete':
                return self.is_admin()
            elif action == 'show':
                return True
        return False

    @property 
    def full_name(self): 
        return ' '.join([self.last_name, self.first_name, self.middle_name or '']) 

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password: str) -> bool:
        return check_password_hash(self.password_hash, password)

class Book(Base): 
    __tablename__ = 'books'

    id = mapped_column(Integer, primary_key=True) 
    name: Mapped[str] = mapped_column(String(100), nullable=False) 
    short_desc: Mapped[str] = mapped_column(Text, nullable=False) 
    created_year: Mapped[datetime] = mapped_column(DateTime, nullable=False) 
    publish: Mapped[str] = mapped_column(String(100), nullable=False) 
    author: Mapped[str] = mapped_column(String(100), nullable=False) 
    pages_count: Mapped[int] = mapped_column(nullable=False) 
    rating_sum: Mapped[int] = mapped_column(default=0) 
    rating_num: Mapped[int] = mapped_column(default=0) 
    skin_id: Mapped[int] = mapped_column(Integer, ForeignKey("skins.id", ondelete="RESTRICT")) 
 
    @property 
    def rating(self): 
        if self.rating_num > 0: 
            return self.rating_sum / self.rating_num 
        return 0

class Genre(Base):
    __tablename__ = 'genres'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(256), unique=True, nullable=False)

class GenreBook(Base):
    __tablename__ = 'genresbooks'

    book_id: Mapped[int] = mapped_column(Integer, ForeignKey('books.id', ondelete='CASCADE'), primary_key=True, nullable=False)
    genre_id: Mapped[int] = mapped_column(Integer, ForeignKey('genres.id', ondelete='CASCADE'), primary_key=True, nullable=False)


class Skin(Base):
    __tablename__ = 'skins'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    filename: Mapped[str] = mapped_column(String(256), nullable=False)
    mime_type: Mapped[str] = mapped_column(String(256), nullable=False)
    md5_hash: Mapped[str] = mapped_column(String(256), nullable=False)


class Review(Base):
    __tablename__ = 'reviews'

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    book_id: Mapped[int] = mapped_column(Integer, ForeignKey('books.id'), nullable=False)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey('users.id'), nullable=False)
    rating: Mapped[int] = mapped_column(Integer, nullable=False)
    text: Mapped[str] = mapped_column(Text, nullable=False)
    date_added: Mapped[datetime] = mapped_column(DateTime, default=db.func.current_timestamp(), nullable=False)


    # требует исправление



