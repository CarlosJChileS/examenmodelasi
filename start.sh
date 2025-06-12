#!/bin/bash

# 1. Activa entorno virtual
source ./aienv/bin/activate

# 2. Inicia backend Python en 7777 (background)
uvicorn playground:app --host 0.0.0.0 --port 7777 &

# 3. Inicia servidor Nginx (foreground)
nginx -g 'daemon off;'
