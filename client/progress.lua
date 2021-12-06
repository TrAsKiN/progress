local barWidth = 0.2
local spacing = 0.04
local progressBars = {}

AddEventHandler('progress:bar:start', function (time, title, reverse, callback, data)
    if not time then
        print("No time defined!")
        if callback then
            TriggerEvent(callback, data)
        end
        return
    end
    if not title then
        title = ''
    end
    local position = 1
    for index = 1, 24 do
        if progressBars[index] == nil then
            progressBars[index] = title .. index
            position = index
            break
        elseif index == 24 then
            print("The display is already full!")
            Wait(time)
            if callback then
                TriggerEvent(callback, data)
            end
            return
        end
    end
    CreateThread(function ()
        local barsAtStart = #progressBars
        local endTimer = GetGameTimer() + time
        while true do
            local bars = #progressBars
            if bars ~= barsAtStart then
                for index, barId in ipairs(progressBars) do
                    if barId == title .. position then
                        progressBars[index] = title .. index
                        position = index
                    end
                end
            end
            local height = 0.985 - (spacing * (position - 1))
            local gameTimer = GetGameTimer()
            if gameTimer >= endTimer then
                if callback then
                    TriggerEvent(callback, data)
                end
                table.remove(progressBars, position)
                return
            end
            local timeLeft = endTimer - gameTimer
            local width = (timeLeft * barWidth) / time
            DrawRect(0.5, height, barWidth, 0.0175, 0, 0, 0, 100)
            DrawRect(0.5, height, barWidth, 0.01, 255, 255, 255, 55)
            if reverse then
                DrawRect(0.5 - (barWidth - width) / 2, height, width, 0.01, 255, 255, 255, 170)
            else
                DrawRect(0.5 - width / 2, height, barWidth - width, 0.01, 255, 255, 255, 170)
            end
            if title then
                displayText(title, vector2((0.5 - barWidth / 2) - 0.0005, height - 0.027), {scale = 0.4, justify = 1, font = 7, colour = {red = 0, blue = 0, green = 0, alpha = 100}})
                displayText(title, vector2((0.5 - barWidth / 2) - 0.0014, height - 0.029), {scale = 0.4, justify = 1, font = 7})
            end
            Wait(0)
        end
    end)
end)

function displayText(text, position, params)
    if params  then
        if params.centre then
            SetTextCentre(params.centre)
        end
        if params.colour then
            SetTextColour(params.colour.red, params.colour.green, params.colour.blue, params.colour.alpha)
        end
        if params.shadow then
            if not params.shadow.distance then
                SetTextDropShadow()
            else
                SetTextDropshadow(params.shadow.distance, params.shadow.r, params.shadow.g, params.shadow.b, params.shadow.a)
            end
        end
        if params.font then
            SetTextFont(params.font)
        end
        if params.justify then
            SetTextJustification(params.justify)
        end
        if params.outline then
            SetTextOutline()
        end
        if params.scale then
            SetTextScale(1.0, params.scale)
        end
    end

    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(position.x, position.y)
end
