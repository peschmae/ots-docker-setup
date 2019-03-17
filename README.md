# Onetimesecret as Docker image
`docker-compose` setup with a custom built docker image, and a default redis 
container.  

The dockerfile currently uses `git clone` and installs quite a few dependencies, 
this could be changed when switching to a multistage build, see below for more 
information.  

The `redis.conf` as well as the `ots.config` are copied from the onetimesecret 
repository.  

The `redis.conf` is currently not in use, since it somehow crashed the redis 
server.

## Multistage build
I've started a multistage build setup, but this resulted in the CSS files not 
beeing loaded and I got no clue why...
```
FROM centos:7 as app

RUN yum install -y ntp ruby \
    && gem install bundler -v 1.17.3 \
    && adduser ots \
    && mkdir -p /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime /opt/ots/ \
    && chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime /opt/ots/

USER ots
WORKDIR /opt/ots/

COPY --from=build /opt/ots/ .

RUN cp -R etc/locale /etc/onetime \
    && cp -R etc/fortunes /etc/onetime
```