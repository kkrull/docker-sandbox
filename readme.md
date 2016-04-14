# Dockerfiles

A collection of `Dockerfile`s that I'm using to learn how to use Docker.

## Docker
### Notes

`docker logs` shows the output that is written to stdout by the container's foreground process.  It's not really looking
at log files per se.

`docker inspect` shows lots of useful information about the container and how it is mapped onto the host filesystem.


### References

- [Docker Quickstart](https://docs.docker.com/engine/quickstart/)
- [Docker's Learn by Example](https://docs.docker.com/engine/userguide/containers/dockerizing/)
- The section on [Docker Networking](https://docs.docker.com/engine/userguide/containers/networkingcontainers/) looks
  like it will be helpful.


## Containers
### consul-server

Use `bin/agent-dev` to run a container with the consul agent in dev mode.  `docker logs consul_server` then shows:

```
vagrant@docker-test:~/src/dockerfiles/consul-server$ docker logs consul_server
==> Starting Consul agent...
==> Starting Consul agent RPC...
==> Consul agent running!
         Node name: '3cf41a905164'
        Datacenter: 'dc1'
            Server: true (bootstrap: false)
       Client Addr: 127.0.0.1 (HTTP: 8500, HTTPS: -1, DNS: 8600, RPC: 8400)
      Cluster Addr: 172.17.0.2 (LAN: 8301, WAN: 8302)
    Gossip encrypt: false, RPC-TLS: false, TLS-Incoming: false
             Atlas: <disabled>
...
2016/04/14 04:04:13 [INFO] serf: EventMemberJoin: 3cf41a905164 172.17.0.2
    2016/04/14 04:04:13 [INFO] serf: EventMemberJoin: 3cf41a905164.dc1 172.17.0.2
    2016/04/14 04:04:13 [INFO] raft: Node at 172.17.0.2:8300 [Follower] entering Follower state
    2016/04/14 04:04:13 [INFO] consul: adding LAN server 3cf41a905164 (Addr: 172.17.0.2:8300) (DC: dc1)
    2016/04/14 04:04:13 [INFO] consul: adding WAN server 3cf41a905164.dc1 (Addr: 172.17.0.2:8300) (DC: dc1)
    2016/04/14 04:04:13 [DEBUG] Automatically reaping child processes
    2016/04/14 04:04:13 [ERR] agent: failed to sync remote state: No cluster leader
    2016/04/14 04:04:14 [WARN] raft: Heartbeat timeout reached, starting election
    2016/04/14 04:04:14 [INFO] raft: Node at 172.17.0.2:8300 [Candidate] entering Candidate state
    2016/04/14 04:04:14 [DEBUG] raft: Votes needed: 1
    2016/04/14 04:04:14 [DEBUG] raft: Vote granted. Tally: 1
    2016/04/14 04:04:14 [INFO] raft: Election won. Tally: 1
    2016/04/14 04:04:14 [INFO] raft: Node at 172.17.0.2:8300 [Leader] entering Leader state
    2016/04/14 04:04:14 [INFO] consul: cluster leadership acquired
    2016/04/14 04:04:14 [INFO] consul: New leader elected: 3cf41a905164
    2016/04/14 04:04:14 [INFO] raft: Disabling EnableSingleNode (bootstrap)
    2016/04/14 04:04:14 [DEBUG] raft: Node 172.17.0.2:8300 updated peer set (2): [172.17.0.2:8300]
    2016/04/14 04:04:14 [DEBUG] consul: reset tombstone GC to index 2
    2016/04/14 04:04:14 [INFO] consul: member '3cf41a905164' joined, marking health alive
    2016/04/14 04:04:15 [INFO] agent: Synced service 'consul'
```

and this command now works

    vagrant$ docker exec -it consul_server /bin/bash
    consul_server# curl http://localhost:8500/v1/catalog/nodes

Consul uses a bunch of ports:

- 8500: REST API
- 8600: DNS server
- All the other ones listed in the `Dockerfile`

Note that the consul REST server only seems to accept connections on `localhost`:

    vagrant$ docker run -d -P --name consul consul_server
    vagrant$ docker exec -it consul /bin/bash
    # curl localhost:8500
    Consul Agent
    # curl 172.17.0.3:8500
    curl: (7) Failed to connect to 172.17.0.3 port 8500: Connection refused

Some more links that are helpful in learning consul:

- [Key Value](https://www.consul.io/intro/getting-started/kv.html) store.
- A quick blog post [Consul introduction](http://blog.scottlowe.org/2015/02/06/quick-intro-to-consul/) that breaks it
  all down while avoiding marketing hype.

