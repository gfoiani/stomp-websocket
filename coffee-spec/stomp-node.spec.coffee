Stomp = require('../lib/stomp-node.js')
fs = require('fs')

# TODO mock server and parameters
describe "Stomp Node", ->

  it "lets you connect to a server with TCP socket and get a callback", (done) ->
    client = Stomp.overTCP 'localhost', 61613
    connectionHeaders = {
      'max_hbrlck_fails': 10,
      'accept-version': '1.0,1.1,1.2',
      'heart-beat': '10000,10000',
      login: 'c39b1999-2786-44e1-a76c-7a5cd6e18b73',
      passcode: 'Rbqw8X-yzM-iVkEWSzsAwXvtRXUw5qz_5U_JVsst',
      host: '34a76890-9b71-4dfb-8baa-c1f394489c95'
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
      cert: fs.readFileSync('/Users/gfoiani/tls-gen/basic/result/client_certificate.pem'),
      key: fs.readFileSync('/Users/gfoiani/tls-gen/basic/result/client_key.pem'),
      ca: [fs.readFileSync('/Users/gfoiani/tls-gen/basic/result/ca_certificate.pem')],
      secureProtocol: 'TLSv1_method'
    }
    client = Stomp.overTCP 'FojaMac', 61614, sslOptions
    connectionHeaders = {
      'max_hbrlck_fails': 10,
      'accept-version': '1.0,1.1,1.2',
      'heart-beat': '10000,10000',
      login: 'c39b1999-2786-44e1-a76c-7a5cd6e18b73',
      passcode: 'Rbqw8X-yzM-iVkEWSzsAwXvtRXUw5qz_5U_JVsst',
      host: '34a76890-9b71-4dfb-8baa-c1f394489c95'
    }
    client.connect connectionHeaders, (()->
      expect(client.connected).toBe(true)
      client.disconnect()
      done()
    ), (err) ->
      console.log err
      done.fail('STOMP with SSL connection error')
