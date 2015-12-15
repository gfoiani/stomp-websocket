Stomp = require('../lib/stomp-node.js')
fs = require('fs')

# TODO mock server and parameters
describe "Stomp Node", ->

  it "lets you connect to a server with TCP socket and get a callback", (done) ->
    client = Stomp.overTCP 'host', 61613 # STOMP port
    connectionHeaders = {
      'max_hbrlck_fails': 10,
      'accept-version': '1.0,1.1,1.2',
      'heart-beat': '10000,10000',
      login: 'login',
      passcode: 'passcode',
      host: 'vhost' # for RabbitMQ
    }
    client.connect connectionHeaders, ->
      expect(client.connected).toBe(true)
      client.disconnect()
      done()
    ), (err) ->
      console.log err
      done.fail('STOMP connection error')

  it "lets you connect to a server with SSL TCP socket and get a callback", (done)->
    sslOptions = {
      cert: fs.readFileSync('/path/to/client_certificate.pem'),
      key: fs.readFileSync('/path/to/client_key.pem'),
      ca: [fs.readFileSync('/path/to/ca_certificate.pem')],
      secureProtocol: 'TLSv1_method'
    }
    # STOMP SSL port 61614
    # host must be suitable for certificate
    client = Stomp.overTCP 'host', 61614, sslOptions
    connectionHeaders = {
      'max_hbrlck_fails': 10,
      'accept-version': '1.0,1.1,1.2',
      'heart-beat': '10000,10000',
      login: 'login',
      passcode: 'passcode',
      host: 'vhost' # for RabbitMQ
    }
    client.connect connectionHeaders, (()->
      expect(client.connected).toBe(true)
      client.disconnect()
      done()
    ), (err) ->
      console.log err
      done.fail('STOMP with SSL connection error')
