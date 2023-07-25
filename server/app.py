from flask import Flask, jsonify, request
import sqlite3
from werkzeug.security import generate_password_hash, check_password_hash
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['SECRET_KEY'] = 'anandbhaikasecret'

# Define the database schema as a string
SCHEMA = """
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    username TEXT
);
"""

def get_db_connection():
    conn = sqlite3.connect('users.db')
    conn.row_factory = sqlite3.Row
    return conn

def initialize_database():
    with get_db_connection() as conn:
        conn.execute(SCHEMA)
        conn.commit()

@app.route('/', methods=['GET'])
def server_status():
    return jsonify({'message': 'Server is up and running!'}), 200

@app.route('/api/v1/signup', methods=['POST'])
def signup():
    data = request.get_json()

    name = data['name']
    email = data['email']
    password = data['password']

    # name = data.get('name')
    # email = data.get('email')
    # password = data.get('password')

    if not name or not email or not password:
        return jsonify({'message': 'Please provide all the required fields.'}), 400

    hashed_password = generate_password_hash(password)
    with get_db_connection() as conn:
        email_exists = conn.execute('SELECT COUNT(*) FROM users WHERE email = ?', (email,)).fetchone()[0]
        if email_exists:
            return jsonify({'message': 'Email already exists. Please choose a different one.'}), 409

        # Add NULL for the username field in the INSERT statement
        conn.execute('INSERT INTO users (name, email, password, username) VALUES (?, ?, ?, NULL)',
                     (name, email, hashed_password))
        conn.commit()

    return jsonify({'message': 'Signup successful. You can now log in.'}), 201


@app.route('/api/v1/login', methods=['POST'])
def login():
    data = request.get_json()

    email = data['email']
    password = data['password']
    
    # email = data.get('email')
    # password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Please provide both email and password.'}), 400

    with get_db_connection() as conn:
        user = conn.execute('SELECT * FROM users WHERE email = ?', (email,)).fetchone()

    if user and check_password_hash(user['password'], password):
        # Return all the fields of the user in the response
        user_details = {
            'id': user['id'],
            'name': user['name'],
            'email': user['email'],
            'password': user['password'],
            # Add other user fields here if needed
        }
        return jsonify({'message': 'Login successful.', 'user': user_details}), 200
    else:
        return jsonify({'message': 'Invalid email or password. Please try again.'}), 401
    

@app.route('/api/v1/users', methods=['GET'])
def get_all_users():
    with get_db_connection() as conn:
        cursor = conn.execute('SELECT * FROM users')
        users = cursor.fetchall()
        # Convert the SQLite Row objects to dictionaries for JSON serialization
        users_list = [dict(user) for user in users]
    return jsonify({'users': users_list}), 200

# ipconfig-  192.168.0.109
if __name__ == '__main__':
    initialize_database()
    # app.run(debug=True)
    # app.run(host='192.168.0.109', port=5000, debug=True)
    app.run(host='0.0.0.0', port=5000, debug=True)
