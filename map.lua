rednet.open("back")
local layer = {y_max = 0, x_max = 0}
local data_phones = {{0,{x = 0, y = 0, z = 0}}}
local data_rooms = {{x = 0, y = 0, z = 0, autorized = nil, receiver_id = 0, name = "", lpos = {x = 0, y = 0, z = 0}}}
local data = {phones = data_phones, rooms = data_rooms}
local map_len = 80
local center_origin = {x = 130, y = 60, z = 684}
local map_origin = {x = 130 + map_len/2, y = 60, z = 684 + map_len/2}
local m = peripheral.wrap("right")
local old_term = term.redirect(m)
local width, height = m.getSize()
local cal_x = width/(center_origin.x - (map_len/2))
local cal_y = height/(center_origin.y - (map_len/2))
m.setCursorPos(1, 1)
m.setTextScale(1)

function draw_area()
    for i = 1, #data.rooms do
        print(data.rooms[i].lpos.x - map_origin.x)
        print(data.rooms[i].lpos.z - map_origin.z)
        print(data.rooms[i].x - map_origin.x)
        print(data.rooms[i].z - map_origin.z)
       -- paintutils.drawBox(data.rooms[i].lpos.x - map_origin.x, data.rooms[i].lpos.z - map_origin.z, data.rooms[i].x - map_origin.x, data.rooms[i].z - map_origin.z, colors.green)
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
    local sender_id, message, protocol_distance = rednet.receive("lights_dispacher_440")
    if (sender_id == 24) then
        data = {phones = message[1], rooms = message[2]}
    end
end

while true do
    get_data()
    draw_area()

end