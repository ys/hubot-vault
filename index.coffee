
###########################################################################
fernet = require('fernet')

class Vault
  constructor: (@user, @store) ->
    @store[@user.id] ||= {}
    @vault = @store[@user.id]

  set: (key, value) ->
    token = new fernet.Token(secret: @secret())
    @vault[key] = token.encode(JSON.stringify(value))

  get: (key) ->
    return unless @vault[key]
    token = new fernet.Token
      secret: @secret()
      token: @vault[key]
      ttl: 0
    JSON.parse(token.decode())

  unset: (key) ->
    delete @vault[key]

  secret: ->
    new fernet.Secret(process.env.HUBOT_FERNET_SECRET)

module.exports = (robot) ->
  robot.vault =
    forUser: (user) ->
      robot.brain.data.vault ||= {}
      new Vault(user, robot.brain.data.vault)

###########################################################################
