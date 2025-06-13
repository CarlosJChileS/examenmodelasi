#!/bin/bash
set -e

# 1. Inicia backend Python usando el entorno virtual (background)
./aienv/bin/python -m uvicorn playground:app --host 0.0.0.0 --port 7777 &

# 2. Inicia Nginx como proceso principal
nginx -g 'daemon off;'
