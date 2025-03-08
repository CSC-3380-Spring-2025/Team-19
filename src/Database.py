from flask import Flask, request, jsonify
import psycopg2
import bcrypt

# This file is to ensure that database tables are set up correctly and exist.

# Database connection
conn = psycopg2.connect(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="1234",
    port=5432
)
cur = conn.cursor()

# Create users table if not exists
cur.execute("""
    CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        username VARCHAR(255) UNIQUE NOT NULL,
        password_hash TEXT NOT NULL
    )
""")
conn.commit()

