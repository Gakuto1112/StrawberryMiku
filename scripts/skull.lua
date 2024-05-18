---@class Skull プレイヤーの頭モデルの管理を行うクラス
Skull = {
	---初期化関数
	init = function ()
        ---モデルパーツをディープコピーする。非表示のモデルパーツはコピーしない。
        ---@param modelPart ModelPart コピーするモデルパーツ
        ---@return ModelPart? copiedModelPart コピーされたモデルパーツ。入力されたモデルパーツが非表示の場合はnilが返る。
        local function copyModel(modelPart)
            if modelPart:getVisible() then
                local copy = modelPart:copy(modelPart:getName())
                copy:setParentType("None")
                copy:setVisible(true)
                for _, child in ipairs(copy:getChildren()) do
                    copy:removeChild(child)
                    local childModel = copyModel(child)
                    if childModel ~= nil then
                        copy:addChild(childModel)
                    end
                end
                return copy
            end
        end

        ---モデルの生成先の準備
        ---@diagnostic disable-next-line: discard-returns
        models:newPart("script_head_block", "Skull")
        models.script_head_block:setPos(0, -24, 0)

        ---頭モデルの生成
        local copiedPart = copyModel(models.models.main.Head)
        if copiedPart ~= nil then
            models.script_head_block:addChild(copiedPart)
        end
	end
}

Skull.init()

return Skull