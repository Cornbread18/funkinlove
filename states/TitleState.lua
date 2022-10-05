local TitleState = {}

local vcrfont = love.graphics.newFont('assets/fonts/vcr.ttf')
vcrfont:setFilter('linear','nearest')

function TitleState:enter()
	Objects.makeText('funny',vcrfont,'penis',100,100,'hud',true)
	--Objects.setProperty('funny','scale',{x=2,y=2})
	Objects.store.items['funny'].scale = {x=2,y=2}
	
	Objects.makeAnimSprite('bf','assets/images/DADDY_DEAREST.png',0,0,'game',true)
	--Objects.setProperty('bf','anim.curAnim','BF idle dance')
	Objects.store.items['bf'].anim.curAnim = 'BF Dead Loop'
end

return TitleState