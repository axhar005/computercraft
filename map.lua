rednet.open("side")
local layer = 0
local data_phones = {{0,{x = 0, y = 0, z = 0}}}
local data_rooms = {{x = 0, y = 0, z = 0, autorized = nil, receiver_id = 0, name = "", lpos = {x = 0, y = 0, z = 0}}}
local data = {phones = data_phones, rooms = data_rooms}
local pos = {x = 0, y = 0, z = 0}
local m = peripheral.wrap("top")
local old_term = term.redirect(m)
local width, height = m.getSize()
m.setTextScale(5)
m.setCursorPos(1, 1)

function draw_area()
    for i = 1, #data.rooms do
        paintutils.drawBox
    end
end

function is_in_area(playerPos, rectCorner1, rectCorner2)
    return
        playerPos.x >= math.min(rectCorner1.x, rectCorner2.x) and
        playerPos.x <= math.max(rectCorner1.x, rectCorner2.x) and
        playerPos.z >= math.min(rectCorner1.z, rectCorner2.z) and
        playerPos.z <= math.max(rectCorner1.z, rectCorner2.z) and
        playerPos.y >= math.min(rectCorner1.y, rectCorner2.y) and
        playerPos.y <= math.max(rectCorner1.y, rectCorner2.y)
end

function get_data()
    local sender_id, reply, message, protocol_distance = rednet.receive("lights_dispacher_440")
    if (sender_id == 24) then
        data = {phones = message[1], rooms = message[2]}
    end
end

while true do
    get_data()

end