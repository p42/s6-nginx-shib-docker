
## Versions

* Base OS: alpine3.6
* [Shibboleth](https://shibboleth.net/): 2.5.3
* [nginx](http://nginx.org/): 1.13.7
* [envplate](https://github.com/kreuzwerker/envplate): 0.0.8

# How to use

## Prerequisites

* Docker 1.5

## Build the image

`docker build -t vsv/shibboleth-nginx .`

## Run the container with environment variables

You will need to have port 80 and 443 available.

This runs the container in the foreground, which can be useful for debugging

````
docker run -p 80:80 -p 443:443 --rm \
    -v $(pwd)/log:/var/log \
    -e CLIENT_APP_SCHEME=https \
    -e CLIENT_APP_HOSTNAME=your-app.localdomain.com \
    -e NGINX_PROXY_DESTINATION=http://172.17.42.1:8001 \
    vsv/shibboleth-nginx
````

## SAML Id Providers

The default shibboleth config file has metadata entries for:

* [OpenIdP](https://openidp.feide.no/)
* [Testshib](https://www.testshib.org/)

## Environment vars and defaults

### CLIENT_APP_SCHEME

* The URL scheme used for fetching metadata
* Default: `https`


### CLIENT_APP_HOSTNAME

* The primary client application hostname. Should be fully-qualified and available outside your local network.
* Default: `your-app.localdomain.com`


### CLIENT_APP_SECURE_PATH

* The URL path used by Shibboleth as a 'secure' path. When this URL path is loaded, Shibboleth will
  intercept the request, force a login, and pass special headers across the nginx proxy.
* Default: `/app`


### SHIBBOLETH_RESPONDER_PATH

* The Shibboleth responder path. URLs using this path will be served by Shibboleth's `shibresponder`
* Default: `/saml`


### NGINX_PROXY_DESTINATION

* A URL where the web application is running. Defaults to port 8001 of the Docker host.
* Default: `http://172.17.42.1:8001`

## Expected paths

- Shibboleth base path: `/saml` (uses `SHIBBOLETH_RESPONDER_PATH`)
- Shibboleth Status reporting service: `/saml/status`
- Shibboleth Session diagnostic service: `/saml/session`
- SAML Metadata: `/saml/metadata`
- SAML ACS URL: `/saml/acs`
- SAML Login: `/saml/Login` (case-sensitive)

# Login URLs

* Default login (OpenIdP):
    * https://your-app.localdomain.com/saml/Login?target=/app
* Login with the Testshib IdP:
    * https://your-app.localdomain.com/saml/Login?target=/app&entityID=https://idp.testshib.org/idp/shibboleth


## CI/CD

Projects are using automated build/test/deploy pipelines availabe in GitLab. This strategy requires that you enable CI/CD on your GitLab project. **To enable pipelines, rename .gitlab-ci.yml.default to .gitlab-ci.yml.**

### Writing/Configuring Tests

* The assumption is that downstream builds are "from" a P42 base image (centos, alpine, etc). These packages come with basic test scripts installed. To include your tests in the test coverage:
    1. Create a folder/folders in the ci_tests directory which will contain your test scripts. Please make sure these are executable files.
    1. Write your tests using good testing conventions (singular, good debugging output, etc).
    1. When deploying, you can run either all tests or just your local tests by supplying arguments to the docker run --rm ... command in the test stage of the .gitlab-ci.yml file. No arguments will run all tests including upstream.
* Available Runners
    * Multiple runners are available and can be specified or selected using the tags in .gitlab-ci.yml. Available tags are:
    * - docker
    * - ovirt
    * - ubuntu
    * - openstack
    * - coreos
    * - default

## Docker Conventions
