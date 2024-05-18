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
	renderer:setShadowRadius(0.9)
end)

--ENTITY_INITを待たず読み込むクラス
Skull = require("scripts.skull")