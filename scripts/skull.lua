---@class Skull プレイヤーの頭モデルの管理を行うクラス
Skull = {
	---初期化関数
	init = function ()
        ---モデルの生成先の準備
        ---@diagnostic disable-next-line: discard-returns
        models:newPart("script_head_block", "Skull")
        models.script_head_block:setPos(0, -24, 0)

        ---頭モデルの生成
        local copiedPart = General:copyModel(models.models.main.Head)
        if copiedPart ~= nil then
            models.script_head_block:addChild(copiedPart)
        end
	end
}

Skull.init()

return Skull