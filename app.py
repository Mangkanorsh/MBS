from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
import MySQLdb.cursors
import re
from datetime import datetime
from decimal import Decimal
import uuid


app = Flask(__name__)
app.config.from_object('config.Config')

mysql = MySQL(app)




@app.route('/')
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
        user = cursor.fetchone()
        if user and check_password_hash(user['password'], password):
            session['loggedin'] = True
            session['id'] = user['id']
            session['username'] = user['username']
            session['is_admin'] = user['is_admin']
            if user['is_admin']:
                return redirect(url_for('admin'))
            else:
                return redirect(url_for('user'))
        else:
            flash('Invalid login credentials', 'danger')
    return render_template('login.html')

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if 'loggedin' in session and session['is_admin']:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM movies')
        movies = cursor.fetchall()
        return render_template('admin.html', movies=movies)
    return redirect(url_for('login'))

@app.route('/add_movie', methods=['GET', 'POST'])
def add_movie():
    if 'loggedin' in session and session['is_admin']:
        if request.method == 'POST':
            title = request.form['title']
            description = request.form['description']
            genre = request.form['genre']
            film_rating = request.form['film_rating']
            duration = request.form['duration']
            cast = request.form['cast']
            start_date = request.form['start_date']
            end_date = request.form['end_date']
            image = request.files['image']
            image.save(f'static/images/{image.filename}')
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('''INSERT INTO movies (title, description, genre, film_rating, duration, cast, image, start_date, end_date)
                              VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)''', 
                           (title, description, genre, film_rating, duration, cast, image.filename, start_date, end_date))
            mysql.connection.commit()
            flash('Movie added successfully!', 'success')
            return redirect(url_for('admin'))
        return render_template('add_movie.html')
    return redirect(url_for('login'))

@app.route('/edit_movie/<int:movie_id>', methods=['GET', 'POST'])
def edit_movie(movie_id):
    if 'loggedin' in session and session['is_admin']:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        if request.method == 'POST':
            title = request.form['title']
            description = request.form['description']
            genre = request.form['genre']
            film_rating = request.form['film_rating']
            duration = request.form['duration']
            cast = request.form['cast']
            start_date = request.form['start_date']
            end_date = request.form['end_date']
            image = request.files['image']
            if image:
                image.save(f'static/images/{image.filename}')
                cursor.execute('''UPDATE movies SET title = %s, description = %s, genre = %s, film_rating = %s, duration = %s, cast = %s, image = %s, start_date = %s, end_date = %s WHERE id = %s''',
                               (title, description, genre, film_rating, duration, cast, image.filename, start_date, end_date, movie_id))
            else:
                cursor.execute('''UPDATE movies SET title = %s, description = %s, genre = %s, film_rating = %s, duration = %s, cast = %s, start_date = %s, end_date = %s WHERE id = %s''',
                               (title, description, genre, film_rating, duration, cast, start_date, end_date, movie_id))
            mysql.connection.commit()
            flash('Movie updated successfully!', 'success')
            return redirect(url_for('admin'))
        cursor.execute('SELECT * FROM movies WHERE id = %s', (movie_id,))
        movie = cursor.fetchone()
        return render_template('edit_movie.html', movie=movie)
    return redirect(url_for('login'))

@app.route('/delete_movie/<int:movie_id>', methods=['POST'])
def delete_movie(movie_id):
    if 'loggedin' in session and session['is_admin']:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('DELETE FROM movies WHERE id = %s', (movie_id,))
        mysql.connection.commit()
        flash('Movie deleted successfully!', 'success')
        return redirect(url_for('admin'))
    return redirect(url_for('login'))

@app.route('/user', methods=['GET', 'POST'])
def user():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM movies WHERE start_date <= %s AND end_date >= %s', (datetime.now(), datetime.now()))
        movies = cursor.fetchall()
        return render_template('user.html', movies=movies)
    return redirect(url_for('login'))

def generate_seat_coordinates(rows=10, cols=10):
    seats = []
    for row in range(rows):
        seat_row = []
        for col in range(cols):
            letter = chr(ord('A') + col) 
            number = 10 - row 
            coordinate = f"{letter}{number}"
            seat_row.append(coordinate)
        seats.append(seat_row)
    return seats

@app.route('/book_movie/<int:movie_id>', methods=['GET', 'POST'])
def book_movie(movie_id):
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Fetch the movie details to display on the booking page
        cursor.execute('SELECT * FROM movies WHERE id = %s', (movie_id,))
        movie = cursor.fetchone()

        # Fetch user details to check for PWD or senior status
        cursor.execute('SELECT is_pwd, is_senior FROM users WHERE id = %s', (session['id'],))
        user = cursor.fetchone()
        is_eligible_for_discount = user['is_pwd'] == 1 or user['is_senior'] == 1

        if request.method == 'POST':
            timeslot = request.form['timeslot']
            date = request.form['date']
            selected_seats = request.form.get('seats').split(',')
            seat_quantity = len(selected_seats)
            
            # Check if selected seats are available
            cursor.execute('SELECT seats FROM bookings WHERE movie_id = %s AND date = %s AND timeslot = %s', (movie_id, date, timeslot,))
            taken_seats = set()
            for booking in cursor.fetchall():
                taken_seats.update(booking['seats'].split(','))
            
            available_seats = [seat for seat in selected_seats if seat not in taken_seats]

            if len(available_seats) > 0:
                # Calculate price per seat with discount if customer is PWD or senior
                price_per_seat = movie['price']
                if is_eligible_for_discount:
                    price_per_seat -= (price_per_seat * Decimal(0.2))  # Apply 20% discount

                # Calculate total price
                total_price = price_per_seat * seat_quantity

                # Insert booking into the database
                cursor.execute(
                    'INSERT INTO bookings (user_id, movie_id, movie_title, date, timeslot, seats, seat_quantity, total_price) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
                    (session['id'], movie_id, movie['title'], date, timeslot, ','.join(available_seats), seat_quantity, total_price)
                )
                mysql.connection.commit()
                flash('Booking successful!', 'success')
                return redirect(url_for('cart', price=total_price))
            else:
                flash('Selected seats are not available. Please choose other seats.', 'danger')

        # Fetch existing bookings for the selected movie
        cursor.execute('SELECT seats FROM bookings WHERE movie_id = %s', (movie_id,))
        all_bookings = cursor.fetchall()

        # Create a set of taken seats
        taken_seats = set()
        for booking in all_bookings:
            taken_seats.update(booking['seats'].split(','))

        # Generate seat coordinates
        seat_coordinates = generate_seat_coordinates()

        return render_template('book_movie.html', movie=movie, taken_seats=taken_seats, seat_coordinates=seat_coordinates)
    
    return redirect(url_for('login'))


@app.route('/view_booked_movies', methods=['GET'])
def view_booked_movies():
    if 'loggedin' in session or session['is_admin']:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # Assuming 'status' is a column that indicates payment status
        cursor.execute('''
            SELECT b.id, m.title, b.date, b.timeslot, b.seats, b.total_price 
            FROM bookings b 
            JOIN movies m ON b.movie_id = m.id 
            WHERE b.status = 'paid'
        ''')
        booked_movies = cursor.fetchall()
        return render_template('view_booked_movies.html', booked_movies=booked_movies)
    return redirect(url_for('login'))


@app.route('/cart', methods=['GET', 'POST'])
def cart():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # Fetch only unpaid bookings for the current user
        cursor.execute('''
            SELECT b.id AS booking_id, m.title, b.timeslot, b.date, b.seats, b.total_price 
            FROM bookings b 
            JOIN movies m ON b.movie_id = m.id 
            WHERE b.user_id = %s AND b.status = %s
        ''', (session['id'], 'unpaid'))
        bookings = cursor.fetchall()

        total_amount = 0
        for booking in bookings:
            if booking['total_price'] is not None:
                total_amount += float(booking['total_price'])

        return render_template('cart.html', bookings=bookings, total_amount=total_amount)
    return redirect(url_for('login'))


@app.route('/cancel_booking/<int:booking_id>', methods=['POST'])
def cancel_booking(booking_id):
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('DELETE FROM bookings WHERE id = %s AND user_id = %s', (booking_id, session['id']))
        mysql.connection.commit()
        flash('Booking canceled successfully!', 'success')
        return redirect(url_for('cart'))
    return redirect(url_for('login'))

@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        
        if request.method == 'POST':
            # Payment processing logic...
            # Assuming payment is successful for demonstration
            payment_success = True  

            if payment_success:
                # Fetch all unpaid bookings for the current user
                cursor.execute('SELECT * FROM bookings WHERE user_id = %s AND status = %s', (session['id'], 'unpaid'))
                unpaid_bookings = cursor.fetchall()

                if unpaid_bookings:
                    # Update the status of all unpaid bookings to 'paid'
                    cursor.execute('UPDATE bookings SET status = %s WHERE user_id = %s AND status = %s', ('paid', session['id'], 'unpaid'))
                    mysql.connection.commit()

                    # Generate random transaction ID
                    transaction_id = str(uuid.uuid4())  # Convert UUID to string
                    # Render receipt template
                    receipt_data = {
                        'transaction_id': transaction_id,
                        'date': datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Current date and time
                        # Add more data as needed
                    }
                    receipt_html = render_template('receipt.html', **receipt_data)
                    return render_template('checkout.html', receipt_html=receipt_html)

                else:
                    flash('No unpaid bookings found.', 'danger')
            else:
                flash('Payment failed. Please try again.', 'danger')

        # Fetch unpaid bookings for display on the checkout page
        cursor.execute('SELECT * FROM bookings WHERE user_id = %s AND status = %s', (session['id'], 'unpaid'))
        bookings = cursor.fetchall()
        total_amount = sum(float(booking['total_price']) for booking in bookings)

        return render_template('checkout.html', bookings=bookings, total_amount=total_amount)
    
    return redirect(url_for('login'))


@app.route('/print_receipt/<int:booking_id>', methods=['POST'])
def print_receipt(booking_id):
    # Fetch booking details using the booking_id
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM bookings WHERE id = %s', (booking_id,))
    booking = cursor.fetchone()

    # Render the receipt template with booking details
    receipt_data = {
        'transaction_id': str(uuid.uuid4()),  # Generate a random transaction ID
        'date': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),  # Current date and time
        'booking': booking  # Pass booking details to the receipt template
        # Add more data as needed
    }
    receipt_html = render_template('receipt.html', **receipt_data)
    
    # Return the receipt HTML
    return receipt_html


@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'loggedin' in session:
        if request.method == 'POST':
            email = request.form['email']
            password = request.form['password']
            if password:
                hashed_password = generate_password_hash(password)
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('UPDATE users SET email = %s, password = %s WHERE id = %s', (email, hashed_password, session['id']))
            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('UPDATE users SET email = %s WHERE id = %s', (email, session['id']))
            mysql.connection.commit()
            flash('Profile updated successfully!', 'success')
            return redirect(url_for('profile'))
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM users WHERE id = %s', (session['id'],))
        user = cursor.fetchone()
        return render_template('profile.html', user=user)
    return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    session.pop('is_admin', None)
    return redirect(url_for('login'))

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        confirm_password = request.form['confirm_password']
        email = request.form['email']
        is_pwd = request.form.get('is_pwd', '0')  # Default value if checkbox is not checked
        is_senior = request.form.get('is_senior', '0')  # Default value if checkbox is not checked

        # Make sure is_pwd and is_senior are converted to integers
        is_pwd = int(is_pwd)
        is_senior = int(is_senior)

        if password != confirm_password:
            flash('Passwords do not match!', 'danger')
            return redirect(url_for('signup'))
        hashed_password = generate_password_hash(password)
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('INSERT INTO users (username, password, email, is_admin, is_pwd, is_senior) VALUES (%s, %s, %s, %s, %s, %s)', (username, hashed_password, email, False, is_pwd, is_senior))
        mysql.connection.commit()
        flash('You have successfully signed up!', 'success')
        return redirect(url_for('login'))
    return render_template('signup.html')


if __name__ == '__main__':
    app.run(debug=True)
