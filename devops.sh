#!/usr/bin/env bash

set -o errexit
set -o pipefail

export RELEASE=${RELEASE:-$USER-integration}

chartPath="helm/integration"

declare -A images

images["vuejs"]="frontends/vuejs"
images["nodejs"]="backends/nodejs"

declare -A Dockerfiles

Dockerfiles["vuejs"]="Dockerfile"
Dockerfiles["nodejs"]="Dockerfile"

function usage() {
  c=$(basename $0)
  echo "> Kubernetes context: $KUBE_CONTEXT"
  echo "> Kubernetes namespace: $KUBE_NAMESPACE"
  echo "> Release: ${RELEASE}"
  echo
  echo "Usage: $c [config…] <command> [arg…]"
  echo
  echo '** CONFIG **'
  echo
  echo '-r <release name>              helm release to operate on'
  echo '-c <context>                   kubectl context to use'
  echo '-n <namespace>                 kubernetes namespace to use'
  echo
  echo 'Can also be set via env vars:'
  echo '$RELEASE $KUBE_CONTEXT $KUBE_NAMESPACE'
  echo
  echo '** COMMANDS **'
  echo
  echo 'build [name]                             Build docker image(s)'
  echo "bush [name]                              Build and push docker images"
  echo 'deploy                                   Deploy helm chart'
  echo 'destroy                                  Destroy helm release'
  echo 'exec <service> <cmd> [arg…]              Run command inside service container'
  echo 'forward <service> <port_src:port_dst>    Forward port from pods'
  echo 'logs [service]                           View logs with stern'
  echo 'pod <service>                            Describe a service pod'
  echo 'printimagetag                            Shows the image tag that will get used by build'
  echo 'push [name]                              Push docker image(s)'
  echo 'restart <service>                        Restart (kill) pods for a given service'
  echo 'status                                   Show helm release status'
  echo
}


unamestr=$(uname)

if [[ "$unamestr" == 'Darwin' ]]; then
  projectRoot="$(cd "$(dirname $(readlink $0 || echo $0))" && pwd)"
else
  projectRoot="$(cd "$(dirname $(readlink -f $0 || echo $0))" && pwd)"
fi

cd $projectRoot

# Parse config args
while getopts "rcn:" opt; do
    case $opt in
    r) export RELEASE=$OPTARG ;;
    c) export KUBE_CONTEXT=$OPTARG ;;
    n) export KUBE_NAMESPACE=$OPTARG ;;
    \?) exit 1;; # Invalid argument
    esac
done

export BUILD_TARGET=${BUILD_TARGET:-production}


: "${RELEASE?must be specified}"
: "${KUBE_CONTEXT?must be specified}"
: "${KUBE_NAMESPACE?must be specified}"


function imageTag() {
  if [ -n "$TAG" ]; then
    echo $TAG
  else
    case "$TAG_TYPE" in
      "userbranch")
        echo $(git rev-parse --abbrev-ref HEAD).$USER.$( git diff | md5sum | cut -f 1 -d ' ' ) | sed 's/[^a-zA-Z0-9\-]/\_/g'
        ;;
      *)
        echo $(git rev-parse --abbrev-ref HEAD).$(git describe --always --abbrev=7 --dirty=".$USER-dirty").$BUILD_TARGET.$( git diff | md5sum | cut -f 1 -d ' ' ) | sed 's/[^a-zA-Z0-9\.\-]/\_/g'
        ;;
    esac
  fi
}

function imageRef() {
  if [ -z "$IMAGE_REGISTRY" ]; then
    export IMAGE_REGISTRY=$(
      kubectl get configmap boilerplate-config \
        --context $KUBE_CONTEXT \
        --namespace boilerplate \
        -o 'jsonpath={.data.image\.registry}'
    )
  fi

  : "${1?image name must be specified}"

  echo "${IMAGE_REGISTRY}${IMAGE_REGISTRY_PATH:-""}/$1:$(imageTag)"
}

function copyRegCred() {
  if [[ ! -z "$IMAGE_PULL_SECRETS" ]]; then
    credsRC=0
    kubectl get secret $IMAGE_PULL_SECRETS --context $KUBE_CONTEXT --namespace=$KUBE_NAMESPACE || credsRC=$?
    if [[ $credsRC -ne 0 ]]; then
      kubectl get secret $IMAGE_PULL_SECRETS --context $KUBE_CONTEXT --namespace=boilerplate -o yaml | sed "s/namespace: boilerplate/namespace: $KUBE_NAMESPACE/g" | kubectl apply --context $KUBE_CONTEXT --namespace=$KUBE_NAMESPACE -f -
    fi
  fi
}

function _kubectl() {  
  kubectl \
    --namespace $KUBE_NAMESPACE \
    --context $KUBE_CONTEXT \
    ${@:1}
}

function _helm() {
  helm \
    --kube-context $KUBE_CONTEXT \
    ${@:1}
}

function serviceForward() {
  serviceName=$1
  runningPod=$(
    _kubectl get pod \
      --field-selector=status.phase==Running \
      --selector app.kubernetes.io/name=$serviceName,app.kubernetes.io/instance=$RELEASE \
      -o jsonpath="{.items[0].metadata.name}"
  )

  _kubectl port-forward $runningPod ${@:2}
}

function serviceExec() {
  serviceName=$1
  runningPod=$(
    _kubectl get pod \
      --field-selector=status.phase==Running \
      --selector app.kubernetes.io/name=$serviceName,app.kubernetes.io/instance=$RELEASE \
      -o jsonpath="{.items[0].metadata.name}"
  )

  _kubectl exec -it $runningPod -- ${@:2}
}

function toHelmArray() {
  local lines=($1)
  local name=$2
  local i
  local ret
  ret=" "
  for (( i=0; i<${#lines[@]}; i++ )) ; do
    ret+=" --set $name[$i]=${lines[$i]}"
  done
  echo $ret
}


case "$1" in
  "licences"|"l")
    npm install -g license-checker npm-check-licenses
    for image in "${!images[@]}"; do
      pushd ${images[$image]}
      echo "*******************************************************************"
      echo "Licences for $image"
      echo "*******************************************************************"
      license-checker
      echo "*******************************************************************"
      echo "List of licences we need to check"
      echo "*******************************************************************"
      ncl
      popd
    done
    ;;

  "build"|"b")
    if [ -n "$2" ]; then
      BUILD_TARGET_IMAGE=$BUILD_TARGET
      echo "############### Build $2 ##########"
      # if [ "$2" == "converter" ]; then
      #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
      # fi
      # if [ "$2" == "mongodb-backup" ]; then
      #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
      # fi
      # if [ "$2" == "activities-importer" ]; then
      #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
      # fi
      docker build \
        --target $BUILD_TARGET_IMAGE \
        -t $(imageRef $2) \
        -f ${images[$2]}/${Dockerfiles[$2]} \
        ${images[$2]}
    else
      for image in "${!images[@]}"; do
        BUILD_TARGET_IMAGE=$BUILD_TARGET
        echo "############### Build $image ##########"

        # if [ "$image" == "converter" ]; then
        #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
        # fi
        # if [ "$image" == "mongodb-backup" ]; then
        #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
        # fi
        # if [ "$image" == "activities-importer" ]; then
        #   BUILD_TARGET_IMAGE=$CLOUD_TYPE
        # fi
        docker build \
          --target $BUILD_TARGET_IMAGE \
          -t $(imageRef $image) \
          -f ${images[$image]}/${Dockerfiles[$image]} \
          ${images[$image]}
      done
    fi
    ;;

  "clean")
    cleanJobs
    ;;

  "bush"|"bp")
    $0 build ${@:2}
    $0 push ${@:2}
    ;;

  "deploy")
    # be sure to create namespace first
    kubectl --context $KUBE_CONTEXT create namespace $KUBE_NAMESPACE || true
    copyRegCred
    helm upgrade \
      --kube-context $KUBE_CONTEXT \
      $RELEASE $chartPath \
      --install \
      --namespace $KUBE_NAMESPACE \
      $HELM_DEPLOY_PARAMS \
      --set image.tag=$(imageTag) \
      --set image.repository=${IMAGE_REGISTRY}${IMAGE_REGISTRY_PATH:-""} \
      --set defaultDnsDomain=$DEFAULT_DNS_DOMAIN \
        ${@:2}
    ;;

  "destroy")
    echo "Are you sure you want to destroy the release $RELEASE"
    select result in Yes No
    do
    if [ "$result" = "No" ]; then
      exit 0
    fi
    break
    done
    _helm delete $RELEASE ${@:2} --namespace $KUBE_NAMESPACE
    ;;

  "exec"|"e")
    serviceExec ${@:2}
    ;;

  "forward"|"f")
    serviceForward ${@:2}
    ;;

  "kubectl"|"k")
    _kubectl ${@:2}
    ;;

  "logs")
    if [ -n "$2" ]; then
      selector="app.kubernetes.io/name=$2,app.kubernetes.io/instance=$RELEASE"
    else
      selector="app.kubernetes.io/instance=$RELEASE"
    fi
    stern \
      --context $KUBE_CONTEXT \
      --namespace $KUBE_NAMESPACE \
      --selector $selector \
      --template '{{color .ContainerColor .ContainerName}} {{.Message}}' \
      ${@:3}
    ;;

  "pod")
    if [ -n "$2" ]; then
      selector="app.kubernetes.io/name=$2,app.kubernetes.io/instance=$RELEASE"
    else
      selector="app.kubernetes.io/instance=$RELEASE"
    fi

    _kubectl describe pod --selector $selector ${@:3}
    ;;

  "push"|"p")
    if [ -n "$2" ]; then
      echo "######## Push $2 #########"
      docker push $(imageRef $2)
    else
      for image in "${!images[@]}"; do
        echo "######## Push $image #########"
        docker push $(imageRef $image)
      done
    fi
    ;;

  "restart"|"r"|"kill")
    if [ -n "$2" ]; then
      toRestart=${@:2}
    else
      toRestart=${!images[@]}
    fi
    for serviceName in $toRestart
    do
      echo "Restarting $serviceName"
      _kubectl delete pod --selector app.kubernetes.io/name=$serviceName,app.kubernetes.io/instance=$RELEASE  --ignore-not-found=true
    done
    ;;

  "status"|"s")
    helm get manifest $RELEASE --kube-context $KUBE_CONTEXT --namespace $KUBE_NAMESPACE | kubectl get --context $KUBE_CONTEXT --namespace $KUBE_NAMESPACE -f -
    ;;

  "printimagetag")
    echo "$(imageTag)"
    ;;

  *)
    usage
    exit 1
    ;;
esac
