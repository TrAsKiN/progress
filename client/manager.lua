local guid = 1
local barsData = {}
local barsOrdered = {}

local function doesBarExist(id)
    for barId, _ in pairs(barsData) do
        if barId == id then
            return true
        end
    end
    return false
end

local function getId()
    local newId = guid
    while doesBarExist(newId) do
        guid = guid + 1
        newId = guid
    end
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
    local barWidthInPixel = 400
    local barHeightInPixel = 10
    local spacingInPixel = 20
    local shadowOffset = 2
    local textOffsetX = 3
    local textOffsetY = 20
    while true do
        if #barsOrdered > 0 then
            local screenW, screenH = GetActiveScreenResolution()
            local safeZone = GetSafeZoneSize()
            local barWidth = barWidthInPixel / screenW
            local barHeight = barHeightInPixel / screenH
            local spacing = spacingInPixel / screenH
            for position, barId in pairs(barsOrdered) do
                local barData = barsData[barId]
                local barMax = barData.max - barData.min
                local barState = barData.state - barData.min
                local y = safeZone - (spacing * 2 * (position - 1))
                local width = ((barMax - barState) * barWidth) / barMax
                DrawRect(0.5, y, barWidth, barHeight + (8 / screenH), 0, 0, 0, 100) -- background
                DrawRect(0.5, y, barWidth, barHeight, 255, 255, 255, 55) -- bar background
                DrawRect(0.5 - width / 2, y, barWidth - width, barHeight, 255, 255, 255, 170) -- bar
                if barData.options and barData.options.title then
                    drawText(barData.options.title, vector2(((0.5 - textOffsetX / screenW) - barWidth / 2) + (shadowOffset / screenW), y - (barHeightInPixel + textOffsetY - shadowOffset) / screenH), {r = 0, b = 0, g = 0, a = 100}) -- shadow
                    drawText(barData.options.title, vector2(((0.5 - textOffsetX / screenW) - barWidth / 2), y - (barHeightInPixel + textOffsetY) / screenH)) -- title
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

function addBar(min, max, state, options)
    local barId = getId()
    barsData[barId] = {
        min = min,
        max = max,
        state = state,
        options = options
    }
    table.insert(barsOrdered, barId)
    return barId
end

function updateBar(barId, state, options)
    if doesBarExist(barId) then
        barsData[barId].state = state
        if options then
            barsData[barId].options = options
        end
        return true
    end
    return false
end

function removeBar(barId)
    if doesBarExist(barId) then
        barsData[barId] = nil
        for position, barIdToRemove in ipairs(barsOrdered) do
            if barIdToRemove == barId then
                table.remove(barsOrdered, position)
                return true
            end
        end
    end
    return false
end
