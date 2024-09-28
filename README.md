# Clinic Data Migrator

## Get Started

**Assumed to run on M1 MacBook.**

Clone this repository.

```
git clone git@github.com:yutakusuno/clinic-data-migrator.git
cd clinic-data-migrator
```

Boost your docker desktop and build the docker images:

```
docker compose -f compose.dev.yaml build
```

Boot the app:

```
docker compose -f compose.dev.yaml up -d
```

Create the database:

```
docker compose -f compose.dev.yaml exec app bundle exec rake db:create
```

After following these steps, you can access the app server at http://localhost:3000/.

Stop the application:

```
docker compose -f compose.dev.yaml down
```
