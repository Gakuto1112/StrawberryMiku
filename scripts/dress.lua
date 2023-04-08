---@class DressClass 衣装のドレスとスカートを制御するクラス

DressClass = {}

events.TICK:register(function ()
	local dressTilt = (player:getPose() == "CROUCHING" and not client.getViewer():isFlying()) or player:getVehicle() ~= nil
	for _, modelPart in ipairs({models.models.main.Body.Dress, models.models.main.Body.Skirt}) do
		modelPart:setRot(dressTilt and 30 or 0, 0, 0)
	end
end)

return DressClass