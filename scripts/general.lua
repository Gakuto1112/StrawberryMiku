---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス
General = {
	---渡されたItemStackのアイテムタイプを返す。nilや"minecraft:air"の場合は"none"と返す。
	---@param item ItemStack アイテムタイプを調べるItemStack
	---@return string
	hasItem = function (item)
		if item == nil then
			return "none"
		else
			return item.id == "minecraft:air" and "none" or item.id
		end
	end,

	---モデルパーツをディープコピーする。非表示のモデルパーツはコピーしない。
	---@param self General
    ---@param modelPart ModelPart コピーするモデルパーツ
    ---@return ModelPart? copiedModelPart コピーされたモデルパーツ。入力されたモデルパーツが非表示の場合はnilが返る。
    copyModel = function (self, modelPart)
        if modelPart:getVisible() then
            local copy = modelPart:copy(modelPart:getName())
            copy:setParentType("None")
            for _, child in ipairs(copy:getChildren()) do
                copy:removeChild(child)
                local childModel = self:copyModel(child)
                if childModel ~= nil then
                    copy:addChild(childModel)
                end
            end
            return copy
        end
    end
}

return General