# A native progress bar for FiveM

A simple and complete native progress bar.

![Progress bar in game](progress_bar.gif)

## Usage

To use the progress bar you just have to call the function `exports.progress:timerBar()` with the following parameters:

- ***time***: **integer**, time in miliseconds
- ***title*** (*optional*): **string**, bar title
- ***reverse*** (*optional*): **boolean**, bar inversion
- ***callback*** (*optional*): **string**, event triggered at end of time
- ***data*** (*optional*): **any**, data sent with callback event

You can cancel a progress bar with the function `exports.progress:cancelBar()` with the ID returned by the previous function as parameter.

### Example

```lua
local myBar = exports.progress:timerBar(5000, "My Progress Bar", true, 'myCallbackEvent', {any = data, you = want})
Wait(2000)
exports.progress:cancelBar(myBar)
```

## Custom bars

Customize your bars with your values and the following functions:

- `exports.progress:addBar(min, max, state, params)`
- `exports.progress:updateBar(barId, state)`
- `exports.progress:removeBar(barId)`

### Example

```lua
local myBar = exports.progress:addBar(0, 6, 1, {title = "My Bar"})
-- waiting or handling an event
exports.progress:updateBar(myBar, 2)
-- waiting or other
exports.progress:removeBar(myBar)
```

## License

License under consideration...
