events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	DressClass = require("scripts/dress")
	HairPhysicsClass = require("scripts/hair_physics")
	ForkClass = require("scripts/forks")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Head.HeadTails, models.models.main.Head.HeadTails.HeadTailRightPivot, models.models.main.Head.HeadTails.HeadTailRightPivot.HeadTailRight, models.models.main.Head.HeadTails.HeadTailRightPivot.HeadTailRight.HeadTailRight10, models.models.main.Head.HeadTails.HeadTailRightPivot.HeadTailRight.HeadTailRight10.HeadTailRightRibbon, models.models.main.Head.HeadTails.HeadTailRightPivot.HeadTailRight.HeadTailRight10.HeadTailRightRibbon.HeadTailRightRibbonLine, models.models.main.Head.HeadTails.HeadTailRightPivot.HeadTailRight.HeadTailRightFlowers, models.models.main.Head.HeadTails.HeadTailLeftPivot, models.models.main.Head.HeadTails.HeadTailLeftPivot.HeadTailLeft, models.models.main.Head.HeadTails.HeadTailLeftPivot.HeadTailLeft.HeadTailLeft10, models.models.main.Head.HeadTails.HeadTailLeftPivot.HeadTailLeft.HeadTailLeft10.HeadTailLeftRibbon, models.models.main.Head.HeadTails.HeadTailLeftPivot.HeadTailLeft.HeadTailLeft10.HeadTailLeftRibbon.HeadTailLeftRibbonLine, models.models.main.Head.HeadTails.HeadTailLeftPivot.HeadTailLeft.HeadTailLeftFlowers}) do
		modelPart:setParentType("None")
	end
	renderer:setShadowRadius(0.9)
end)