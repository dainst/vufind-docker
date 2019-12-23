# vufind-docker
Docker setup for VuFind development

## First time setup

Copy the environment configuration:
```
cp .env_template .env
```

### Using a local or external Solr
By default, VuFind will be run with a local Solr instance (installed within the Docker container). You can put sample data in the existing [directory](sample-data), which will be automatically indexed once you start the container. If you want to use the external Solr, just set the option accordingly in your local `.env` file. The external Solr is the one used by our Development Server (ber-vufind03vm). You have to be within the intranet in order to be able to access it.

### Setting up git submodules
Run 
```
git submodule init
```
and 
```
git submodule update
```
to initialize this repository's submodules. 

You should handle the "detached head" state for both submodules, if you want to work on either by checking out branches. 
```
cd vufind
git checkout zenon
cd ../vufind-configs
git checkout master
```

### Building the images
Run
```
docker-compose build
```
to build the images.

## Running vufind
To start containers based on the built images, run
```
docker-compose up
```
The first time you run this script after building, it will take quite some time because the PHP dependencies are installed.

## Using Xdebug in VSCode with Docker

To enable Xdebug in the docker container the container-settings of the container containing the php environment need this line:
```
XDEBUG_CONFIG: remote_host=host.docker.internal remote_port=9000 remote_enable=1
```
(the current docker-compose.yml allready contains this line)

In the launch settins of VSCode found in .vscode/launch.json add the following to the configurations array:

```
 {         
    "name": "Listen for XDebug",
    "type": "php",
    "request": "launch",
    "pathMappings": {
         "/usr/local/vufind": "/Users/nhempel/DockerProjects/vufind-docker/vufind"
     },
    "port": 9000
 },
```

To start a debuging session hit the play button under the debuging tap in VSCode.
