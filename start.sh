#!/bin/bash

# 1. Activar entorno virtual con API keys ya insertadas
source ./aienv/bin/activate

# 2. Iniciar backend Python (en segundo plano)
uvicorn playground:app --host 0.0.0.0 --port 7777 &

# 3. Servir frontend en 8080
npx serve -s . -l 8080
