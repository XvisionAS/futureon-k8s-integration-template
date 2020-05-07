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

### Mac OS

Mac OS ships with some tools that needs to be updated before the `devops.sh` and `kpd` tools (described below) can be used. The easiest way of doing this is with MacPorts.

Upgrade bash: `sudo port install bash`  
Upgrade rsync: `sudo port install rsync`  
Install watchman: `sudo port install watchman`  
Create the `md5sum` utility: `sudo ln -s /sbin/md5 /usr/local/bin/md5sum`

MacPorts installs its tools in the non-standard location `/opt/local/bin/` so that Mac OS's own versions are not overwritten. You need to ensure that `/opt/local/bin/` is present at the beginning of your `PATH` so that the newer tools are found first.

## Environment Variables

Here is a list of environment variables that are needed to use either **KPD** or **devops.sh** scripts :

| Environment Name   | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| KUBE_CONTEXT       | Kubernetes context to use. This is defined in you kube config, which should be located on linux at `~/.kube/config`. To get a list of them : `kubectl config get-contexts` |
| KUBE_NAMESPACE     | Kubernetes namespace to use. For **TOC** : your user name.   |
| IMAGE_REGISTRY     | Docker registry where to pull and push images. For **TOC** : |
| BUILD_TARGET       | Build target, defined in each **Dockerfile**. For this sample, only  `production`or `development` are valid. |
| DEFAULT_DNS_DOMAIN | This contains the base DNS domains which service URL will be generated from. In this template, there is two services : `frontendvue` and `backend`. If `DEFAULT_DNS_DOMAIN` is set to *examples.com* then,  each services ingress will be bound to `$RELEASE-{service name}.examples.com`. This also mean that your DNS needs to be set accordingly. On **TOC**, everything is taken care of, and certificate are generated to support `*.toc.systems`. |
| RELEASE            | HELM release name, also use for generating service URL.      |
| IMAGE_PULL_SECRETS | Image pull secrets use to communicate with docker registry. If not set, imagePullSecrets will not be set on the chart. |
You can find an example in `/.envrc`. You can also use `module` or any virtual env manager.
For using `.envrc`, just type `source .envrc` before launching `kpd`.

## First Deploy

Bundled with the template, a small shell script make it easier to build, push and deploy to clusters. This script must be user **AFTER** settings the environment variables.

The script is named `devops.sh`, it requires bash v4 or later.

Commands are :

* `./devops.sh build` will build all the docker image of the project.
* `./devops.sh push` will push all the docker image to the target registry ( defined in ENV variables ).
* `./devops.sh bush` do build then push.
* `./devops.sh deploy` will deploy the charts.

While working with this template to create you own integration, you might need to modify this scripts so that you can pass build argument to **Docker**, or variable values to **HELM** chart.

Do not hesitate to look at it and modify it if needed.

Building image and pushing images is only require when a dependency change ( either in `Dockerfile`, or for example in one of `package.json`).

## Checklist

### Kubernetes Development cluster

**FutureOn** for all its development uses an on premise **Kubernetes** cluster. This cluster, called **TOC** ( The Office Cluster ) is setup  with everything you need to define services and ingress, that, if setup correctly, will also set **HTTPS** certificate. 

You need to request a user to **FutureOn** before you can access it. Please contact olav@futureon.com for this request.

It also runs a private docker registry, which you will get access to with your user when created.

### KPD

We are sharing **TOC** with another company **Skalar** which have also develops tools to work easily within the cluster. This set of tools is called **KPD** and consists of :

- A **VSCode plugin**, that allows to easily debug, see logs, build images, and deploy.
- A server running on your computer, that make a bridge between target **Kubernetes** cluster and whoever communicate with it ( **VSCode plugin** for example )
- A service running on the target **Kubernetes** cluster to allow easy syncing of your local files to the different *service* of your deployment.

The very basic functionality is to be able to sync file on a running **POD**. Which make development against a cluster a lot easier, as if you use **nodemon** ( or **vue serve** ) for example, every time you save a file, it will be sync on the **POD** that hold the **service**, the application within these **POD** will get rebuild, mimicking the way you would do development locally.

#### KPD Configuration

This also mean that you need to configure a file `kpd.yaml` to describe the link between the different services running on the target cluster and the local files you have.

#### KPD Installation

1. Create or edit a `.npmrc` file containing the npm registry URL and authentication token for the **Skalar** registry. This is currently private. Please contact olav@futureon.com for this request.
2. Server component, at the base root of this template, execute `npm install`, this will install everything needed to run `KPD` server, locally to the folder.
3. VSCode plugin, is a bit trickier, as it needs to be installed globally. As some point it will be published to VS code extension repository, but for now : `npm install -g @skalar/kpd-vscode` then in VS Code go to the Extensions view and choose _Install from VSIX_ from the actions menu.

#### KPD Run

To run `kpd`, from the root of the folders, **AFTER** settings the environment variables, run `npx kpd`. If everything goes well, it should start to output log. At this point, the file are syncing on **TOC**.

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
