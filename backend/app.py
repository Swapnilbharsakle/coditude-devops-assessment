import os
from fastapi import FastAPI

app = FastAPI(title="Coditude Assessment API", version="1.0.0")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/api/info")
def info():
    return {
        "service": "backend",
        "environment": os.getenv("APP_ENV", "local"),
        "database_configured": bool(os.getenv("DATABASE_URL")),
    }
