FROM python:3.9-slim

# Set up a non-root user
RUN useradd -m appuser

WORKDIR /app

# Ensure appuser owns the /app directory
RUN chown -R appuser:appuser /app

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt /app/requirements.txt

# Switch to non-root user
USER appuser

# Install dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the application
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]