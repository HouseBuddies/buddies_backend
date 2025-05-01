[asdf-vm]: https://asdf-vm.com/

# Buddies (backend ⚙️)

Find your perfect house buddies! 🏠

## Setup and running 🚀

### 🐳 Database (with docker)

For data persistence this project uses a PostgreSQL database. You should have
PostgreSQL up and running.

If you want to setup the required database using docker containers you can
easily do it with [docker-compose](https://docs.docker.com/compose/install/).

Create and start the database containers. You should use `linux.yml` if running on Linux and `darwin.yml` if running on macOS.

```
cp .env.dev.sample .env.dev
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml up db
```

Start the previously created containers.

```
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml start
```

Stop the containers.

```
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml stop
```

Destroy the containers and volumes created.

```
docker-compose -f docker-compose.dev.yml -f {linux,darwin}.yml down -v
```

### 🐦‍🔥 Server

The following software is required to be installed on your system:

- [Erlang 26+](https://www.erlang.org/downloads)
- [Elixir 1.17+](https://elixir-lang.org/install.html)

We recommend using [asdf version manager][asdf-vm] to install and manage all
the programming languages' requirements.

Firstly, fetch all required dependencies:

```
mix deps.get
```

Secondly, setup the database:
```
mix ecto.setup
```

And lastly, run the application:
```
mix phx.server
```

