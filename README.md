# Docker container for Waves testnet node 

[![](https://images.microbadger.com/badges/image/wavesplatform/docker-build-waves-testnet.svg)](https://microbadger.com/images/wavesplatform/docker-build-waves-testnet "Information about Docker image")

Waves is a decentralised platform that allows any user to issue, transfer, swap and trade custom blockchain tokens on an integrated peer-to-peer exchange.
You can find more information about Waves at [wavesplatform.com](http://wavesplatform.com/) and [GitHub](https://github.com/wavesplatform).

The Docker image allows you to build and run the latest version of Waves Testnet node software. Using this image you are able to build any branch of the Scorex or Waves Github repositories. 


## This image on Docker Hub

It is possible to download a prebuild Docker image from Docker Hub. To do so issue the command:

```
docker pull wavesplatform/build-waves-testnet:latest
```

After getting the image, you can run it.
You can provide the name of a Scorex branch to build as the first parmeter of `docker run` command (after name of image). Giving the second parameter you can specify the branch in Waves repository to build.
In case of not given names of branches the master branch of each project will be build.
The entry point script updates the Scorex and Waves repositories, switches to given branches and builds the lates versions of Scorex and Waves. 
On completing the build scipt starts the Waves with generated or provided configuration file.

Here is the example of using the container:

```
docker pull wavesplatform/docker-build-waves-testnet

docker run wavesplatform/docker-build-waves-testnet some-scorex-branch some-waves-branch

```

## Building a Docker image

### Prerequisites 

You need the latest version of Docker installed.

Please, follow installation istructions at [Docker Site](https://docs.docker.com/engine/installation/).

### Building image

In order to build a new Docker image execute the following commands:


Clone the project's repository:

```
git clone https://github.com/alexeykiselev/docker-build-waves-testnet.git
```

Get into project's directory:

```
cd docker-build-waves-testnet
```

Build an image with the following command:

```
docker build -t docker-build-waves-testnet .

```

### Running the image

List your Docker's images:

```
docker images
```

If you built the image by yourself it will have the name you gave to it (in our example it is 'waves-testnet'). If you have downloaded the image from Docker Hub it is tagged with 'wavesplatform/docker-build-waves-testnet:latest'.

To start a new Docker container, please, execute:

```
docker run --name docker-build-waves-testnet wavesplatform/docker-build-waves-testnet:latest

```

It is possible to provide a concrete version instead of 'latest'.

This image defines a storage volume in folder `/waves`. This folder is persisted on host drive. So, your node configuration and downloaded blockchain will survive the container restart. You can find the location of this volume on a host computer using `docker inspect` command.

Alternatively you can map the volume on a host folder using option `-v` as in:

```
docker run --name docker-build-waves-testnet -v /home/user/local-waves-folder:/waves wavesplatform/docker-build-waves-testnet:latest
```

At first run a new wallet seed will be created for you and stored in `waves-testnet.json` configuration file on the volume.

To start and stop the container use Docker commands `docker start docker-build-waves-testnet` and `docker stop docker-build-waves-testnet`. We address the container by its name which we gave to it in the `--name` option of the `run` command.