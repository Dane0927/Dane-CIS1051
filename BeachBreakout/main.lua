love.window.setTitle("Breakout")



player = {}


local pad = {}
pad.x = 0
pad.y = 0
pad.width = 80
pad.height = 20
pad.vx = 10


local ball = {}
ball.x = 0
ball.y = 0
ball.colle = false
ball.vx = 0
ball.vy = 0
ball.radius = 0
ball.acceleration = 1.03


local brick = {}
brick.width = 0
brick.height = 0


local level = {}
level.brick = {}


function newGame()
  
  
  level = {}
  
  
  ball.glue = true
  
  
  local l,c
  for l=1,8 do
    level[l] = {}
    for c=1,15 do
      level[l][c] = 1
    end
  end
  
  
  player.score = 0
  player.life = 3

end


function start()
  
  
  ball.glue = true
  
end

function love.load()

  
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  
  background = love.graphics.newImage("images/beach.jpg")
  
  
  padImage = love.graphics.newImage("images/man.png")
  pad.width = padImage:getWidth()
  pad.height = padImage:getHeight()
  
  
  ballImage = love.graphics.newImage("images/beachball.png")
  ball.x = ballImage:getWidth()/2
  ball.y = ballImage:getHeight()/2
  ball.radius = ballImage:getWidth()/2
  
  
  seagull = love.graphics.newImage("images/seagull.png")
  brick.width = width/15
  brick.height = seagull:getHeight()
  
  
  pad.y = height - 40
  pad.x = width/2
  
  
  newGame()
  
  
  explosion = love.audio.newSource("sounds/seagull.mp3", "stream")
  music = love.audio.newSource('sounds/beachNoises.mp3', 'stream')
  music:setLooping( true ) 
  music:play()
  
end

function love.update(dt)
  
    
  if player.life > 0 and love.keyboard.isDown("space") then
    if ball.glue == true then
      launchBall()
    end
  end

  
  if love.keyboard.isDown("right") then
      pad.x = pad.x + pad.vx
  elseif love.keyboard.isDown("left") then
      pad.x = pad.x - pad.vx
  end
  
  
  if pad.x <= pad.width/2 then
    pad.x = pad.width/2
  elseif pad.x >= width - pad.width/2 then
    pad.x = width - pad.width/2
  end
  
  
  if ball.glue == true then
    ball.x = pad.x
    ball.y = pad.y - ball.radius*2
  else 
    ball.x = ball.x + ball.vx*dt
    ball.y = ball.y + ball.vy*dt
  end
  
 
  local c = math.floor(ball.x / brick.width) + 1
  local l = math.floor(ball.y / brick.height) + 1
  
  
  if l >= 1 and l <= #level and c >= 1 and c <= 15 then
    if level[l][c] == 1 then
      explosion:play() 
      level[l][c] = 0 
      ball.vy = -ball.vy 
      ball.vy = ball.vy*ball.acceleration 
      player.score = player.score + 50 
    end
  end
  
  
  if ball.x >= width - ball.radius - 2 then
    ball.vx = -ball.vx
  elseif ball.x <= ball.radius + 2 then
    ball.vx = -ball.vx
  elseif ball.y <= ball.radius + 1 then
    ball.vy = -ball.vy
  end
  
  
  if ball.x >= (pad.x - pad.width/2 - 1) and ball.x <= (pad.x + pad.width/2 + 1) and ball.y >= (pad.y - pad.height/2 - ball.radius + 1) then
    if ball.y >= pad.y - pad.height/2 then
      ball.vx = -ball.vx
    else
      ball.vy = -ball.vy
    end
  end
  
  
  if ball.y >= height then
    player.life = player.life - 1 
    if player.life > 0 then
      start()
    else
      player.life = 0
      if love.keyboard.isDown("space") then
        ball.x = pad.x
        ball.y = pad.y - pad.height/2 - ball.radius
        newGame()
      end
    end
  end
  
end


function love.draw()
  
  
  love.graphics.draw(background, 0, 0)

  

  local postScore = "Score : "
  postScore = postScore..tostring(player.score)
  love.graphics.print(postScore, 5 , height - 25)
  

  local postLives = "Life : "
  postLives = postLives..tostring(player.life)
  love.graphics.print(postLives, width - 50, height - 25)
  
  
  if ball.glue and player.life > 0 then
    love.graphics.print("Scare away the Seagulls! Click SPACE to throw the ball", width/3, height/2)
  end
  
  if player.life <= 0 then
    love.graphics.print("You Lose! Click the SPACE button to play again", width/3, height/2)
  end
  
  

  local l,c
  local bx,by = 0,0 
  for l=1,8 do
    bx = 0 
    for c=1,15 do
      if level[l][c] == 1 then 
        
        love.graphics.draw(seagull, bx + 2, by + 2)
      end
      bx = bx + brick.width 
    end
    by = by + brick.height + 1 
  end
  
  
  love.graphics.draw(padImage, pad.x - (pad.width/2), pad.y - (pad.height/2))
  
  
  love.graphics.draw(ballImage, ball.x - (ball.radius), ball.y - (ball.radius))


end


function launchBall()
      if ball.glue == true then
        ball.glue = false
        ball.vx = 200
        ball.vy = -200
      end
end
  