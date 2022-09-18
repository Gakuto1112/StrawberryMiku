events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	ForkClass = require("scripts/forks")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Head.HeadTails, models.models.main.Head.HeadTails.HeadTailRight, models.models.main.Head.HeadTails.HeadTailRight.HeadTailRight10, models.models.main.Head.HeadTails.HeadTailRight.HeadTailRight10.HeadTailRightRibbon, models.models.main.Head.HeadTails.HeadTailRight.HeadTailRight10.HeadTailRightRibbon.HeadTailRightRibbonLine, models.models.main.Head.HeadTails.HeadTailRight.HeadTailRightFlowers, models.models.main.Head.HeadTails.HeadTailLeft, models.models.main.Head.HeadTails.HeadTailLeft.HeadTailLeft10, models.models.main.Head.HeadTails.HeadTailLeft.HeadTailLeft10.HeadTailLeftRibbon, models.models.main.Head.HeadTails.HeadTailLeft.HeadTailLeft10.HeadTailLeftRibbon.HeadTailLeftRibbonLine, models.models.main.Head.HeadTails.HeadTailLeft.HeadTailLeftFlowers}) do
		modelPart:setParentType("None")
	end
end)