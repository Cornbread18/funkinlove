local prefs = {}

prefs.binds = {
	["left"]={'left','a'},
	["down"]={'down','s'},
	["right"]={'right','d'},
	["up"]={'up','w'},
	["enter"]={'return','space'},
	["back"]={'escape'}
}

prefs.settings = {
	flashingLights = false,
	shaders = false
}

function prefs.isPressed(input)
	if not prefs.binds[input] then return end
	if love.keyboard.isDown(prefs.binds[input]) then return true end
	return false
end

--final checks
local supported = love.graphics.getSupported()
if supported.glsl3 then 
	prefs.settings.shaders = true 
	print('glsl3 supported: have fun lol')
else
	print('glsl3 unsupported: shaders have been disabled!!')
end

return prefs