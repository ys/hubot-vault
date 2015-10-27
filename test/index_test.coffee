Path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'Vault', ->
  user = robot = adapter =  null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', true, 'Hubot')

    robot.adapter.on 'connected', ->

      process.env.HUBOT_DEPLOY_RANDOM_REPLY = 'sup-dude'
      process.env.HUBOT_FERNET_SECRET = 'HTGbOk8U268J1reVKd3USe9brjsKguT8Bn1D83PSyGQ='

      require('../index') robot

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

  it 'Changes internal value', ->
    vault = robot.vault.forUser(user)
    assert.notProperty vault.vault, 'LOL'
    vault.set 'LOL', 'TRUE'
    assert.property vault.vault, 'LOL'
    assert.isNotNull vault.vault, 'LOL'
    assert.notEqual vault.vault['LOL'], 'TRUE'

  it 'Stores encrypted data', ->
    vault = robot.vault.forUser(user)
    vault.set 'LOL', 'TRUE'
    assert.equal vault.get('LOL'), 'TRUE'

  it 'Stores encrypted objects', ->
    vault = robot.vault.forUser(user)
    obj = 'true': 'object'
    vault.set 'LOL', obj
    assert.deepEqual vault.get('LOL'), obj

  it 'Unset keys', ->
    vault = robot.vault.forUser(user)
    vault.set 'LOL', 'TRUE'
    assert.property vault.vault, 'LOL'
    vault.unset 'LOL'
    assert.notProperty vault.vault, 'LOL'
