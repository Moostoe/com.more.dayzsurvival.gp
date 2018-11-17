require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"

ActivityListCellSprite = class("ActivityListCellSprite", function() return cc.Layer:create() end)
ActivityListCellSprite.__index = ActivityListCellSprite

function ActivityListCellSprite:create( path, params)
    local node = ActivityListCellSprite.new()
    node:init(path, params)
    return node
end

function ActivityListCellSprite:init( path, params )
    self.rootPath = string.format(path)
    self.params = params
    loadLuaResource(self.rootPath .. "/resources/activity_" .. self.params.id .. ".plist")

    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("activity_" .. self.params.id .. "_list_cell_head.png");

    if nil ~= frame then
        local sprite = cc.Sprite:createWithSpriteFrame(frame)
        local function eventHandler( eventType )
            if eventType == "cleanup" then
                releaseLuaResource(self.rootPath .. "/resources/activity_" .. self.params.id)
                sprite:unregisterScriptHandler()
            end
        end
        sprite:registerScriptHandler(eventHandler)
        self:addChild(sprite)
    end
end
