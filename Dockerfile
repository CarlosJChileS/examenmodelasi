# ----------- Etapa 1: Build frontend Next.js -----------
FROM node:20-alpine as frontend

WORKDIR /app
COPY agent-ui ./agent-ui

WORKDIR /app/agent-ui
RUN npm install --legacy-peer-deps
RUN npm run build || true
RUN npm run export || true

# ----------- Etapa 2: Imagen final con backend y nginx -----------
FROM python:3.11-slim

WORKDIR /app

# Instala Nginx y herramientas necesarias
RUN apt-get update && apt-get install -y nginx curl

# Copia backend
COPY playground.py .
COPY requirements.txt .

# Copia frontend exportado como estático
RUN mkdir /app/frontend
COPY --from=frontend /app/agent-ui/out /app/frontend

# Copia configuración de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copia script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Crea y activa entorno virtual + instala deps + API key
RUN python -m venv aienv && \
    . aienv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    echo "export GROQ_API_KEY='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'" >> aienv/bin/activate

EXPOSE 8080

CMD ["/start.sh"]
