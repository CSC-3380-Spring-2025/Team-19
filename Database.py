import psycopg2

# Establishes connection
conn = psycopg2.connect(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="1234",
    port=5432
)
cur = conn.cursor()

#SQL Code
cur.execute("""
    CREATE TABLE IF NOT EXISTS person(
        id SERIAL PRIMARY KEY,
        name VARCHAR(255),
        password TEXT
    )
""")

# Commits changes and close connection
conn.commit()
cur.close()
conn.close()
