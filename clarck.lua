-- clARCk
-- a clock for arc4
--
-- based on maxpat by JP
-- https://github.com/monome-community/collected/tree/master/clarck


local steps = {}
local aleds = {{},{},{},{}}

local tickcount = 0
local intensity = 1

local ar = arc.connect(1)

function init()
  lastsec = 0
  secs = 0
  
  counter = metro.init()
  counter.event = count
  counter.time = 1/60 -- interval
  counter.count = -1 -- run how long
  counter:start()
    
  ar:all(0) -- clear arc leds
  arc_redraw() -- redraw arc leds
  redraw() -- redraw norns screen
end

function count()
    now = os.date("*t")
    hour = now.hour
    mins = now.min
    secs = now.sec
 
    if (secs > lastsec) or (secs == 0) then
        tickcount = 0
    end
    --print(tickcount)

    if tickcount == 0 then 
        lastsec = secs
        aleds[1] = {}
        aleds[2] = {}
        aleds[3] = {}
        aleds[4] = {}
    end
   
    -- fill led arrays
    for i=1,64 do
        if i <= math.ceil(hour*2.7) then 
            if i==0 or i==16 or i==32 or i==48 then
                aleds[1][i] = 4
            else
                aleds[1][i] = 15
            end 
        else
            aleds[1][i] = 0
        end

        if i <= math.ceil(mins*1.07) then 
            if i==0 or i==16 or i==32 or i==48 then
                aleds[2][i] = 4
            else
                aleds[2][i] = 15 
            end
        else
            aleds[2][i] = 0
        end

        if i <= math.ceil(secs*1.07) then 
            if i==0 or i==16 or i==32 or i==48 then
                aleds[3][i] = 4 
            else
                aleds[3][i] = 15 
            end
         else
            aleds[3][i] = 0
        end

        if i <= math.ceil(tickcount*1.07) or tickcount == 0 then 
            aleds[4][i] = 15
        else
            aleds[4][i] = 0
        end
    end 
 
      
    if tickcount == 0 then -- every second
      for key,value in ipairs(aleds[1]) do ar:led(1, key, value) end
      for key,value in ipairs(aleds[2]) do ar:led(2, key, value) end
      for key,value in ipairs(aleds[3]) do ar:led(3, key, value) end
      redraw() 
    end

    -- every tick
    for key,value in ipairs(aleds[4]) do ar:led(4, key, value) end
      
    
    if tickcount == 60 then 
      tickcount = 0 
    end

    if hour == 0 then
        aleds[1] = {}
    end
    if mins == 0 then
        aleds[2] = {}
    end
    if secs == 0 then
        aleds[3] = {}
    end
    if tickcount == 0 then
        aleds[4] = {} 
    end
 
    arc_redraw() 
    tickcount = tickcount + 1
end

function ar.delta(n, delta)
    print ("enc: "..n)
    print ("delta: "..delta)
end
function ar.key(n, s)
    print ("enc: "..n)
    print ("state: "..s)
end


function arc_redraw()
    -- redraw 
    ar:refresh()
end

function redraw()
  -- clear screen
  screen.aa(1)
  screen.clear()
  -- set pixel brightness (0-15)
  screen.level(15)
  -- set text face
  screen.font_face(1)

  screen.move(3,10)
  -- set text size
  screen.font_size(8)
  -- draw text
  screen.text("CLARCK")

  screen.move(20,40)
  screen.font_face(5)
  -- set text size
  screen.font_size(18)
  -- draw text
  current_time = os.date("%H:%M:%S")
  screen.text(current_time)
  -- draw centered text
  screen.update()
end