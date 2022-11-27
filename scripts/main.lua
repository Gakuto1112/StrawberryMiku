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
	nameplate.ENTITY:setBackgroundColor(187 / 255, 40 / 255, 68 / 255)
	nameplate.ENTITY.shadow = true
	renderer:setShadowRadius(0.9)
end)