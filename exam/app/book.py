from flask import Blueprint, render_template, redirect, url_for, flash, request, send_from_directory
from models import db, Genre, GenreBook,Review, Book, Oblojka
from flask_login import login_required, current_user
from tools import OblojkaSaver, BookFilter
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
import bleach
from auth import check_rights


bp = Blueprint('book', __name__, url_prefix='/book')


@bp.route('/new')
@check_rights('new')
def new():
    genres = db.session.execute(db.select(Genre)).scalars()
    return render_template(
        'book/new.html',
        genres=genres
        )

@bp.route('/<int:book_id>/reviews')
@check_rights('reviews')
def reviews(book_id):
    book = db.session.query(Book).get_or_404(book_id)
    genres = db.session.query(Genre).join(GenreBook).filter(GenreBook.book_id == book.id).all()
    review = db.session.query(Review).filter_by(book_id=book_id, user_id=current_user.id).first()
    reviews = db.session.query(Review).filter_by(book_id=book_id).order_by(Review.date_added.desc()).all()
    return render_template('book/reviews.html', book=book, genres=genres, review = review, reviews=reviews)

@bp.route('/create', methods=['POST'])
@check_rights('create')
@login_required
def create():  
    if request.method == "POST":
        name = request.form['name']
        author = request.form['author']
        created_year = request.form['created']
        publish = request.form['publish']
        pages_count = int(request.form['pagescount'])
        short_desc = bleach.clean(request.form['short_desc'])
        genres = request.form.getlist('genres')
        background_img = request.files['background_img']
        try:     
            skin_saver = OblojkaSaver(background_img)
            skin = skin_saver.save()
            
            book = Book(
                name=name,
                author=author,
                created_year=created_year,
                publish=publish,
                pages_count=pages_count,
                short_desc=short_desc,
                skin_id=skin.id
            )
            db.session.add(book)
            db.session.flush()
            
            if not genres:
                flash('Необходим выбор жанра', 'warning')
                return render_template('new.html', genres=db.session.query(Genre).all())
            
            for genre_id in genres:
                genre = db.session.query(Genre).get(genre_id)
                if genre:
                    genrebook = GenreBook(
                        book_id=book.id,
                        genre_id=genre_id
                    )
                db.session.add(genrebook)
            
            db.session.commit()
            flash('Книга добавлена', 'success')
            return redirect(url_for('book.show',book_id=book.id))
        
        except Exception as err:
            db.session.rollback()
            flash(f'Ошибка добавления книги в базу: {err}', 'danger')
            return render_template('book/new.html', genres=db.session.query(Genre).all())
    return redirect(url_for('index'))

@bp.route('/show/<int:book_id>', methods=['GET', 'POST'])
@login_required
def show(book_id):   
    book = db.session.query(Book).get_or_404(book_id)
    genres = db.session.query(Genre).join(GenreBook).filter(GenreBook.book_id == book.id).all()
    review = db.session.query(Review).filter_by(book_id=book_id, user_id=current_user.id).first()
    reviews = db.session.query(Review).filter_by(book_id=book_id).order_by(Review.date_added.desc()).all()
    return render_template('book/show.html', book=book, genres=genres, review = review, reviews=reviews)


@bp.route('/images/<skin_id>')
def skin(skin_id):
    img = db.get_or_404(Oblojka, skin_id)
    return send_from_directory(bp.config['UPLOAD_FOLDER'], img.filename)

@bp.route('/<int:book_id>', methods=['POST'])
@login_required
def add_review(book_id):
    text = bleach.clean(request.form["reviewBody"])
    rating = int(request.form["rating"])
    try:
        review = Review(
            rating=rating,
            text=text, 
            book_id=book_id, 
            user_id=current_user.id
            )

        book = db.get_or_404(Book, book_id)
        book.rating_sum += rating
        book.rating_num += 1
        db.session.add(review)
        db.session.commit()
    except Exception as err:
        flash(f'Возникла ошибка при записи данных в БД. Проверьте введенные данных. ({err})', 'danger')
        db.session.rollback()
    return redirect(url_for('book.show', book_id=book.id))


@bp.route('/edit/<int:book_id>', methods=["GET", "POST"])
@login_required
@check_rights('edit')
def edit(book_id):
    book = db.session.query(Book).get_or_404(book_id)
    genres_main = db.session.query(Genre).all()
    
    if request.method == "POST":
        try:
            book.name = request.form['name']
            book.author = request.form['author']
            book.created_year = request.form['created']
            book.publish = request.form['publish']
            book.pages_count = int(request.form['pagescount'])
            book.short_desc = bleach.clean(request.form['short_desc'])
            genres = request.form.getlist('genres')
            db.session.query(GenreBook).filter_by(book_id=book.id).delete()

            if not genres:
                flash('Выберети жанр', 'warning')
                return render_template('edit.html', genres=db.session.query(Genre).all())
            
            for genre_id in genres:
                genre = db.session.query(Genre).get(genre_id)
                if genre:
                    genrebook = GenreBook(
                        book_id=book.id,
                        genre_id=genre_id
                    )
                db.session.add(genrebook)
            
            db.session.commit()
            flash('Книга добавлена', 'success')
            return redirect(url_for('index'))
        
        except Exception as err:
            db.session.rollback()
            flash(f'Ошибка редактирования: {err}', 'danger')
            return render_template('book/edit.html', book=book, genres=genres_main)
    
    return render_template('book/edit.html', book=book, genres=genres_main)

@bp.route('/<int:book_id>/delete', methods=["GET", "POST"])
@login_required
@check_rights('delete')
def delete(book_id):
    book = db.session.execute(db.select(Book).filter_by(id=book_id)).scalars().first()
    skin = db.session.execute(db.select(Oblojka).filter_by(id=book.skin_id)).scalars().first()
    skin_filename = skin.filename
    try:
        db.session.query(Review).filter_by(book_id=book.id).delete()
        db.session.delete(book)
        db.session.delete(skin)
        db.session.commit()
        OblojkaSaver.drop_skin(skin_filename)
    except SQLAlchemyError as err:
        flash(f'Ошибка удаления: {err}', 'danger')
        return redirect(url_for('index')) 
    
    return redirect(url_for('index'))

