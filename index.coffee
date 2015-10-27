Path   = require 'path'
Vault  = require('./src/vault.coffee').Vault

module.exports = (robot) ->
  robot.vault =
    forUser: (user) ->
      robot.brain.data.vault ||= {}
      new Vault(user, robot.brain.data.vault)
  robot.loadFile(Path.resolve(__dirname, "src", "scripts"), "vault.coffee")
