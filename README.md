# Sensu on kubernetes deployed on AWS

Based on:
- [groventure/docker-sensu](https://github.com/groventure/docker-sensu)
- [digitalocean.com](https://www.digitalocean.com/community/tutorials/how-to-configure-sensu-monitoring-rabbitmq-and-redis-on-ubuntu-14-04)
- [godaddy.com](https://www.godaddy.com/garage/tech/config/install-sensu-ubuntu-14-04/)

## Status

Ready for testing. Verified with below versions:
- kubernetes > 1.5.0 (no RBAC support)
- redis 3.2.6
- rabbitmq 3.6.6
- erlang 19.2
- sensu 0.20.3
- uchiwa 0.10.3

## Architecture

https://go.gliffy.com/go/publish/11814882

## Prepare

- install and configure [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
- clone and adjust [moss2k13/sensu-uchiwa](https://github.com/moss2k13/sensu-uchiwa)

Credentials:
- [rabbitmq user](https://github.com/moss2k13/sensu-uchiwa/blob/master/kubernetes/10-secret-rabbitmq.yaml#L8)
- [rabbitmq pass](https://github.com/moss2k13/sensu-uchiwa/blob/master/kubernetes/10-secret-rabbitmq.yaml#L9)
- [rabbitmq vhost](https://github.com/moss2k13/sensu-uchiwa/blob/master/kubernetes/10-secret-rabbitmq.yaml#L10)
- [rabbitmq cookie](https://github.com/moss2k13/sensu-uchiwa/blob/master/kubernetes/10-secret-rabbitmq.yaml#L7)

## Deploy

```
kubectl create -f kubernetes
```
## ToDo

- switch to alpine based sensu container after [#1201](https://github.com/sensu/sensu/issues/1201)
- add RBAC support
