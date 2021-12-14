local RESOURCE_NAME = GetCurrentResourceName()
local activeBars = {}

AddEventHandler('progress:bar:start', function (time, title, reverse, callback, data)
    print("Using the event trigger is deprecated, prefer using the exported function.")
    exports[RESOURCE_NAME]:timerBar(time, title, reverse, callback, data)
end)

exports('timerBar', function (time, title, reverse, callback, data)
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
    local startTimer = GetGameTimer()
    local endTimer = startTimer + time
    local timerBar = addBar(startTimer, endTimer, startTimer, {title = title})
    activeBars[timerBar] = true
    CreateThread(function ()
        while GetGameTimer() < endTimer and activeBars[timerBar] do
            if reverse then
                remainingTime = endTimer - (GetGameTimer() - startTimer)
                updateBar(timerBar, remainingTime)
            else
                updateBar(timerBar, GetGameTimer())
            end
            Wait(0)
        end
        removeBar(timerBar)
        if callback and activeBars[timerBar] then
            TriggerEvent(callback, data)
        end
        activeBars[timerBar] = nil
    end)
    return timerBar
end)

exports('cancelBar', function (barId)
    if activeBars[barId] then
        activeBars[barId] = nil
        return true
    end
    return false
end)
