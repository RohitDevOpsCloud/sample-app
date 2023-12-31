FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN pip install --trusted-host pypi.python.org -r req.txt

EXPOSE 5000

CMD ["python", "app.py", "runserver", "0.0.0.0:5000"] 
