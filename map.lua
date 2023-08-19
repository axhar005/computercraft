rednet.open("left")                 -- open rednet
local m = peripheral.wrap("back")  -- connect to the "side" minitor
local old_term = term.redirect(m)   -- redirect term to a screen

-- need to be set
local center_origin = {x = 130, y = 60, z = 684}    -- the middle of the base
local map_len = 160                                 -- square base size in x and z

-- variable
local layer = {y_min = 0, y_max = 0}                                                                                    -- floor layer between y_min and y_max
local data_phones = {{0,{x = 0, y = 0, z = 0}}}                                                                         -- empty load juste for autocomplete
local data_rooms = {{x = 0, y = 0, z = 0, autorized = nil, receiver_id = 0, name = "", lpos = {x = 0, y = 0, z = 0}}}   -- empty load juste for autocomplete
local data = {phones = data_phones, rooms = data_rooms}                                                                 -- empty load juste for autocomplete
local map_origin = {x = 130 + map_len/2, y = 60, z = 684 + map_len/2}                                                   -- the bigger size of your base ( corner left of the screen ) 
local width, height = m.getSize()                                                                                       -- window size
local cal_x = width/map_len                                                                                             -- ratio size in x
local cal_z = height/map_len                                                                                            -- ratio size in z
local col = {
    colors.orange,
    colors.blue,
    colors.brown,
    colors.purple,
    colors.cyan,
    colors.pink,
    colors.magenta
}

-- set window
m.setCursorPos(1, 1)
m.setTextScale(0.5)
m.setTextColor(colors.orange)


-- function
function is_in_area(playerPos, rectCorner1, rectCorner2)
    return
        playerPos.x >= math.min(rectCorner1.x, rectCorner2.x) and
        playerPos.x <= math.max(rectCorner1.x, rectCorner2.x) and
        playerPos.z >= math.min(rectCorner1.z, rectCorner2.z) and
        playerPos.z <= math.max(rectCorner1.z, rectCorner2.z) and
        playerPos.y >= math.min(rectCorner1.y, rectCorner2.y) and
        playerPos.y <= math.max(rectCorner1.y, rectCorner2.y)
end

function draw_centered_text(x, y, text, textColor, backgroundColor)
    local textWidth = #text
    local startX = x - math.floor(textWidth / 2)
    m.setCursorPos(startX, y)
    m.setTextColor(textColor)
    m.setBackgroundColor(backgroundColor)
    m.write(text)
end


function draw_area()
    for i = 1, #data.rooms do
        local posX = ((data.rooms[i].lpos.x - map_origin.x) * cal_x) * -1
        local posZ = ((data.rooms[i].lpos.z - map_origin.z) * cal_z) * -1
        local posXX = ((data.rooms[i].x - map_origin.x)* cal_x) * -1
        local posZZ = ((data.rooms[i].z - map_origin.z)* cal_z) * -1
        local text = data.rooms[i].name
        paintutils.drawBox(posX, posZ, posXX, posZZ, colors.green)
        draw_centered_text(posX - ((posX - posXX) / 2), posZ + 1, text, colors.white, colors.lime)
    end
    for i = 1, #data.phones do
        local posX = ((data.phones[i][2].x - map_origin.x) * cal_x) * -1
        local posZ = ((data.phones[i][2].z - map_origin.z) * cal_z) * -1
        local text = tostring(math.floor(data.phones[i][1]))
        draw_centered_text(posX, posZ, text, colors.white, col[i])
    end
end 

function clear_window()
    m.setCursorPos(1, 1)
    m.setTextScale(0.5)
    m.setBackgroundColor(colors.black)
    m.clear()
end

function get_data()
    local sender_id, message, protocol_distance = rednet.receive("lights_dispacher_440")
    if (sender_id == 24) then
        data = {phones = message[1], rooms = message[2]}
    end
end

-- main loop
while true do
    get_data()
    clear_window()
    draw_area()
end
