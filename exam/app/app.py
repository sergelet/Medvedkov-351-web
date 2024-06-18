from flask import Flask, render_template, send_from_directory
from flask_migrate import Migrate
from sqlalchemy.exc import SQLAlchemyError
from auth import bp as auth_bp, init_login_manager
from book import bp as book_bp
from models import db, Genre, Book, Oblojka, GenreBook
from tools import BookFilter


app = Flask(__name__)

application = app
app.config.from_pyfile('config.py')

db.init_app(app)
migrate = Migrate(app, db)

init_login_manager(app)


app.register_blueprint(auth_bp)
app.register_blueprint(book_bp)


@app.route('/')
def index():
    books = db.session.execute(db.select(Book)).scalars().all()
    genres_for_books = {}
    for book in books:
        book_id = db.session.query(Book.id).\
            filter(Book.name == book.name).\
            scalar()
        genres = db.session.query(Genre).\
            join(GenreBook, Genre.id == GenreBook.genre_id).\
            join(Book, GenreBook.book_id == Book.id).\
            filter(Book.id == book_id).\
            all()
        genres_for_books[book.name] = [genre.name for genre in genres]
    
    books = BookFilter().find()
    pagination = db.paginate(books, per_page=10)
    books = pagination.items
    return render_template(
        'index.html',
        genres=genres,  
        books=books,
        pagination=pagination,
        genres_for_books=genres_for_books
    )

@app.route('/images/<skin_id>')
def skin(skin_id):
    img = db.get_or_404(Oblojka, skin_id)
    return send_from_directory(app.config['UPLOAD_FOLDER'], img.filename)