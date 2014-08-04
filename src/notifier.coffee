require("./util/compat.coffee")
Client = require('./client.coffee')
processor = require('./processors/stack.coffee')
reporter = require('./reporters/hybrid.coffee')


client = new Client(processor, reporter)
client.consoleReporter = require('./reporters/console.coffee')

shim = global.Airbrake
global.Airbrake = client


# Read configuration from DOM.
require("./util/slurp_config_from_dom.coffee")(client)

if shim?
  if shim.wrap?
    client.wrap = shim.wrap

  if shim.onload?
    shim.onload(client)

  # Consume any errors already pushed to the shim.
  for err in shim
    client.push(err)
