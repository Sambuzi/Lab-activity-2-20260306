MAX_VELOCITY = 15
FORWARD = 10
TURN = 6
SLOW = 2

function init()
    robot.leds.set_all_colors("green")
end

function step()
    local left, right = FORWARD, FORWARD

    local prox_left = 0
    local prox_right = 0
    local light_left = 0
    local light_right = 0

    for i = 1, 3 do
        prox_left = prox_left + robot.proximity[i].value
        light_left = light_left + robot.light[i].value
    end

    for i = 22, 24 do
        prox_right = prox_right + robot.proximity[i].value
        light_right = light_right + robot.light[i].value
    end

    -- ostacolo molto vicino: evita
    if prox_left + prox_right > 0.15 then
        if prox_left > prox_right then
            left, right = FORWARD, SLOW
        else
            left, right = SLOW, FORWARD
        end

    -- vicino alla luce: fermati
    elseif light_left + light_right > 2.5 then
        left, right = 0, 0

    -- appena vede più luce a sinistra, gira a sinistra
    elseif light_left > light_right + 0.01 then
        left, right = TURN, FORWARD

    -- appena vede più luce a destra, gira a destra
    elseif light_right > light_left + 0.01 then
        left, right = FORWARD, TURN
    end

    robot.wheels.set_velocity(left, right)
end

function reset()
end

function destroy()
end