local PlaceScripts = {
    [9872472334] = "https://pastefy.app/RJWAW7Jw/raw",
    [537413528] = "https://pastebin.com/raw/MSJeBNV1",
}

local FallbackLink = "https://pastebin.com/raw/yr0Z7c2h"

local url = PlaceScripts[game.PlaceId] or FallbackLink
loadstring(game:HttpGet(url))()
