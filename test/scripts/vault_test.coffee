Path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'Vault commands', ->
  user = robot = adapter =  null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', true, 'bender')

    robot.adapter.on 'connected', ->

      process.env.HUBOT_DEPLOY_RANDOM_REPLY = 'sup-dude'
      process.env.HUBOT_FERNET_SECRETS = 'HTGbOk8U268J1reVKd3USe9brjsKguT8Bn1D83PSyGQ='

      require('../../index') robot

      userInfo =
        name: 'ys'
        room: '#zf-promo'

      user = robot.brain.userForId('1', userInfo)

      adapter = robot.adapter

      done()

    robot.run()

  afterEach ->
    robot.server.close()
    robot.shutdown()


  it "saves to vault", (done) ->
    adapter.on 'reply', (envelope, strings) ->
      assert.equal strings[0], "I securely saved your lol"
      assert.equal robot.vault.forUser(user).get("lol"), "true"
      done()
    message = new TextMessage(user, '@bender vault lol=true')
    adapter.receive(message)

  it "deletes from vault", (done) ->
    robot.vault.forUser(user).set("lol", "true")
    adapter.on 'reply', (envelope, strings) ->
      assert.equal strings[0], "I think I ... forgot"
      assert.isUndefined robot.vault.forUser(user).get("lol")
      done()
    message = new TextMessage(user, '@bender vault:unset lol')
    adapter.receive(message)
