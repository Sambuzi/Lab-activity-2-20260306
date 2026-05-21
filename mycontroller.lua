--constant for my code (trying to make it more readable)
MAX_VELOCITY = 15
FORWARD = 10
TURN = 5
SLOW = 2

LIGHT_REACHED = 2.5
OBSTACLE_CLOSE = 0.15

function init()
    robot.leds.set_all_colors("green")
end

function step()
    local left, right = FORWARD, FORWARD

    local front_prox = 0
    local left_prox = 0
    local right_prox = 0
    local light_total = 0
    local light_left = 0
    local light_right = 0

    for i = 1, 24 do
        local light = robot.light[i].value
        light_total = light_total + light
        if i <= 12 then
            light_left = light_left + light
        else
            light_right = light_right + light
        end
    end

    for i = 1, 4 do
        left_prox = left_prox + robot.proximity[i].value
    end
    for i = 21, 24 do
        right_prox = right_prox + robot.proximity[i].value
    end
    front_prox = left_prox + right_prox

    -- Stop when the robot is close to the light.
    if light_total > LIGHT_REACHED then
        left, right = 0, 0

    -- Avoid obstacles in front of the robot.
    elseif front_prox > OBSTACLE_CLOSE then
        if left_prox > right_prox then
            left, right = FORWARD, SLOW
        else
            left, right = SLOW, FORWARD
        end

    -- Move towards the brighter side. Same as obs avoidance.
    elseif light_left > light_right + 0.05 then
        left, right = TURN, FORWARD
    elseif light_right > light_left + 0.05 then
        left, right = FORWARD, TURN
    end

    if left > MAX_VELOCITY then
        left = MAX_VELOCITY
    end
    if right > MAX_VELOCITY then
        right = MAX_VELOCITY
    end

    robot.wheels.set_velocity(left, right)
end

function reset()
end

function destroy()
end
