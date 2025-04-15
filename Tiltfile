#
# Run `. .envrc` then `npm run tilt` to start Tilt.
# Go to http://localhost:10350/ to reach the Tilt dashboard.
# The deployed services will continue to run after you exit Tilt.
# To undeploy the services, run `. .envrc` then `npm run tilt-down`.
#

# -----------------------------------------------------------------------------
# Vars from .envrc
# -----------------------------------------------------------------------------

KUBE_CONTEXT = os.environ.get('KUBE_CONTEXT', 'toc')
KUBE_NAMESPACE = os.environ.get('KUBE_NAMESPACE', 'none')
RELEASE = os.environ.get('RELEASE', 'none')

DEFAULT_DNS_DOMAIN = os.environ.get('DEFAULT_DNS_DOMAIN', 'toc.systems')
IMAGE_REGISTRY = os.environ.get('IMAGE_REGISTRY', 'registry.toc.systems')
CLOUD_TYPE = os.environ.get('CLOUD_TYPE', 'onpremise')

HELM_SET_STRING = os.environ.get('HELM_DEPLOY_PARAMS', '')
HELM_SET_LIST = HELM_SET_STRING.split('--set ')
HELM_SET_LIST.append('image.registry=%s' % IMAGE_REGISTRY)

DOCKER_BUILD_TARGET = os.environ.get('BUILD_TARGET', 'development')
DOCKER_BUILD_PLATFORM = 'linux/x86_64'
DOCKER_BUILD_SECRETS = 'id=npmrc,src=%s' % os.environ.get('BUILD_NPM_RC', '~/.npmrc')
GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '')

DOCKER_BUILD_ARGS = {
    'CLOUD_TYPE': CLOUD_TYPE,
    'GITHUB_TOKEN': GITHUB_TOKEN
}

allow_k8s_contexts(KUBE_CONTEXT)
default_registry(IMAGE_REGISTRY)

# -----------------------------------------------------------------------------
# Integration services to deploy
# -----------------------------------------------------------------------------

nodejs_backends = [
    {
        'source_dir': './backends/nodejs',       # Project directory
        'service_name': 'backend',               # Service name in helm values.yaml
        'image_name': 'fieldtwin-integration-backend'  # Image name in devops.sh and values.yaml
    }
]

frontends = [
    {
        'source_dir': './frontends/svelte',
        'service_name': 'frontendsvelte',
        'image_name': 'fieldtwin-integration-frontendsvelte'
    }
]

helm_dir = 'helm/integration'

# -----------------------------------------------------------------------------
# Helm values to append to HELM_DEPLOY_PARAMS
# -----------------------------------------------------------------------------

HELM_SET_LIST.append('defaultDnsDomain=%s' % DEFAULT_DNS_DOMAIN)
HELM_SET_LIST.append('image.buildEnv=localDev')

# -----------------------------------------------------------------------------
# Tilt - image build, file sync and k8s service registration
# -----------------------------------------------------------------------------

def register_js_app(entry, labels=""):
    source_dir = entry["source_dir"]
    helm_name = entry["service_name"]
    image_name = entry["image_name"]

    full_image_name = "%s/%s" % (IMAGE_REGISTRY, image_name)
    docker_build(
        full_image_name,
        context=source_dir,
        dockerfile='%s/Dockerfile' % source_dir,
        target=DOCKER_BUILD_TARGET,
        platform=DOCKER_BUILD_PLATFORM,
        build_args=DOCKER_BUILD_ARGS,
        secret=DOCKER_BUILD_SECRETS,
        live_update=[
            sync(source_dir, '/app'),
            run('cd /app && npm install',
                trigger=['%s/package.json' % source_dir, '%s/package-lock.json' % source_dir]),
        ]
    )
    k8s_resource("%s-%s" % (RELEASE, helm_name), labels=labels)

[register_js_app(entry, labels="integration-backends")
    for entry in nodejs_backends]

[register_js_app(entry, labels="integration-frontends")
    for entry in frontends]

# -----------------------------------------------------------------------------
# Tilt - k8s deployment with helm
# -----------------------------------------------------------------------------

HELM_SET_LIST = [val.strip() for val in HELM_SET_LIST if val.strip() != ""]

version_json = decode_json(
    local("kubectl version -o json --context %s" % KUBE_CONTEXT)
)
server_version = "%s.%s" % (
    version_json["serverVersion"]["major"], version_json["serverVersion"]["minor"]
)

templated_yaml = helm(
    helm_dir,
    name=RELEASE,
    namespace=KUBE_NAMESPACE,
    set=HELM_SET_LIST,
    kube_version=server_version
)
k8s_yaml(templated_yaml)