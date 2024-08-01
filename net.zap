opt casing = "snake_case";
opt server_output = "src/server/network/init.luau";
opt client_output = "src/client/network/init.luau";

event replicate = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: map{[string]: struct {
        set: unknown[],
        ids: u32[],
        removed: u32[]?,
    }}
}
