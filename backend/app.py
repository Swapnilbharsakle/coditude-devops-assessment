import os

from fastapi import FastAPI, HTTPException

app = FastAPI(title="Coditude Assessment API", version="1.0.0")


def database_connection_string() -> str | None:
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        return database_url

    host = os.getenv("DATABASE_HOST")
    user = os.getenv("DATABASE_USER")
    password = os.getenv("DATABASE_PASSWORD")
    database = os.getenv("DATABASE_NAME", "appdb")
    port = os.getenv("DATABASE_PORT", "5432")

    if not all([host, user, password]):
        return None

    return f"postgresql://{user}:{password}@{host}:{port}/{database}"


@app.get("/health")
def health():
    return {"status": "ok", "service": "backend"}


@app.get("/api/info")
def info():
    return {
        "service": "backend",
        "environment": os.getenv("APP_ENV", "local"),
        "database_configured": database_connection_string() is not None,
    }


@app.get("/api/db-check")
def db_check():
    connection_string = database_connection_string()
    if not connection_string:
        raise HTTPException(status_code=503, detail="Database configuration is missing")

    try:
        import psycopg
        with psycopg.connect(connection_string, connect_timeout=3) as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
                result = cursor.fetchone()
        return {"status": "ok", "database": result[0] == 1}
    except Exception as exc:
        raise HTTPException(status_code=503, detail="Database check failed") from exc
