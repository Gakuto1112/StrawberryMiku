---@class ForkClass フォークのモデルを制御するクラス
---@field ForkRoot CustomModelPart フォークのルートパス

ForkClass = {}

ForkRoot = models.models.forks

events.TICK:register(function ()
	local rightArm = models.models.main.RightArm
	local leftArm = models.models.main.LeftArm
	local rightFork = ForkRoot.RightArm.RightFork
	local leftFork = ForkRoot.LeftArm.LeftFork
	local leftHanded = player:isLeftHanded()
	local rightHandItem = player:getHeldItem(leftHanded)
	local leftHandItem = player:getHeldItem(not leftHanded)
	local activeHand = player:getActiveHand()
	local isFirstPerson = renderer:isFirstPerson()
	if General.hasItem(rightHandItem) == "minecraft:trident" then
		vanilla_model.RIGHT_ITEM:setVisible(false)
		rightFork:setVisible(true)
		if isFirstPerson then
			rightArm:setRot(-30, -60, 0)
			ForkRoot.RightArm:setRot(-30, -60, 0)
			if player:isUsingItem() and ((activeHand == "MAIN_HAND" and not leftHanded) or (activeHand == "OFF_HAND" and leftHanded)) then
				rightArm:setVisible(false)
				ForkRoot.RightArm:setPos(20, -10, -10)
				ForkRoot.RightArm:setRot(-90, 0, -60)
			else
				rightArm:setVisible(true)
				ForkRoot.RightArm:setPos(0, 0, 0)
			end
		else
			rightArm:setVisible(true)
			rightArm:setRot(0, 0, 0)
			ForkRoot.RightArm:setPos(0, 0, 0)
			ForkRoot.RightArm:setRot(0, 0, 0)
		end
		if player:isUsingItem() and ((activeHand == "MAIN_HAND" and not leftHanded) or (activeHand == "OFF_HAND" and leftHanded)) and not isFirstPerson then
			rightFork:setRot(0, 180, 180)
		else
			rightFork:setRot(0, 0, 0)
		end
		rightFork:setSecondaryRenderType(rightHandItem:hasGlint() and "GLINT" or nil)
	else
		vanilla_model.RIGHT_ITEM:setVisible(true)
		rightFork:setVisible(false)
		rightArm:setVisible(true)
		rightArm:setRot(0, 0, 0)
	end
	if General.hasItem(leftHandItem) == "minecraft:trident" then
		vanilla_model.LEFT_ITEM:setVisible(false)
		leftFork:setVisible(true)
		if isFirstPerson then
			leftArm:setRot(-30, 60, 0)
			ForkRoot.LeftArm:setRot(-30, 60, 0)
			if player:isUsingItem() and ((activeHand == "OFF_HAND" and not leftHanded) or (activeHand == "MAIN_HAND" and leftHanded)) then
				leftArm:setVisible(false)
				ForkRoot.LeftArm:setPos(-20, -10, -10)
				ForkRoot.LeftArm:setRot(-90, 0, 60)
			else
				leftArm:setVisible(true)
				ForkRoot.LeftArm:setPos(0, 0, 0)
			end
		else
			leftArm:setVisible(true)
			leftArm:setRot(0, 0, 0)
			ForkRoot.LeftArm:setPos(0, 0, 0)
			ForkRoot.LeftArm:setRot(0, 0, 0)
		end
		if player:isUsingItem() and ((activeHand == "OFF_HAND" and not leftHanded) or (activeHand == "MAIN_HAND" and leftHanded)) and not isFirstPerson then
			leftFork:setRot(0, 180, 180)
		else
			leftFork:setRot(0, 0, 0)
		end
		leftFork:setSecondaryRenderType(leftHandItem:hasGlint() and "GLINT" or nil)
	else
		vanilla_model.LEFT_ITEM:setVisible(true)
		leftFork:setVisible(false)
		leftArm:setVisible(true)
		leftArm:setRot(0, 0, 0)
	end
end)

return ForkClass