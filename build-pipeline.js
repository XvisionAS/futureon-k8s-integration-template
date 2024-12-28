 
module.exports = function (mod, event, options) {

  const components = [
    "vuejs",
    "nodejs"
  ]
  return {
    start: "devops-build",
    items: {
      "devops-build": {
        name: "build docker images",
        cmd: "bash",
        args: ["devops.sh", "build", "%0"],
        items: components,
        cwd: options.gitPath,
        success: "devops-push"
      },
      "devops-push": {
        name: "push docker images",
        cmd: "bash",
        items: components,
        args: ["devops.sh", "push", "%0"],
        cwd: options.gitPath,
        success: "devops-deploy"
      },
      "devops-deploy": {
        name: "deploy application",
        cmd: "bash",
        args: ["devops.sh", "deploy"],
        cwd: options.gitPath
      }
    }
  }
}