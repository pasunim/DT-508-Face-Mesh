FROM python:3.14-slim

WORKDIR /app

# mediapipe/opencv ต้องการไลบรารีระบบเหล่านี้ในการรันบน Linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock ./

RUN pip install --no-cache-dir uv \
    && uv sync --frozen --no-dev

COPY main.py ./
COPY templates ./templates
COPY static ./static

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 5000

CMD ["python", "main.py"]
