# docker-redis-cluster
Docker image with redis built and installed from source.

The main usage for this container is to test redis cluster code. For example in https://github.com/Grokzen/redis-py-cluster repo.

The cluster is 6 redis instances running with 3 master & 3 slaves, one slave for each master. They run on ports 7000 to 7005.

It also contains 2 standalone instances that is not part of the cluster. They are running on port 7006 & 7007

This image requires at least `Docker` version 1.10 but the latest version is recommended.


# Usage

To build your own image run:

    make build

And to run the container use:

    make up

    # and top stop the container run

    make down

To connect to your cluster you can use the redis-cli tool:

    redis-cli -c -p 7000

    # or the built redis-cli tool inside the container

    make cli


## Omit standalone redis instances

Set env variable CLUSTER_ONLY=true.

* Running with docker compose, modify docker-compose file

      version: '2'
      services:
        redis-cluster:
          build:
            context: .
            args:
              redis_version: '4.0.9'
          hostname: server
        environment:
          CLUSTER_ONLY: 'true'

* Running with docker directly add:

      docker run ... -e CLUSTER_ONLY=true ...


## Build alternative redis versions

For a release to be buildable it needs to be present at this url: http://download.redis.io/releases/


### docker build

To set a different redis version use the argument --build-arg

    # Example
    docker build --build-arg redis_version=3.2.0 -t reidddd/redis-cluster .


### docker-compose

To set a different redis version you must change the variable 'redis_version' inside the docker-compose file.

Then you simply rebuild the compose file and it should be updated with the desired redis version.


# Available tags

The following tags with pre-built images is available on `docker-hub`.

Latest release in the most recent stable branch will be used as `latest` version.

- latest == 4.0.9

Redis 5.0.x version:

- 5.0-rc3
- 5.0-rc2
- 5.0-rc1

Redis 4.0.x versions:

- 4.0.10
- 4.0.9
- 4.0.8
- 4.0.7
- 4.0.6
- 4.0.5
- 4.0.4
- 4.0.3
- 4.0.2
- 4.0.1
- 4.0.0

Redis 3.2.x versions:

- 3.2.12
- 3.2.11
- 3.2.10
- 3.2.9
- 3.2.8
- 3.2.7
- 3.2.6
- 3.2.5
- 3.2.4
- 3.2.3
- 3.2.2
- 3.2.1
- 3.2.0

Redis 3.0.x versions:

- 3.0.7
- 3.0.6
- 3.0.5
- 3.0.4
- 3.0.3
- 3.0.2
- 3.0.1
- 3.0.0


# License

This repo is using the MIT LICENSE.

You can find it in the file [LICENSE](LICENSE)
