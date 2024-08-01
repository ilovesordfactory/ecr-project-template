local ecr = require("@ecr")
local types = require("./types")

return ecr.name({
    Client = ecr.component() :: Player,
    Currency = ecr.component() :: types.CurrencyComponent,
})
