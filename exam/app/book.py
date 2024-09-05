from flask import render_template, request, redirect, url_for, flash, Blueprint
from flask_login import login_required
from app import db
from auth import check_rights
from flask_login import login_required
import mysql.connector

bp_book = Blueprint('book', __name__, url_prefix='/book')


def get_Knigi_janr(kniga_id):
    
    query = """
    SELECT g.name 
    FROM janr g 
    JOIN Knigi_janr gb ON g.id = gb.janr_id 
    WHERE gb.kniga_id = %s
    """
    cursor = db.connection().cursor(named_tuple=True)
    cursor.execute(query, (kniga_id,))
    genres = [row[0] for row in cursor.fetchall()]
    
    cursor.close()
    return genres

def get_janr():
    query = 'SELECT * FROM janr'
    cursor = db.connection().cursor(named_tuple=True)
    cursor.execute(query)
    roles = cursor.fetchall()
    cursor.close()
    return roles

def get_kniga(kniga_id):
    query = 'SELECT * FROM knigi WHERE id=%s'
    cursor = db.connection().cursor(named_tuple=True)
    cursor.execute(query, (kniga_id,))
    book = cursor.fetchone()
    cursor.close()
    return book

@bp_book.route('/create', methods = ['POST', 'GET'])
@login_required
@check_rights('create')
def create():
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        year = request.form['year']
        publish = request.form['publish']
        author = request.form['author']
        pages = request.form['pages']
        genres = request.form.getlist('genres')

        try:
            with db.connection().cursor(named_tuple=True) as cursor:
                query = "INSERT INTO knigi (name, description, year, publish, author, pages) VALUES (%s, %s, %s, %s, %s, %s)"
                cursor.execute(query, (name, description, year, publish, author, pages))
                db.connection().commit()

                if not genres:
                    flash('Выберите жанр', 'warning')
                    return render_template('edit.html', genres=get_janr())

                query = "SELECT id FROM knigi where name=%s and description=%s"
                cursor.execute(query, (name, description, ))
                book_id = cursor.fetchone()

                for genre_id in genres:
                    query = "INSERT INTO Knigi_janr (kniga_id, janr_id) VALUES (%s, %s)"
                    cursor.execute(query, (book_id[0], genre_id,))
                    db.connection().commit()

                flash(f'Книга {name} добавлена.', 'success')
        except mysql.connector.errors.DatabaseError as e:
            db.connection().rollback()
            flash(f'При добавлении произошла ошибка: {e}', 'danger')
            return render_template('book/create.html')

    return render_template('book/create.html', genres=get_janr())

@bp_book.route('/show/<int:kniga_id>')
@login_required
@check_rights('show')
def show(kniga_id):
    querry = 'SELECT * FROM knigi WHERE knigi.id=%s'
    with db.connection().cursor(named_tuple=True) as cursor:
        cursor.execute(querry, (kniga_id,))
        book = cursor.fetchone()
    return render_template('book/show.html', book = book, genres = get_Knigi_janr(kniga_id))

@bp_book.route('/edit/<int:kniga_id>', methods=["POST", "GET"])
@login_required
@check_rights('edit')
def edit(kniga_id):
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        year = request.form['year']
        publish = request.form['publish']
        author = request.form['author']
        pages = request.form['pages']
        genres = request.form.getlist('genres')
        
        try:
            with db.connection().cursor(named_tuple=True) as cursor:
                query = '''
                UPDATE knigi set name = %s, description = %s, year = %s, publish = %s, author = %s, pages = %s where id = %s
                '''
                cursor.execute(query, (name, description, year, publish, author, pages, kniga_id,))
                db.connection().commit()
                
                if not genres:
                    flash('Выберите жанр', 'warning')
                    return render_template('book/edit.html', book = get_kniga(kniga_id), genres = get_janr())
                
                query = "DELETE FROM Knigi_janr WHERE kniga_id = %s"
                cursor.execute(query, (kniga_id,))
                db.connection().commit()

                for genre_id in genres:
                    query = "INSERT INTO Knigi_janr (kniga_id, janr_id) VALUES (%s, %s)"
                    cursor.execute(query, (kniga_id, genre_id,))
                    db.connection().commit()

                flash(f'Книга {name} успешно', 'success')
                return render_template('book/edit.html', book=get_kniga(kniga_id), genres=get_janr())

        except mysql.connector.errors.DatabaseError as err:
            db.connection().rollback()
            flash(f'При редактировании произошла ошибка.{err}', 'danger')
            
            return render_template('book/edit.html', book = get_kniga(kniga_id), genres = get_janr())
        
    return render_template('book/edit.html', book = get_kniga(kniga_id), genres = get_janr())

@bp_book.route('/delete')  
@login_required  
@check_rights('delete')  
def delete():
    genres = request.form.getlist('genres')
    page = int(request.args.get('page', 1))
    count = 0
    try:  
        book_id = request.args.get('book_id')
        with db.connection().cursor(named_tuple=True) as cursor:
            querry = "DELETE FROM knigi WHERE id = %s"
            cursor.execute(querry, (book_id,))  
            db.connection().commit()

            for genre_id in genres:
                query = "DELETE FROM Knigi_janr WHERE kniga_id = %s AND janr_id = %s"
                cursor.execute(query, (book_id, genre_id,))
                db.connection().commit()

        flash(f'Книга успешно удалена.', 'success')  

    except mysql.connector.errors.DatabaseError as err:  
        db.connection().rollback()  
        flash(f'При удалении произошла ошибка.{err}', 'danger')  
        return render_template('index.html', book=get_kniga(book_id), genres=get_janr(), page=page, count=count)
  
    return redirect(url_for('index'))