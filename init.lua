local Stell = {}

local baseURL = "https://raw.githubusercontent.com/RainCreatorHub/Stell/refs/heads/main/src/"

local function fetchModule(path)
    if Stell._moduleCache and Stell._moduleCache[path] then
        return Stell._moduleCache[path]
    end

    local success, moduleCode = pcall(function()
        return game:HttpGet(baseURL .. path .. "?t=" .. tick())
    end)
    
    if success and moduleCode then
        local func, err = loadstring(moduleCode)
        if func then
            local loadedModule = func()
            if not Stell._moduleCache then Stell._moduleCache = {} end
            Stell._moduleCache[path] = loadedModule
            return loadedModule
        else
            warn("Stell Error: Falha ao compilar o código do módulo em " .. path .. ". Erro: " .. tostring(err))
        end
    else
        warn("Stell Error: Não foi possível buscar o módulo em " .. path .. ". Erro: " .. tostring(moduleCode))
    end
    return nil
end

function Stell:MakeWindow(info)
    info = info or {}
    
    local config = {
        Title = info.Title or "Window",
        SubTitle = info.SubTitle or "",
        Logo = info.Logo or ""
    }

    local IconsModule = fetchModule("Icons/Lucide.Icons.lua")
    local WindowModule = fetchModule("components/Ww.lua")

    if not WindowModule then
        error("Stell FATAL: O módulo principal da Janela (Ww.lua) não pôde ser carregado. A UI não pode ser iniciada.")
        return
    end
    
    local windowInstance = WindowModule.new(config, {
        Icons = IconsModule,
        BaseURL = baseURL,
        FetchModule = fetchModule
    })
    
    return windowInstance
end

return Stell
