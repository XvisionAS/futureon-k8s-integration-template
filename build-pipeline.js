 
module.exports = function (mod, event, options) {

  const components = [
    "vuejs",
    "nodejs"
  ]
  return {
/*
    Optional: skip build+deploy if all the git commit messages contain "nobuild"

    start: "do-not-build-on-nobuild",
    items: {
      "do-not-build-on-nobuild": {
        name: "Check if we want to build",
        cmd: async function (pipeline, ci, config, step) {
          const nobuild =
            Array.isArray(event.commits) &&
            event.commits.every(
              (commit) => commit.message && commit.message.includes("nobuild")
            )
          step.success = nobuild ? undefined : "devops-build"
        },
      },
*/
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