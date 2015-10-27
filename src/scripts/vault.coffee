# Description:
#   Securely store key value pairs
#
# Commands:
#   hubot vault KEY       - Retrieve the value of KEY
#   hubot vault KEY=VALUE - Securely stores the key/value pair
#   hubot vault:unset KEY - Forget the KEY/VALUE pair
#
module.exports = (robot) ->
  vault = (user) ->
    robot.vault.forUser(user)

  robot.respond /vault ([A-Za-z0-9\-_]+)=(.+)$/i, (msg) ->
    user = robot.brain.userForName(msg.message.user.name)
    key = msg.match[1]
    value = msg.match[2]
    vault(user).set(key, value)
    msg.reply "I securely saved your #{key}"

  robot.respond /vault:unset ([A-Za-z0-9\-_]+)$/i, (msg) ->
    user = robot.brain.userForName(msg.message.user.name)
    key = msg.match[1]
    result = vault(user).unset(key)
    msg.reply "I think I ... forgot"

  robot.respond /vault ([A-Za-z0-9\-_]+)$/i, (msg) ->
    user = robot.brain.userForName(msg.message.user.name)
    key = msg.match[1]
    result = vault(user).get(key)
    msg.reply "I think it is #{result}"
