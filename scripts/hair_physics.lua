---@class HairPhysicsClass 髪を制御するクラス
---@field VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field LookRotPrevRender number 前レンダーチックのlookRot
---@field LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta

HairPhysicsClass = {}

VelocityData = {{}, {}, {}, {}}
VelocityAverage = {0, 0, 0, 0}
LookRotPrevRender = 0
LookRotDeltaPrevRender = 0

events.RENDER:register(function ()
	--髪の物理演算（もどき）
	--直近1秒間のx方向、y方向、z方向の移動速度の平均を求める。
	local lookDir = player:getLookDir()
	local lookRot = math.deg(math.atan2(lookDir.z, lookDir.x))
	local FPS = client:getFPS()
	local velocity = player:getVelocity()
	local velocityRot = math.deg(math.atan2(velocity.z, velocity.x))
	velocityRot = velocityRot < 0 and 360 + velocityRot or velocityRot
	local directionAbsFront = math.abs(velocityRot - (lookRot) % 360)
	directionAbsFront = directionAbsFront > 180 and 360 - directionAbsFront or directionAbsFront
	local directionAbsRight = math.abs(velocityRot - (lookRot + 90) % 360)
	directionAbsRight = directionAbsRight > 180 and 360 - directionAbsRight or directionAbsRight
	local relativeVelocity = {math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsFront)), math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsRight))}
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
		while #velocityTable > FPS * 0.25 do
			if #velocityTable >= 2 then
				VelocityAverage[index] = (#velocityTable * VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
			end
			table.remove(velocityTable, 1)
		end
	end
	local rightHair = models.models.main.Head.HeadTails.HeadTailRightPivot
	local leftHair = models.models.main.Head.HeadTails.HeadTailLeftPivot
	local rightHeadRibbon = models.models.main.Head.Brim.BrimOrnaments.BrimRight.BrimRightRibbon.BrimRightRibbonLine
	local leftHeadRibbon = models.models.main.Head.Brim.BrimOrnaments.BrimLeft.BrimLeftRibbon.BrimLeftRibbonLine
	local rightArmRibbon = models.models.main.RightArm.RightSwellingRibbon.RightSwellingRibbonLine
	local leftArmRibbon = models.models.main.LeftArm.LeftSwellingRibbon.LeftSwellingRibbonLine
	local dressRibbon = models.models.main.Body.Dress.Dress1.DressRibbon.DressRibbonLine
	local backRibbon = models.models.main.Body.Dress.BackRibbonTop.BackRibbonTopLine
	if not renderer:isFirstPerson() or client:hasIrisShader() then
		--求めた平均から髪の角度を決定する。
		local rotLimit = {{-170, 80}, {-60, 60}, {-60, -25}, {-170, 80}, {30, 100}, {-100, -30}, {0, 70}, {-60, 60}, {-150, 0}, {0, 150}} --1. 髪前後, 2. 髪左右, 3. 背中のリボン, 4. ブリムのリボン前後, 5. ブリムのリボン右左右, 6. ブリムのリボン左左右, 7. ドレスのリボン, 8. 腕のリボン前後, 9. 右腕のリボン左右, 10. 左腕のリボン左右
		if General.hasItem(player:getItem(5)) == "minecraft:elytra" then
			rotLimit[3] = {-25, -25}
		end
		local playerPose = player:getPose()
		if playerPose == "FALL_FLYING" then
			rotLimit[1] = {-40, 80}
			rotLimit[4] = {-40, 80}
			rotLimit[8] = {0, 60}
			rightHair:setRot(math.clamp(rotLimit[1][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 80, rotLimit[1][1], rotLimit[1][2]), math.clamp(-VelocityAverage[1] * 20 + VelocityAverage[4] * 0.05, rotLimit[2][1], rotLimit[2][2]), 0)
			leftHair:setRot(math.clamp(rotLimit[1][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 80, rotLimit[1][1], rotLimit[1][2]), math.clamp(VelocityAverage[1] * 20 + VelocityAverage[4] * 0.05, rotLimit[2][1], rotLimit[2][2]), 0)
			rightHeadRibbon:setRot(math.clamp(rotLimit[4][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 120, rotLimit[4][1], rotLimit[4][2]), 0, 30)
			leftHeadRibbon:setRot(math.clamp(rotLimit[4][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 120, rotLimit[4][1], rotLimit[4][2]), 0, -30)
			rightArmRibbon:setRot(0, 0, math.clamp(rotLimit[8][2] - VelocityAverage[1] * 80, rotLimit[8][1], rotLimit[8][2]))
			leftArmRibbon:setRot(0, 0, math.clamp(rotLimit[8][2] - VelocityAverage[1] * 80, rotLimit[8][1], rotLimit[8][2]))
			dressRibbon:setRot(0, 0, 0)
			backRibbon:setRot(rotLimit[3][2], 0, 0)
		elseif playerPose == "SWIMMING" then
			rotLimit[1] = {-40, 80}
			rotLimit[4] = {-40, 80}
			rotLimit[8] = {-180, -120}
			rightHair:setRot(math.clamp(rotLimit[1][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 320, rotLimit[1][1], rotLimit[1][2]), math.clamp(-VelocityAverage[1] * 80 + VelocityAverage[4] * 0.1, rotLimit[2][1], rotLimit[2][2]), 0)
			leftHair:setRot(math.clamp(rotLimit[1][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 320, rotLimit[1][1], rotLimit[1][2]), math.clamp(VelocityAverage[1] * 80 + VelocityAverage[4] * 0.1, rotLimit[2][1], rotLimit[2][2]), 0)
			rightHeadRibbon:setRot(math.clamp(rotLimit[4][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 320, rotLimit[4][1], rotLimit[4][2]), 0, 30)
			leftHeadRibbon:setRot(math.clamp(rotLimit[4][2] - math.sqrt(VelocityAverage[1] ^ 2 + VelocityAverage[2] ^ 2) * 320, rotLimit[4][1], rotLimit[4][2]), 0, -30)
			rightArmRibbon:setRot(-40, 0, math.clamp(-VelocityAverage[1] * 160 - 120, rotLimit[8][1], rotLimit[8][2]))
			leftArmRibbon:setRot(40, 0, math.clamp(-VelocityAverage[1] * 160 - 120, rotLimit[8][1], rotLimit[8][2]))
			dressRibbon:setRot(0, 0, 0)
			backRibbon:setRot(rotLimit[3][2], 0, 0)
		else
			local hairXMoveX = -VelocityAverage[1] * 120
			local hairXMoveY = VelocityAverage[2] * 80
			local hairXAngleMove = -math.abs(VelocityAverage[4] * 0.03)
			local hairYZMoveX = -VelocityAverage[1] * 20
			local hairYZMoveZ = -VelocityAverage[3] * 90
			local hairYZAngleMove = VelocityAverage[4] * 0.03
			local rightHairYZ = math.clamp(math.max(hairYZMoveX, math.min(-30 - hairYZMoveZ - hairYZAngleMove, 0)) + hairYZMoveZ + hairYZAngleMove, rotLimit[2][1], rotLimit[2][2])
			local leftHairYZ = math.clamp(math.max(-hairYZMoveX, math.min(-30 - hairYZMoveZ - hairYZAngleMove, 0)) + hairYZMoveZ + hairYZAngleMove, rotLimit[2][1], rotLimit[2][2])
			local rightHairRotX = rightHair:getRot().x
			local leftHairRotX = leftHair:getRot().x
			local headRibbonXMoveX = -VelocityAverage[1] * 160
			local headRibbonXAngleMove = -math.abs(VelocityAverage[4] * 0.05)
			local armRibbonXMoveZ = VelocityAverage[3] * 80
			rightHair:setRot(math.clamp(math.max(hairXMoveX, math.min(-70 + hairXMoveY - hairXAngleMove, 0)) + math.min(hairXMoveY, math.max(10 - hairXMoveX - hairXAngleMove, 0)) + math.max(hairXAngleMove, math.min(-70 - hairXMoveX + hairXMoveY, 0)), rotLimit[1][1], rotLimit[1][2]) - lookDir.y * 90, rightHairYZ * -math.sin(math.rad(rightHairRotX)), rightHairYZ * math.cos(math.rad(rightHairRotX)))
			leftHair:setRot(math.clamp(math.max(hairXMoveX, math.min(-70 + hairXMoveY - hairXAngleMove, 0)) + math.min(hairXMoveY, math.max(10 - hairXMoveX - hairXAngleMove, 0)) + math.max(hairXAngleMove, math.min(-70 - hairXMoveX + hairXMoveY, 0)), rotLimit[1][1], rotLimit[1][2]) - lookDir.y * 90, leftHairYZ * -math.sin(math.rad(leftHairRotX)), leftHairYZ * math.cos(math.rad(leftHairRotX)))
			rightHeadRibbon:setRot(math.clamp(math.max(headRibbonXMoveX, math.min(-80 + hairXMoveY + headRibbonXAngleMove, 0)) + math.min(hairXMoveY, math.max(-headRibbonXMoveX - headRibbonXAngleMove, 0)) + math.max(headRibbonXAngleMove, math.min(-80 - headRibbonXMoveX + hairXMoveY, 0)), rotLimit[4][1], rotLimit[4][2]) - lookDir.y * 90, 0, math.clamp(-VelocityAverage[3] * 120 + 30, rotLimit[5][1], rotLimit[5][2]))
			leftHeadRibbon:setRot(math.clamp(math.max(headRibbonXMoveX, math.min(-80 + hairXMoveY + headRibbonXAngleMove, 0)) + math.min(hairXMoveY, math.max(-headRibbonXMoveX - headRibbonXAngleMove, 0)) + math.max(headRibbonXAngleMove, math.min(-80 - headRibbonXMoveX + hairXMoveY, 0)), rotLimit[4][1], rotLimit[4][2]) - lookDir.y * 90, 0, math.clamp(-VelocityAverage[3] * 120 - 30, rotLimit[6][1], rotLimit[6][2]))
			rightArmRibbon:setRot(math.clamp(hairXMoveY + math.max(armRibbonXMoveZ, math.min(-80 + hairXMoveY - headRibbonXAngleMove, 0)) + math.max(headRibbonXAngleMove, math.min(-80 + hairXMoveY - armRibbonXMoveZ, 0)), rotLimit[9][1], rotLimit[9][2]), 0, math.clamp(-VelocityAverage[1] * 160, rotLimit[8][1], rotLimit[8][2]))
			leftArmRibbon:setRot(math.clamp(-hairXMoveY + math.max(armRibbonXMoveZ, math.min(-80 - hairXMoveY - headRibbonXAngleMove, 0)) + math.max(headRibbonXAngleMove, math.min(-80 - hairXMoveY - armRibbonXMoveZ, 0)), rotLimit[10][1], rotLimit[10][2]), 0, math.clamp(-VelocityAverage[1] * 160, rotLimit[8][1], rotLimit[8][2]))
			dressRibbon:setRot(math.clamp(-VelocityAverage[2] * 160, rotLimit[7][1], rotLimit[7][2]), 0, 0)
			backRibbon:setRot(math.clamp(math.max(headRibbonXMoveX, math.min(-50 - hairXMoveY - headRibbonXAngleMove, 0)) + hairXMoveY + headRibbonXAngleMove, rotLimit[3][1], rotLimit[3][2]), 0, 0)
		end
	else
		rightHair:setRot(0, 0, 0)
		leftHair:setRot(0, 0, 0)
		rightHeadRibbon:setRot(0, 0, 30)
		leftHeadRibbon:setRot(0, 0, -30)
		rightArmRibbon:setRot(0, 0, 0)
		leftArmRibbon:setRot(0, 0, 0)
		dressRibbon:setRot(0, 0, 0)
		backRibbon:setRot(-25, 0, 0)
	end
	LookRotDeltaPrevRender = lookRotDelta
	LookRotPrevRender = lookRot
end)

return HairPhysicsClass