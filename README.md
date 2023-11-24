# FutureOn Basic Kubernetes Integration Template

## Description

This really simple sample is a basic skeleton for deployment of an application using **Kubernetes** and **HELM**.

It contains two servers :

1. `frontends/vuejs` which is the base application created using `vue-cli`, Dockerized

2. `backends/nodejs` which is a base Express server, Dockerized as well.

## Before You Start

Before you start, it is important that you read a bit about **Docker**, **Kubernetes** and **HELM**.

* Kubernetes: https://kubernetes.io/docs/concepts/
* HELM: https://helm.sh/docs/
* Docker: https://docs.docker.com/engine/docker-overview/

The following utilities need to be pre-installed:

* Docker: https://www.docker.com/products/docker-desktop
* kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
* helm: https://helm.sh/docs/intro/install/
* Google Cloud CLI (for deploying to TOC): https://cloud.google.com/sdk/docs/install
* stern (for viewing logs): https://github.com/stern/stern
* Tilt: https://tilt.dev/

### Mac OS

Mac OS ships with some tools that needs to be updated before the `devops.sh` script (described below) can be used. The easiest way of doing this is with MacPorts.

Upgrade bash: `sudo port install bash`
Create the `md5sum` utility: `sudo ln -s /sbin/md5 /usr/local/bin/md5sum`

MacPorts installs its tools in the non-standard location `/opt/local/bin/` so that Mac OS's own versions are not overwritten. You need to ensure that `/opt/local/bin/` is present at the beginning of your `PATH` so that the newer tools are found first.

## Environment Variables

Here is a list of environment variables that are needed to use either **Tilt** or the **devops.sh** script:

| Environment Name   | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| KUBE_CONTEXT       | Kubernetes context to use. This is defined in you kube config, which should be located on linux at `~/.kube/config`. To get a list of them : `kubectl config get-contexts` |
| KUBE_NAMESPACE     | Kubernetes namespace to use. For **TOC** : your user name.   |
| IMAGE_REGISTRY     | Docker registry where to pull and push images. For **TOC** : |
| BUILD_TARGET       | Build target, defined in each **Dockerfile**. For this sample, only  `production`or `development` are valid. |
| BUILD_NPM_RC       | Optional path to a .npmrc file to provide as a secret to the Docker build |
| DEFAULT_DNS_DOMAIN | This contains the base DNS domains which service URL will be generated from. In this template, there is two services : `frontendvue` and `backend`. If `DEFAULT_DNS_DOMAIN` is set to *examples.com* then,  each services ingress will be bound to `$RELEASE-{service name}.examples.com`. This also mean that your DNS needs to be set accordingly. On **TOC**, everything is taken care of, and certificate are generated to support `*.toc.systems`. |
| RELEASE            | Helm release name, also used for generating service URL.      |
| IMAGE_PULL_SECRETS | Image pull secrets use to communicate with docker registry. If not set, imagePullSecrets will not be set on the chart.

You can find an example in `/.envrc`. You can also use `module` or any virtual env manager.
For using `.envrc`, just type `source .envrc` before launching `tilt`.

## First Deploy

Bundled with the template, a small shell script make it easier to build, push and deploy to clusters. This script must be user **AFTER** settings the environment variables.

The script is named `devops.sh`, it requires bash v4 or later.

Commands are :

* `./devops.sh build` will build all the docker images of the project.
* `./devops.sh push` will push all the docker images to the target registry ( defined in ENV variables ).
* `./devops.sh bush` do build then push.
* `./devops.sh deploy` will deploy the charts.

While working with this template to create you own integration, you might need to modify this scripts so that you can pass build argument to **Docker**, or variable values to **HELM** chart.

Do not hesitate to look at it and modify it if needed.

Building image and pushing images is only require when a dependency change ( either in `Dockerfile`, or for example in one of `package.json`).

### Developing with the Apple M1 or ARM CPU

The `./devops.sh build` command currently includes the build parameter:

* `--platform linux/x86_64`

so that the built images will run on TOC (see below) or on the default hardware at
GCP / AWS / Azure.

To run the built images on your local Mac/PC edit the `devops.sh` script to remove
this or to control it with an environment variable.

## Checklist

### Kubernetes Development cluster

**FutureOn** for all its development uses an on premise **Kubernetes** cluster. This cluster, called **TOC** ( The Office Cluster ) is setup  with everything you need to define services and ingress, that, if setup correctly, will also set **HTTPS** certificate.

You need to request a user to **FutureOn** before you can access it. Please contact olav@futureon.com for this request.

It also runs a private docker registry, which you will get access to with your user when created.

### Tilt

Tilt allows you to develop locally while running your code remotely on TOC.

Tilt builds the required docker images, pushes them to TOC, deploys them with Helm (as pods on Kubernetes),
and syncs your local code changes to the remote pods. Ensure your `BUILD_TARGET` is set to `development` so that
file watching and hot reloading is enabled in the remote pods.

#### Tilt Configuration

Configure a file `Tiltfile` to describe the link between the local files you have and the different services running on the target cluster.

#### Tilt Run

Use the terminal to load the environment variables and start Tilt:

```
source .envrc
npm run tilt
```

Press `s` to see the Tilt output and also the remote service output which is captured and relayed back to you.

#### Tilt Stop

The remotely deployed services will continue to run after you exit Tilt. If you are finished with
the resources on the remote cluster you can undeploy the services and free up the resources with:

```
source .envrc
npm run tilt-down
```

Note that if your services include a database, **the data will be lost**.

## HELM Chart

The **HELM** chart for the project can be found in `helm/integration`. **HELM** is basically a template processor for **Kubernetes**, with a notion of *instance* in plus which make it easier to deploy whole application.

For each service ( web service ) that you create, you need to create three file :
* `{service}-deployment.yaml`, which describe how the web service is deploy.
* `{service}-ingress.yaml`, which describe the ingress(es) of the web service.
* `{service}-service.yaml`, which connect the ingress(es) with the deployment.

There is also `_helper.tpl` that allows to define common *template* to be use in charts ( everything that start  with `{{template }}`)

And finally `values.yaml` which sets the default values used everywhere in the charts ( everything that starts with `.Values` )

## Deployed Integration

After running `devops.sh deploy`, run `devops.sh status` to show the host names that the deployed integration is mapped to.
