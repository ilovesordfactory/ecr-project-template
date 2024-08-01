local components = require("@cts")
local registry = require("@shared/registry")
local scheduler = require("@shared/scheduler")
local start_clients = require("@server/plugins/start_clients")

local server_registry = registry.get()

registry.run_plugins(start_clients)
scheduler.schedule_containers(script.systems)
scheduler.run_scheduler(server_registry)
