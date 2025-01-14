# Docker
Run once `request_reports.py` to get `auth.json`
In folder `keys` add yours keys

build image 
```bash
docker build -t findmy .
```

run docker 
```bash
docker run -d \
  --name findmy \
  --env ANISETTE_URL=http://192.168.1.134:6969 \
  --env CONFIG_PATH=/auth.json \
  --volume ./keys/:/keys \
  --volume /auth.json:/auth.json \
  --publish 8126:8126 \
  --restart unless-stopped \
  findmy
```

or with docker-compose.yaml
```
version: "3.0"
services:
  findmy:
    image: findmy
    environment:
      - TZ=Europe/Paris
      - ANISETTE_URL=http://192.168.1.134:6969
      - CONFIG_PATH=/auth.json
    volumes:
      - ./keys/:/keys
      - ./auth.json:/auth.json
    ports:
      - 8126:8126
    restart: unless-stopped
```

Follow url http://127.0.0.1:8126

# FindMy
Query Apple's Find My network, based on all the hard work of https://github.com/seemoo-lab/openhaystack/ and @hatomist and @JJTech0130 and @Dadoum.

This is version 2, which does not require a Mac anymore thanks to the awesome work in https://github.com/JJTech0130/pypush.
Version 1 that can be run on Macs can still be found in the catalina (python2) and monterey (python3) branches.

## Installation and initial setup
Only a free Apple ID is required, with SMS 2FA properly setup. If you don't have any, follow one of the many guides found on the internet.

1. Clone this repository and `anisette-v3-server`:
```bash
git clone https://github.com/biemster/FindMy
git clone https://github.com/Dadoum/anisette-v3-server
```
2. Follow the installation instructions for `anisette-v3-server` and make sure it works.
3. Create the database where the reports will be stored:
```bash
sqlite3 reports.db 'CREATE TABLE reports (id_short TEXT, timestamp INTEGER, datePublished INTEGER, payload TEXT, id TEXT, statusCode INTEGER, PRIMARY KEY(id_short,timestamp))'
```

## Run
1. `cd` into the `FindMy` directory and generate keys using `./generate_keys.py`.
2. Deploy your advertisement keys on devices supported by OpenHaystack. The ESP32 firmware is a mirror of the OpenHaystack binary, the Lenze 17H66 is found in many 1$ tags obtained from Ali.
An nRF51 firmware can be found here: https://github.com/dakhnod/FakeTag
3. run
```bash
../anisette-v3-server/anisette-v3-server & ./request_reports.py ; killall anisette-v3-server
```
in the same directory as your `.keys` files.

Alternatively to step 3 you could install `https://github.com/Dadoum/pyprovision` (first install `anisette-v3-server` though to get a nice D environment and the required android libs),
make a folder `anisette` in your working directory and just run
```bash
./request_reports.py
```
The script should pick up the python bindings to provision and use that instead.

This current non-Mac workflow is not optimal yet, mainly because the anisette server is a bit of a workaround. A python solution for retrieving this is being
developed in the pypush discord, please join there if you want to contribute!
