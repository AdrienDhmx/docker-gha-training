FROM python:alpine

WORKDIR /src

COPY requirements.txt ./
RUN pip install -r requirements.txt

EXPOSE 5000

COPY . .

CMD [ "python", "app/main.py" ]