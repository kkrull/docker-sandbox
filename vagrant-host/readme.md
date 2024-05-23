# Docker running in Vagrant

```bash
$ VBoxManage list runningvms
$ VBoxManage showvminfo 6bc576a9-6640-405a-a570-0bf244d50743
...
Shared folders:  

Name: 'vagrant', Host path: '...' (machine mapping), writable

```

## Docker itself

There are a number of useful commands to get up and running and see what's actually happening:

```bash
docker run -d <image> #Starts a container in daemon mode, so it keeps running
docker run -it <image> /bin/bash #Starts a container and runs that command
docker exec -it <container> /bin/bash #Starts an interactive shell on an already-running container
docker ps -a #Shows all containers, even the ones that exited already
docker diff #Shows changes to the filesystem
docker history --no-trunc #Shows the commands that were run (in Dockerfile?) to get to this point
```

## Network connectivity FTW

Make an empty sub-directory in the directory shared with Vagrant (somethign like `share/nginx-test`, containing this
`Dockerfile`.

```dockerfile
FROM cloudfoundry/trusty64

RUN apt-get -y update \
  && apt-get install -y nginx                                                                                                          

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/ssl

EXPOSE 80

CMD ["nginx"]
```

Then run

```bash
docker build -t nginx-test:0.2 .
docker run -d -p 12345:80 nginx-test:0.2
```

You'll then be able to confirm that it's running inside of the container:

```bash
vagrant@docker-test$ docker exec -it <container> /bin/bash
# curl http://localhost
```

Thanks to the port mapping parameter when you started the docker container, you can also do this from the Vagrant VM:

```bash
vagrant@docker-test$ curl http://localhost:12345
```

And thanks to the configuration in `Vagrantfile`, you can do this from your host machine:

```bash
badassme@hostmachine$ curl http://10.255.100.11:12345
```


## References

- What to do if you forgot to leave the container running:
  http://stackoverflow.com/questions/26153686/how-to-run-a-command-on-an-already-existing-docker-container
- A nice tutorial that goes beyond the getting started guide: https://serversforhackers.com/getting-started-with-docker
- How to connect to a running container:
  http://askubuntu.com/questions/505506/how-to-get-bash-or-ssh-into-a-running-container-in-background-mode

