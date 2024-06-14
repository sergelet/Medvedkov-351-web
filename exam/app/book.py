from flask import Blueprint, render_template, redirect, url_for, flash, request
from models import db,Genre, GenreBook
from tools import BookFilter
from flask_login import login_required, current_user, AnonymousUserMixin
from models import Book
from tools import SkinSaver

bp = Blueprint('book', __name__, url_prefix='/book')


@bp.route('/new')
def new():
    genres = db.session.execute(db.select(Genre)).scalars()
    return render_template(
        'book/new.html',
        genres=genres
        )

@bp.route('/create', methods=['POST']) ## Заглушка
@login_required
def create():
    return 0
# Будет рассширенно