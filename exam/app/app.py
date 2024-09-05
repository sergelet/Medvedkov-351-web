from flask import Flask, render_template, request, flash
from flask_login import  current_user
from sql import MySQL
import mysql.connector
import math

app = Flask(__name__)
app.static_folder = 'static'
application = app

app.config.from_pyfile('config.py')

db = MySQL(app)

from auth import bp_auth, init_login_manager
from book import *

app.register_blueprint(bp_auth)
app.register_blueprint(bp_book)

app.jinja_env.globals.update(current_user=current_user)

init_login_manager(app)

PER_PAGE = 4


@app.route('/')
def index():
    books=[]
    count = 0
    query1 = '''
        SELECT COUNT(*) AS book_count
        FROM knigi;
    '''
    page = int(request.args.get('page', 1))
    cursor = db.connection().cursor(named_tuple=True)
    cursor.execute(query1, )
    count = cursor.fetchone()[0]    

    query2 = '''
        SELECT b.*, GROUP_CONCAT(g.name SEPARATOR ', ') AS janr
        FROM knigi b
        LEFT JOIN Knigi_janr bg ON b.id = bg.kniga_id
        LEFT JOIN janr g ON bg.janr_id = g.id
        GROUP BY b.id
        ORDER BY b.year DESC
        LIMIT %s OFFSET %s;
    '''

    try:
        cursor = db.connection().cursor(named_tuple=True)
        params = (PER_PAGE, PER_PAGE * (page - 1))
        cursor.execute(query2, params)
        books = cursor.fetchall()
        cursor.close()
        count = math.ceil(count / PER_PAGE)
    except mysql.connector.errors.DatabaseError:
        db.connection().rollback()
        flash('Произошла ошибка загрузки', 'danger')
    return render_template('index.html', books=books, count=count, page=page)