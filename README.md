== Advantager

Install instructions

use the docker-docker-compose.[env-you-prefer].yml to define the ENV VARS
according to your needs:
```
DB_USER=example
DB_PASS=example
DB_NAME=example
DB_HOST=example

```

also check the Dockerfile[env-you-prefer] to ensure you have all the ENV VARS

Happy Path:

Create the image and run the container with docker-compose:

```
docker-compose -f docker-compose.development.yml up
```

This will run the redmine and db container

Go to `localhost:10083` (or the port you choose) and access the app.

