# Download base image
FROM python:3.10.9-slim
# Copy source code
COPY ./main.sh /app
# Give Execution permissions
RUN chmod +x /app/main.sh
# Exec script
CMD sh /app/main.sh
