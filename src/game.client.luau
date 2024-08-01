local ReplicatedStorage = game:GetService("ReplicatedStorage")
local registry = require("@shared/registry")
local scheduler = require("@shared/scheduler")
local client_systems = ReplicatedStorage.Client.systems
local app = require("@app")

local client_registry = registry.get(true)

scheduler.schedule_container(client_systems)
scheduler.run_scheduler(client_registry)

app.init()
