---@class Fork フォークのモデルを制御するクラス
Fork = {
    ---初期化関数
    init = function ()
        --フォークのモデルのコピー
        models.models.fork:addChild(models:newPart("Item", "Item"))
        models.models.fork.Item:addChild(models.models.fork.Fork:copy("Fork"))
        models.models.fork:addChild(models:newPart("Trident", "Trident"))
        models.models.fork.Trident:addChild(models.models.fork.Fork:copy("Fork"))
        models.models.fork.Trident:setPos(0, 0, 16)
        models.models.fork.Trident:setRot(0, 0, -90)
        models.models.fork.Fork:remove()

        events.ITEM_RENDER:register(function (item, mode)
            if item.id == "minecraft:trident" and mode ~= "HEAD" then
                models.models.fork.Item.Fork:setSecondaryRenderType(item:hasGlint() and (client:getVersion() == "1.21.4" and "GLINT2" or "GLINT") or "NONE")
                local isUsingTrident = player:isUsingItem()
                if mode == "FIRST_PERSON_RIGHT_HAND" then
                    models.models.fork.Item.Fork:setScale(0.5, 0.5, 0.5)
                    if isUsingTrident then
                        models.models.fork.Item.Fork:setPos(2, -8, 1)
                        models.models.fork.Item.Fork:setRot(0, -70, 90)
                    else
                        models.models.fork.Item.Fork:setPos(1, 0, 4)
                        models.models.fork.Item.Fork:setRot(0, -70, 90)
                    end
                elseif mode == "FIRST_PERSON_LEFT_HAND" then
                    models.models.fork.Item.Fork:setScale(0.5, 0.5, 0.5)
                    if isUsingTrident then
                        models.models.fork.Item.Fork:setPos(-3, -8, 1)
                        models.models.fork.Item.Fork:setRot(0, -70, 90)
                    else
                        models.models.fork.Item.Fork:setPos(-1, 0, 4)
                        models.models.fork.Item.Fork:setRot(0, -70, 90)
                    end
                elseif mode == "THIRD_PERSON_RIGHT_HAND" then
                    models.models.fork.Item.Fork:setPos(0, -4, 1)
                    models.models.fork.Item.Fork:setScale(1, 1, 1)
                    if isUsingTrident then
                        models.models.fork.Item.Fork:setRot(-90, -90, 0)
                    else
                        models.models.fork.Item.Fork:setRot(90, 90, 0)
                    end
                elseif mode == "THIRD_PERSON_LEFT_HAND" then
                    models.models.fork.Item.Fork:setPos(0, -4, 1)
                    models.models.fork.Item.Fork:setScale(1, 1, 1)
                    if isUsingTrident then
                        models.models.fork.Item.Fork:setRot(-90, 90, 0)
                    else
                        models.models.fork.Item.Fork:setRot(90, -90, 0)
                    end
                end
                return models.models.fork.Item
            end
        end)
    end
}

Fork.init()

return Fork