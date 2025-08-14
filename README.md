# `Stell` | Lib

## Load
``` lua
local Stell = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Stell/refs/heads/main/init.lua"))()
```

## Window
``` lua
local Window = Stell:MakeWindow({
  Title = "Window!",
  SubTitle = "SubTitle!",
  Logo = "rbxassetid://2983929993"
})
```

## Tab
``` lua
local Tab = Window:MakeT({
  Name = "Tab!",
  Content = "Tab content!",
  Icob = ""
})
```

## Full Example
``` lua
local Stell = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Stell/refs/heads/main/init.lua"))()

local Window = Stell:MakeWindow({
  Title = "Window!",
  SubTitle = "SubTitle!",
  Logo = ""
})
```
