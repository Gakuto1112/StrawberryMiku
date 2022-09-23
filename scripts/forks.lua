---@class ForkClass フォークのモデルを制御するクラス
---@field ForkRoot CustomModelPart フォークのルートパス

ForkClass = {}

ForkRoot = models.models.forks

events.TICK:register(function ()
	animations["forks"]["right_fork_vibration"]:play()
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
			rightArm:setVisible(false)
			rightArm:setRot(0, 0, 0)
			rightFork:setRot(0, 0, 0)
			if player:isUsingItem() and ((activeHand == "MAIN_HAND" and not leftHanded) or (activeHand == "OFF_HAND" and leftHanded)) then
				ForkRoot.RightArm:setPos(17, -5, -15)
				ForkRoot.RightArm:setRot(-100, 20, -50)
				animations["forks"]["right_fork_vibration"]:play()
			else
				ForkRoot.RightArm:setPos(0, 0, 5)
				ForkRoot.RightArm:setRot(-40, -20, 10)
				animations["forks"]["right_fork_vibration"]:stop()
			end
		else
			rightArm:setVisible(true)
			ForkRoot.RightArm:setPos(0, 0, 0)
			animations["forks"]["right_fork_vibration"]:stop()
			if player:isUsingItem() and ((activeHand == "MAIN_HAND" and not leftHanded) or (activeHand == "OFF_HAND" and leftHanded)) then
				rightFork:setRot(0, 180, 180)
				rightArm:setRot(0, 0, 0)
				ForkRoot.RightArm:setRot(0, 0, 0)
			else
				rightFork:setRot(20, 180, 180)
				rightArm:setRot(70, 0, 0)
				ForkRoot.RightArm:setRot(70, 0, 0)
			end
		end
		rightFork:setSecondaryRenderType(rightHandItem:hasGlint() and "GLINT" or nil)
	else
		vanilla_model.RIGHT_ITEM:setVisible(true)
		rightFork:setVisible(false)
		rightArm:setVisible(true)
		rightArm:setRot(0, 0, 0)
		ForkRoot.RightArm:setRot(0, 0, 0)
		animations["forks"]["right_fork_vibration"]:stop()
	end
	if General.hasItem(leftHandItem) == "minecraft:trident" then
		vanilla_model.LEFT_ITEM:setVisible(false)
		leftFork:setVisible(true)
		if isFirstPerson then
			leftArm:setVisible(false)
			leftArm:setRot(0, 0, 0)
			leftFork:setRot(0, 0, 0)
			if player:isUsingItem() and ((activeHand == "OFF_HAND" and not leftHanded) or (activeHand == "MAIN_HAND" and leftHanded)) then
				ForkRoot.LeftArm:setPos(-17, -5, -15)
				ForkRoot.LeftArm:setRot(-100, -20, 50)
				animations["forks"]["left_fork_vibration"]:play()
			else
				ForkRoot.LeftArm:setPos(0, 0, 5)
				ForkRoot.LeftArm:setRot(-40, 20, -10)
				animations["forks"]["left_fork_vibration"]:stop()
			end
		else
			leftArm:setVisible(true)
			ForkRoot.LeftArm:setPos(0, 0, 0)
			animations["forks"]["left_fork_vibration"]:stop()
			if player:isUsingItem() and ((activeHand == "OFF_HAND" and not leftHanded) or (activeHand == "MAIN_HAND" and leftHanded)) and not isFirstPerson then
				leftFork:setRot(0, 180, 180)
				leftArm:setRot(0, 0, 0)
				ForkRoot.LeftArm:setRot(0, 0, 0)
			else
				leftFork:setRot(20, 180, 180)
				leftArm:setRot(70, 0, 0)
				ForkRoot.LeftArm:setRot(70, 0, 0)
			end
		end
		leftFork:setSecondaryRenderType(leftHandItem:hasGlint() and "GLINT" or nil)
	else
		vanilla_model.LEFT_ITEM:setVisible(true)
		leftFork:setVisible(false)
		leftArm:setVisible(true)
		leftArm:setRot(0, 0, 0)
		ForkRoot.LeftArm:setRot(0, 0, 0)
		animations["forks"]["left_fork_vibration"]:stop()
	end
end)

return ForkClass