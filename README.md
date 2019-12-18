# FutureOn Basic Kubernetes Integration Sample

## Description

This really simple sample is a basic skeleton for deployement of an application using kubernets and helm.

It contains two server :
- frontends/vuejs 
- backends/nodejs


## How To Deploy

You need to defined 3 environment variables :
- KUBE_CONTEXT   kubernetes context to use. For TOC : **toc**
- KUBE_NAMESPACE kubernetes namespace to use. For TOC : your user name
- IMAGE_REGISTRY Docker registry where to pull and push images. For TOC : **registry.toc.systems**

