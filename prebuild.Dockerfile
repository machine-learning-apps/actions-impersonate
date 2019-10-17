  
FROM python:3-slim-stretch

RUN pip3 install requests github3.py jwt cryptography pyjwt

COPY app.py /

CMD python /app.py