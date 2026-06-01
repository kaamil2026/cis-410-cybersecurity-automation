# REMEDIATION 1: Use a pinned, slim secure base image
FROM python:3.11-slim

WORKDIR /app

# REMEDIATION 2: Fix layer caching by handling dependencies first
COPY vulnerable_app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# REMEDIATION 3: Create a dedicated system non-root user and group
RUN groupadd -r -f appgroup && useradd -r -g appgroup appuser

# Copy application files and pass ownership to the new user
COPY vulnerable_app/ . 
RUN chown -R appuser:appgroup /app

EXPOSE 5000

# REMEDIATION 4: Drop root privileges down to the non-root user context
USER appuser

# Start the application from the root directory context
CMD ["python", "app.py"]
