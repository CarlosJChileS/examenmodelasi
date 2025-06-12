#!/bin/bash

# 1. Inicia backend Python usando el Python del entorno virtual, en segundo plano
./aienv/bin/python -m uvicorn playground:app --host 0.0.0.0 --port 7777 &

# 2. Inicia Nginx como proceso principal (foreground)
nginx -g 'daemon off;'
