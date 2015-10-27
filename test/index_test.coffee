Path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'Vault', ->
  user = robot = adapter =  null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', true, 'Hubot')

    robot.adapter.on 'connected', ->

      process.env.HUBOT_DEPLOY_RANDOM_REPLY = 'sup-dude'
      process.env.HUBOT_FERNET_SECRETS = 'HTGbOk8U268J1reVKd3USe9brjsKguT8Bn1D83PSyGQ='

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

  it 'supports multiple secrets', ->
    vault = robot.vault.forUser(user)
    vault.set 'LOL', 'TRUE'
    process.env.HUBOT_FERNET_SECRETS = '09E5+pgDBnL7sWDQ+GsQpEWpp8869hTC6r1a361V5i8=,HTGbOk8U268J1reVKd3USe9brjsKguT8Bn1D83PSyGQ='
    vault = robot.vault.forUser(user)
    assert.equal vault.get('LOL'), 'TRUE'

  it 'is undefined when none of the secrets match the one encoded with', ->
    vault = robot.vault.forUser(user)
    vault.set 'LOL', 'TRUE'
    process.env.HUBOT_FERNET_SECRETS = '+yFKliFBGgxlf1nHov8h6HkC/qc/7S02G6wleFu2etI='
    vault = robot.vault.forUser(user)
    assert.isUndefined vault.get('LOL')

  it 'raises when no secrets', ->
    process.env.HUBOT_FERNET_SECRETS = ''
    vault = robot.vault.forUser(user)
    assert.throws (-> vault.set('LOL', 'TRUE')), /Secret must be 32 url-safe base64-encoded bytes./

  it 'raises when wrongly formatted secrets', ->
    process.env.HUBOT_FERNET_SECRETS = 'lol'
    vault = robot.vault.forUser(user)
    assert.throws (-> vault.set('LOL', 'TRUE')), /Secret must be 32 url-safe base64-encoded bytes./
