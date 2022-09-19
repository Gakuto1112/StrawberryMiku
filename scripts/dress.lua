---@class DressClass 衣装のドレスとスカートを制御するクラス

DressClass = {}

events.TICK:register(function ()
	for _, modelPart in ipairs({models.models.main.Body.Dress, models.models.main.Body.Skirt}) do
		modelPart:setRot(((player:getPose() == "CROUCHING" and not player:isFlying()) or player:getVehicle()) and 30 or 0, 0, 0)
	end
end)

return DressClass