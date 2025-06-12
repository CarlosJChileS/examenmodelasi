# ---------- Etapa 1: Build del frontend (Next.js) ----------
FROM node:20-alpine as frontend

WORKDIR /app
COPY agent-ui ./agent-ui

WORKDIR /app/agent-ui
RUN npm install --legacy-peer-deps
RUN npm run build

# ---------- Etapa 2: Imagen final (Python + frontend) ----------
FROM python:3.11-slim

WORKDIR /app

# Instala dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia backend
COPY playground.py .

# Copia el frontend estático compilado (Next.js exporta en .next o out)
COPY --from=frontend /app/agent-ui/.next ./.next
COPY --from=frontend /app/agent-ui/public ./public
COPY --from=frontend /app/agent-ui/package.json .
COPY --from=frontend /app/agent-ui/next.config.js .
# (Copia otros archivos config si tu Next.js los requiere)

# Instala dependencias para servir frontend estático (opcional, si usas 'serve')
RUN pip install --no-cache-dir fastapi uvicorn python-multipart
RUN pip install --no-cache-dir aiofiles

# Exponer el puerto de backend
EXPOSE 7777

# ---- Start script para servir ambos ----
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
