# docker-nginx-tcp-lb

[![Build Status][build-badge]][build] [![Docker Pulls][docker-badge]][docker]
[![GitHub][github-badge]][github]

A small Docker image for running an [nginx][] TCP load balancer.

**Table of Contents**

<!-- toc -->

- [Getting the Image](#getting-the-image)
- [Usage](#usage)
- [Issues](#issues)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)

<!-- tocstop -->

## Getting the Image

The image is hosted on Docker Hub and can be pulled down with:

```console
$ docker pull fnichol/nginx-tcp-lb
```

## Usage

By default, `nginx` will be run with no arguments:

```console
$ docker run --rm -ti fnichol/nginx-tcp-lb
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
...
```

Now, to add TCP listeners which forward to their upstreams, you need to do 2
things:

1. set an environment variable which contains the listening port and upstream
   host/port information
2. expose the corresponding listening Docker port entry for external access

For example, to set up HTTP and HTTPS forwarding listeners to 2 upstream servers
on `www1.local` and `www2.local` you can run:

```sh
docker run --rm -ti \
  -p 8080:8080 -e NGINX_TCP_HTTP=8080:www1.local,www2.local:80 \
  -p 8443:8443 -e NGINX_TCP_HTTPS=8443:www1.local,www2.local:443 \
  fnichol/nginx-tcp-lb
```

Note that each environment variable entry is of this form:

```
               Upstream hosts, delimited with comma
                              |
    Listener name             |
           |                  |
          ----      ---------------------
NGINX_TCP_HTTP=8080:www1.local,www2.local:80
----------     ----                       --
    |            |                         |
Variable prefix  |                         |
                 |                         |
        Listening/serving TCP port         |
                                           |
                        Upstream TCP port (all upstreams are the same)
```

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue][issues].

## Contributing

You are invited to contribute to new features, fixes, or updates, large or
small; we are always thrilled to receive pull requests, and do our best to
process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub
issue][issues], especially for more ambitious contributions. This gives other
contributors a chance to point you in the right direction, give you feedback on
your design, and help you find out if someone else is working on the same thing.

## Authors

Created and maintained by [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>).

## License

This Docker image is licensed under the [MIT][license] license. The nginx
project is also licensed under a [2-clause BSD-like][nginx-license] license.

[build-badge]: https://api.cirrus-ci.com/github/fnichol/docker-nginx-tcp-lb.svg
[build]: https://cirrus-ci.com/github/fnichol/docker-nginx-tcp-lb
[docker-badge]: https://img.shields.io/docker/pulls/fnichol/nginx-tcp-lb.svg
[docker]: https://hub.docker.com/r/fnichol/nginx-tcp-lb
[fnichol]: https://github.com/fnichol
[github-badge]:
        https://img.shields.io/github/tag-date/fnichol/docker-nginx-tcp-lb.svg
[github]: https://github.com/fnichol/docker-nginx-tcp-lb
[issues]: https://github.com/fnichol/docker-nginx-tcp-lb/issues
[license]:
        https://github.com/fnichol/docker-nginx-tcp-lb/blob/master/LICENSE.txt
[nginx-license]: http://nginx.org/LICENSE
[nginx]: http://nginx.org/
