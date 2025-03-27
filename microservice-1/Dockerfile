FROM python:3.9-slim

# Set up a non-root user
RUN useradd -m appuser

WORKDIR /app

# Ensure appuser owns the /app directory
RUN chown -R appuser:appuser /app

COPY requirements.txt requirements.txt

# Switch to non-root user
USER appuser

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]