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
    local startTimer = GetGameTimer()
    local endTimer = startTimer + time
    local timerBar = addBar(startTimer, endTimer, startTimer, {title = title})
    while GetGameTimer() < endTimer do
        if reverse then
            remainingTime = endTimer - (GetGameTimer() - startTimer)
            updateBar(timerBar, remainingTime)
        else
            updateBar(timerBar, GetGameTimer())
        end
        Wait(0)
    end
    removeBar(timerBar)
    if callback then
        TriggerEvent(callback, data)
    end
end)
