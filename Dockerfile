FROM python:3.11-slim

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update
RUN apt-get install -y sqlite3 git dub gcc make

RUN git clone https://github.com/Dadoum/pyprovision.git
RUN git clone https://github.com/Dadoum/plist.git
WORKDIR /usr/src/app/pyprovision/pyprovision
RUN dub add-local /usr/src/app/plist
WORKDIR /usr/src/app/pyprovision
RUN python -m pip install .

RUN sqlite3 reports.db 'CREATE TABLE reports (id_short TEXT, timestamp INTEGER, datePublished INTEGER, payload TEXT, id TEXT, statusCode INTEGER, PRIMARY KEY(id_short,timestamp))'

WORKDIR /usr/src/app/
RUN mkdir /usr/src/app/anisette

COPY . .

CMD [ "python", "main.py" ]