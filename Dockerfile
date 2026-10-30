FROM python:3.11-slim

# تثبيت Tesseract مع حزمة اللغة العربية على مستوى النظام
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-ara \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=5000
EXPOSE 5000

# main.py هو ملف التطبيق (وليس app.py)
CMD ["sh", "-c", "gunicorn main:app --bind 0.0.0.0:${PORT} --timeout 120 --workers 1 --threads 4"]
