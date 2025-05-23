events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	StringUtils = require("scripts.string_utils")
	DressClass = require("scripts.dress")
	HairPhysics = require("scripts.hair_physics")
	Fork = require("scripts.fork")
	UpdateChecker = require("scripts.update_checker")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	renderer:setShadowRadius(0.9)
end)

--ENTITY_INITを待たず読み込むクラス
General = require("scripts.general")
Skull = require("scripts.skull")