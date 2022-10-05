Objects = {}

local xml2lua = require('xml2lua')

Objects.store = {
	items = {},
	reserve = {
		game = {
			visible = true,
			position = {
				x = 0,
				y = 0,
			},
			offset = {
				x = 0,
				y = 0,
			},
			scale = 1,
			angle = 0,
		},
		hud = {
			visible = true,
			position = {
				x = 0,
				y = 0,
			},
			offset = {
				x = 0,
				y = 0,
			},
			scale = 1,
			angle = 0,
		},
		other = {
			visible = true,
			position = {
				x = 0,
				y = 0,
			},
			offset = {
				x = 0,
				y = 0,
			},
			scale = 1,
			angle = 0,
		}
	},
}

--this will hold love.graphics.newImage shit later so it doesnt get reloaded everytime a new sprite is made with the image :)
Objects.cache = {
}

--internal resolution of sprites, doesnt affect
local deswidth,desheight = 1280,720

local missingpath = 'assets/images/love.png'
local missing = love.graphics.newImage(missingpath)

function Objects.getCache(file,type,create)
	if Objects.cache[file] then
		return Objects.cache[file]
	elseif create then
		if type == 'image' then
			Objects.cache[file] = love.graphics.newImage(file)
			return Objects.cache[file]
		end
	end
	return nil
end

function Objects.refresh(arr)
	local refreshed = {}
	for i,obj in pairs(arr) do
		refreshed[i] = obj
	end
	return refreshed
end

function itemOrder(a,b)
	if a.cam ~= b.cam then
		return reserve[a.cam].order < reserve[b.cam].order
	end
	if a.layer ~= b.layer then
		return a.layer < b.gorder
	end
	return a.zorder < b.zorder
end

local function objArray(objtype,camdes,x,y,visible)
	local newsprite = {
		type = objtype,
		cam = camdes,
		pos = {
			x = x,
			y = y,
		},
		scale = {
			x=1,
			y=1,
		},
		zorder = 0,
		layer = 0,
		visible = visible
	}
	return newsprite
end

local function removeObj(tag)
	if not Objects.store.reserve[tag] and Objects.store.items[tag] then
		local copy = Objects.store.items[tag]
		Objects.store.items[tag] = nil
		
		Objects.store.items = refresh
		table.sort(Objects.store.items,itemOrder)
		return copy
	end
	return nil
end

local function spaceNum(num,space)
	return string.format(("%0"..space..'d'),num)
end

function Objects.draw()
	--scaling to window (internal resolution)
	local width,height = love.graphics.getDimensions()
	local aspect = deswidth/desheight
	local scaler
	local xof,yof = 0,0
	if width/height >= aspect then
		scaler = height/desheight
		xof = (width-deswidth*scaler)/2
	else
		scaler = width/deswidth
		yof = (height-desheight*scaler)/2
	end
	--local shader = love.graphics.newShader(love.filesystem.read('assets/shaders/bloom.fs'))
	--love.graphics.setShader(shader)
	--drawing camera Objects
	local cam
	local cam2
	local camobj
	local instance
	love.graphics.push()
	for j,obj in pairs(Objects.store.items) do
		cam = obj.cam
		if Objects.store.reserve[cam].visible and obj.visible then
			if cam2 ~= cam then
				cam2 = cam
				camobj = Objects.store.reserve[cam]
				love.graphics.pop()
				love.graphics.push()
				love.graphics.translate(xof,yof)
				love.graphics.scale((camobj.scale)*scaler)
				love.graphics.rotate(camobj.angle)
			end
			if obj.inst then
				if obj.type == 'sprite' then
					if love.filesystem.isFile(obj.inst) then
						instance = 
					else
						instance = missing
					end
				end
			else
				instance = missing
			end
			love.graphics.draw(instance,(obj.pos.x-camobj.position.x)*obj.scrollFactor.x,(obj.pos.y-camobj.position.y)*obj.scrollFactor.y,obj.angle,obj.scale.x,obj.scale.y)
		end
	end
	love.graphics.pop()
end

function Objects.makeSprite(tag,image,x,y,cam,visible) --makes sprite in given camera, returns the object array
	if Objects.store.reserve[tag] then return end 
	cam = cam or 'hud'
	visible = visible or true
	local newsprite = objArray('img',cam,x,y,visible)
	newsprite.inst = Objects.getCache(image,'image',true)
	newsprite.angle = 0
	
	newsprite.scrollFactor = {x=1,y=1}
	
	Objects.store.items[tag] = newsprite
	
	table.sort(Objects.store.items,itemOrder)
	
	return Objects.store.items[tag]
end

--iffy keeps giving errors. why must i suffer like this 
function Objects.makeAnimSprite(tag,image,x,y,cam,visible) --makes sprite in given camera, returns the object array
	if Objects.store.reserve[tag] then return end
	cam = cam or 'hud'
	visible = visible or true
	local newsprite = objArray('sprite',cam,x,y,visible)
	newsprite.inst = image
	--newsprite.atlas = Iffy.newAtlas(image)
	newsprite.angle = 0

	newsprite.anim = {
		curAnim = 'idle',
		frame = 0,
		fps = 12,
	}
	
	newsprite.scrollFactor = {x=1,y=1}
	
	Objects.store.items[tag] = newsprite
	
	table.sort(Objects.store.items,itemOrder)
	
	return Objects.store.items[tag]
end

function Objects.destroy(tag)
	removeObj(tag)
end

--[[function Objects.setProperty(tag,prop,value,resort) --DEPRECATED UNTIL BETTER ALTERNATIVE IS FOUND. JUST USE THE ACTUAL ARRAY!!
	for _,cam in pairs(Objects.store) do
		if cam.items[tag] then
			cam.items[tag][prop] = value
			if resort then
				table.sort(Objects.store.items,itemOrder)
			end
			return cam.items[tag]
		end
	end
	print('property dont exist')
	return nil
end

function Objects.getProperty(tag,prop)
	for _,cam in pairs(Objects.store) do
		if cam.items[tag] then
			return cam.items[tag] 
		end
	end
	print('property dont exist')
	return nil
end--]]

--[[function Objects.changeCam(tag,cam) --DEPRECATED FOR NOW 
	local check = removeObj(tag)
	if check then
		cam.items[tag] = check
		return check
	end
	return nil
end--]]

function Objects.makeText(tag,font,text,x,y,cam,visible)
	local newtext = objArray('text',cam,x,y,visible)
	newtext.inst = love.graphics.newText(font,text)
	
	newtext.scrollFactor = {x=1,y=1}
	
	Objects.store.items[tag] = newtext
	
	
	table.sort(Objects.store.items,itemOrder)
	
	return Objects.store.items[tag]
end

function Objects.fluxPos(tag,dur,prop,tx,ty)
	for _,cam in pairs(Objects.store) do
		if cam.items[tag] then
			if cam.items[tag][prop] then
				if not ty then ty = cam.items[tag][prop][y] end
				if not tx then tx = cam.items[tag][prop][x] end
				return flux.to(prop,dur,{x=tx,y=ty})
			end
		end
	end
	return nil
end

--function Objects.

--[[function Objects.makeLetters(tag,text,x,y,bold)
	cam = cam or 'hud' 
	visible = visible or true
	local newsprite = {}
	newsprite.text = text
	newsprite.type = 'letters'
	newsprite.x = x
	newsprite.y = y
	newsprite.visible = visible
	newsprite.angle = 0
end--]]

function love.draw()
	Objects.draw()
end

return Objects

