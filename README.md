# hubot-vault [![Build Status](https://travis-ci.org/ys/hubot-vault.png?branch=master)](https://travis-ci.org/ys/hubot-vault)

## Installation

* Add hubot-vault to your `package.json` file.
* Set `HUBOT_FERNET_SECRETS` to `dd if=/dev/urandom bs=32 count=1 2>/dev/null | openssl base64`

## Usage

``` javascript
vault = robot.vault.forUser(user)
vault.set("secret_token", "secret_value")
vault.get("secret_token") # => "secret_value"
vault.unset("secret_token")
```

## Keys Rotation

Just prepend the `HUBOT_FERNET_SECRETS` with the next key

```
HUBOT_FERNET_SECRETS=new_key,old_keys
```

## See Also

* [hubot](https://github.com/github/hubot) - A chat robot with support for a lot of networks.
