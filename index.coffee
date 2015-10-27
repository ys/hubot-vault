
###########################################################################
fernet = require('fernet')

class Vault
  constructor: (@user, @store) ->
    @store[@user.id] ||= {}
    @vault = @store[@user.id]

  set: (key, value) ->
    token = new fernet.Token(secret: @currentSecret())
    @vault[key] = token.encode(JSON.stringify(value))

  get: (key) ->
    return unless @vault[key]
    value = null
    for secret in @secrets()
      token = new fernet.Token
        secret: secret
        token: @vault[key]
        ttl: 0
      try
        value = JSON.parse(token.decode())
      catch error
        continue
    value

  unset: (key) ->
    delete @vault[key]

  currentSecret: ->
    @secrets()[0]

  secrets: ->
    (new fernet.Secret(secret) for secret in process.env.HUBOT_FERNET_SECRETS.split(","))

module.exports = (robot) ->
  robot.vault =
    forUser: (user) ->
      robot.brain.data.vault ||= {}
      new Vault(user, robot.brain.data.vault)

###########################################################################
