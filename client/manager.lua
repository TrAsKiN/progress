local guid = 1
local barsData = {}
local barsOrdered = {}

local function getId()
    local newId = guid
    guid = guid + 1
    -- todo: check if id already exists
    return newId
end

local function drawText(text, position, color)
    SetTextScale(1.0, 0.4)
    SetTextJustification(1)
    SetTextFont(7)
    if color then
        SetTextColour(color.r, color.g, color.b, color.a)
    end
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(position)
end

CreateThread(function ()
    local barWidth = 0.2
    local spacing = 0.04
    while true do
        if #barsOrdered > 0 then
            for position, barId in pairs(barsOrdered) do
                local barData = barsData[barId]
                local barMax = barData.max - barData.min
                local barState = barData.state - barData.min
                local height = 0.985 - (spacing * (position - 1))
                local width = ((barMax - barState) * barWidth) / barMax
                DrawRect(0.5, height, barWidth, 0.0175, 0, 0, 0, 100)
                DrawRect(0.5, height, barWidth, 0.01, 255, 255, 255, 55)
                DrawRect(0.5 - width / 2, height, barWidth - width, 0.01, 255, 255, 255, 170)
                if barData.params.title then
                    drawText(barData.params.title, vector2((0.5 - barWidth / 2) - 0.0005, height - 0.027), {r = 0, b = 0, g = 0, a = 100})
                    drawText(barData.params.title, vector2((0.5 - barWidth / 2) - 0.0014, height - 0.029))
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

function addBar(min, max, state, params)
    local barId = getId()
    barsData[barId] = {
        min = min,
        max = max,
        state = state,
        params = params
    }
    table.insert(barsOrdered, barId)
    return barId
end

function updateBar(barId, state)
    barsData[barId].state = state
end

function removeBar(barId)
    barsData[barId] = nil
    for position, barIdToRemove in ipairs(barsOrdered) do
        if barIdToRemove == barId then
            table.remove(barsOrdered, position)
            break
        end
    end
end
