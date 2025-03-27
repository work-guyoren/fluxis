FROM python:3.9-slim

# Set up a non-root user
RUN useradd -m appuser

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Change ownership to the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

CMD ["python", "app.py"]