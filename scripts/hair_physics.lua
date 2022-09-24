---@class HairPhysicsClass 髪を制御するクラス
---@field HairRenderCount integer 髪の物理演算を計算した回数、上限計算に用いる。
---@field HairRenderLimit integer Renderの命令数上限に対する、髪の物理演算の頻度の係数
---@field VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field LookRotPrevRender number 前レンダーチックのlookRot
---@field LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta

HairPhysicsClass = {}

HairRenderCount = 0
HairRenderLimit = math.ceil(8192 / avatar:getMaxWorldRenderCount())
VelocityData = {{}, {}, {}, {}}
VelocityAverage = {0, 0, 0, 0}
LookRotPrevRender = 0
LookRotDeltaPrevRender = 0

events.RENDER:register(function ()
	--髪の物理演算（もどき）
	--直近1秒間のx方向、y方向、z方向の移動速度の平均を求める。
	local lookDir = player:getLookDir()
	local lookRot = math.deg(math.atan2(lookDir.z, lookDir.x))
	if HairRenderCount >= HairRenderLimit - 1 then
		local FPS = client:getFPS()
		local velocity = player:getVelocity()
		local velocityRot = math.deg(math.atan2(velocity.z, velocity.x))
		velocityRot = velocityRot < 0 and 360 + velocityRot or velocityRot
		local directionAbsFront = math.abs(velocityRot - (lookRot) % 360)
		directionAbsFront = directionAbsFront > 180 and 360 - directionAbsFront or directionAbsFront
		local directionAbsRight = math.abs(velocityRot - (lookRot + 90) % 360)
		directionAbsRight = directionAbsRight > 180 and 360 - directionAbsRight or directionAbsRight
		local relativeVelocity = {math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsFront)), math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsRight))}
		relativeVelocity[2] = lookDir.y < 0 and -relativeVelocity[2] or relativeVelocity[2]
		VelocityAverage[1] = (#VelocityData[1] * VelocityAverage[1] + relativeVelocity[1]) / (#VelocityData[1] + 1)
		table.insert(VelocityData[1], relativeVelocity[1])
		VelocityAverage[2] = (#VelocityData[2] * VelocityAverage[2] + velocity.y) / (#VelocityData[2] + 1)
		table.insert(VelocityData[2], velocity.y)
		VelocityAverage[3] = (#VelocityData[3] * VelocityAverage[3] + relativeVelocity[2]) / (#VelocityData[3] + 1)
		table.insert(VelocityData[3], relativeVelocity[2])
		local lookRotDelta = lookRot - LookRotPrevRender
		lookRotDelta = lookRotDelta > 180 and 360 - lookRotDelta or (lookRotDelta < -180 and 360 + lookRotDelta or lookRotDelta)
		local lookRotDeltaPerSecond = lookRotDelta * FPS
		if lookRotDelta < 20 and lookRotDelta ~= LookRotDeltaPrevRender then
			VelocityAverage[4] = (#VelocityData[4] * VelocityAverage[4] + lookRotDeltaPerSecond) / (#VelocityData[4] + 1)
			table.insert(VelocityData[4], lookRotDeltaPerSecond)
		else
			VelocityAverage[4] = (#VelocityData[4] * VelocityAverage[4]) / (#VelocityData[4] + 1)
			table.insert(VelocityData[4], 0)
		end
		--古いデータの切り捨て
		for index, velocityTable in ipairs(VelocityData) do
			while #velocityTable > FPS * 0.25 / HairRenderLimit do
				if #velocityTable >= 2 then
					VelocityAverage[index] = (#velocityTable * VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
				end
				table.remove(velocityTable, 1)
			end
		end
		local rightHair = models.models.main.Head.HeadTails.HeadTailRightPivot
		local leftHair = models.models.main.Head.HeadTails.HeadTailLeftPivot
		local backRibbon = models.models.main.Body.Dress.BackRibbonTop.BackRibbonTopLine
		if not renderer:isFirstPerson() or client:hasIrisShader() then
			--求めた平均から髪の角度を決定する。
			local VelocityAverageXWithLimit = math.min(math.max(VelocityAverage[1], -0.6), 0.6)
			local hairLimit = {{-170, 80}, {-60, 60}, {-60, -25}} --1. 髪前後, 2. 髪左右, 3. 背中のリボン
			if General.hasItem(player:getItem(5)) == "minecraft:elytra" then
				hairLimit[3] = {-25, -25}
			end
			local playerPose = player:getPose()
			if playerPose == "FALL_FLYING" then
				hairLimit[1] = {-40, 80}
				rightHair:setRot(math.clamp(hairLimit[1][2] - math.sqrt(VelocityAverageXWithLimit ^ 2 + VelocityAverage[2] ^ 2) * 80, hairLimit[1][1], hairLimit[1][2]), math.clamp(-VelocityAverageXWithLimit * 20 + VelocityAverage[4] * 0.05, hairLimit[2][1], hairLimit[2][2]), 0)
				leftHair:setRot(math.clamp(hairLimit[1][2] - math.sqrt(VelocityAverageXWithLimit ^ 2 + VelocityAverage[2] ^ 2) * 80, hairLimit[1][1], hairLimit[1][2]), math.clamp(VelocityAverageXWithLimit * 20 + VelocityAverage[4] * 0.05, hairLimit[2][1], hairLimit[2][2]), 0)
				backRibbon:setRot(hairLimit[3][2], 0, 0)
			elseif playerPose == "SWIMMING" then
				hairLimit[1] = {-40, 80}
				rightHair:setRot(math.clamp(hairLimit[1][2] - math.sqrt(VelocityAverageXWithLimit ^ 2 + VelocityAverage[2] ^ 2) * 320, hairLimit[1][1], hairLimit[1][2]), math.clamp(-VelocityAverageXWithLimit * 80 + VelocityAverage[4] * 0.1, hairLimit[2][1], hairLimit[2][2]), 0)
				leftHair:setRot(math.clamp(hairLimit[1][2] - math.sqrt(VelocityAverageXWithLimit ^ 2 + VelocityAverage[2] ^ 2) * 320, hairLimit[1][1], hairLimit[1][2]), math.clamp(VelocityAverageXWithLimit * 80 + VelocityAverage[4] * 0.1, hairLimit[2][1], hairLimit[2][2]), 0)
				backRibbon:setRot(hairLimit[3][2], 0, 0)
			else
				local angularVelocityAbs = math.abs(VelocityAverage[4])
				if math.floor(VelocityAverage[2] * 100 + 0.5) / 100 < 0 then
					rightHair:setRot(math.clamp(-VelocityAverageXWithLimit * 120 + VelocityAverage[2] * 80 - angularVelocityAbs * 0.03, hairLimit[1][1], hairLimit[1][2]) - lookDir.y * 90, math.clamp(-VelocityAverageXWithLimit * 20 - VelocityAverage[2] * 20 - VelocityAverage[3] * 240 + VelocityAverage[4] * 0.05 - angularVelocityAbs * 0.005, hairLimit[2][1], hairLimit[2][2]), 0)
					leftHair:setRot(math.clamp(-VelocityAverageXWithLimit * 120 + VelocityAverage[2] * 80 - angularVelocityAbs * 0.03, hairLimit[1][1], hairLimit[1][2]) - lookDir.y * 90, math.clamp(VelocityAverageXWithLimit * 20 + VelocityAverage[2] * 20 - VelocityAverage[3] * 240 + VelocityAverage[4] * 0.05 - angularVelocityAbs * 0.005, hairLimit[2][1], hairLimit[2][2]), 0)
					backRibbon:setRot(math.clamp(-VelocityAverageXWithLimit * 160 + VelocityAverage[2] * 80 - angularVelocityAbs * 0.05, hairLimit[3][1], hairLimit[3][2]), 0, 0)
				else
					rightHair:setRot(math.clamp(-VelocityAverageXWithLimit * 120 - angularVelocityAbs * 0.03, hairLimit[1][1], hairLimit[1][2]) - lookDir.y * 90, math.clamp(-VelocityAverageXWithLimit * 20 - VelocityAverage[3] * 240 + VelocityAverage[4] * 0.05 - angularVelocityAbs * 0.005, hairLimit[2][1], hairLimit[2][2]), 0)
					leftHair:setRot(math.clamp(-VelocityAverageXWithLimit * 120 - angularVelocityAbs * 0.03, hairLimit[1][1], hairLimit[1][2]) - lookDir.y * 90, math.clamp(VelocityAverageXWithLimit * 20 - VelocityAverage[3] * 240 + VelocityAverage[4] * 0.05 - angularVelocityAbs * 0.005, hairLimit[2][1], hairLimit[2][2]), 0)
					backRibbon:setRot(math.clamp(-VelocityAverageXWithLimit * 160 - angularVelocityAbs * 0.05, hairLimit[3][1], hairLimit[3][2]), 0, 0)
				end
			end
		else
			rightHair:setRot(0, 0, 0)
			leftHair:setRot(0, 0, 0)
			backRibbon:setRot(-25, 0, 0)
		end
		HairRenderCount = 0
		LookRotDeltaPrevRender = lookRotDelta
		LookRotPrevRender = lookRot
	elseif not client.isPaused() then
		HairRenderCount = HairRenderCount + 1
	end
end)

return HairPhysicsClass