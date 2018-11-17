require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"

GoldExchangeLuaCell2  = GoldExchangeLuaCell2 or {}
ccb["GoldExchangeLuaCell2"] = GoldExchangeLuaCell2

GoldExchangeCell2 = class("GoldExchangeCell2",
    function()
        return cc.Layer:create()
    end
)
GoldExchangeCell2.__index = GoldExchangeCell2
function GoldExchangeCell2:create(path,params,popup_image, rootNode)
    local node = GoldExchangeCell2.new()
    node:init(path,params,popup_image,rootNode)
    return node
end
function GoldExchangeCell2:init(path,params,popup_image, node)
    self.rootPath = path
    self.data = params
    self._popup_image = popup_image;
    self._rootNode = node;

    local  proxy = cc.CCBProxy:create()
    local ccbiUrl = self.rootPath .. "/ccbi/GoldExchangeLuaCell2.ccbi"
    if self._popup_image == "zspeed_f" then
        ccbiUrl = self.rootPath .. "/ccbi/GoldExchangeLuaCell3.ccbi"
    end

    
    local  node  = CCBReaderLoad(ccbiUrl,proxy,GoldExchangeLuaCell2)
    if(nil == node) then
        return
    end
    print "GoldExchangeCell2:init"
    local  layer = tolua.cast(node,"cc.Layer")
    if nil ~= GoldExchangeLuaCell2["m_nameLabel"] then
        self.m_nameLabel = tolua.cast(GoldExchangeLuaCell2["m_nameLabel"],"cc.Label")
        if nil ~= self.m_nameLabel then
            self.m_nameLabel:setString("")
        end
    end
    if nil ~= GoldExchangeLuaCell2["m_numLabel"] then
        self.m_numLabel = tolua.cast(GoldExchangeLuaCell2["m_numLabel"],"cc.Label")
        if nil ~= self.m_numLabel then
            local numStr = string.format(self.data[2])
            self.m_numLabel:setString("X" .. numStr)
        end
    end
    for i = 1, 3 do
        if nil ~= GoldExchangeLuaCell2["m_iconNode" .. i] then
            self.m_iconNode = tolua.cast(GoldExchangeLuaCell2["m_iconNode" .. i],"cc.LayerColor")
            if nil ~= self.m_iconNode then
                LuaController:addItemIcon(self.m_iconNode,self.data[1],self.m_nameLabel)
                self.m_iconNode:setScale(1.73)
            end
        end
    end

    -- 设置可点击，Toast
    if nil ~= GoldExchangeLuaCell2["m_bg"] then
        self.m_bg = tolua.cast(GoldExchangeLuaCell2["m_bg"],"cc.LayerColor")
        if nil ~= self.m_bg then
            function onTouch(eventType, x, y)
                if eventType == "began" then
                    return self:onTouchBegan(x, y)
                elseif eventType == "moved" then
                    return self:onTouchMoved(x, y)
                else
                    return self:onTouchEnded(x, y)
                end
            end
            self.m_bg:registerScriptTouchHandler(onTouch)
            self.m_bg:setTouchEnabled(true)
            self.m_bg:setSwallowsTouches(false);
        end
    end

    self:addChild(node)
end


function GoldExchangeCell2:onTouchBegan( x, y )
    self._touchX = x
    self._touchY = y
    if(nil ~= self.m_bg) then
        if(nil ~= self.m_bg:getParent()) then
            local pos = self.m_bg:getParent():convertToNodeSpace(CCPoint(x,y))
            local rect = self.m_bg:getBoundingBox()
            if (cc.rectContainsPoint(rect, pos) == true) then
                return true
            end
        end
    end
    return false
end

function GoldExchangeCell2:onTouchMoved( x, y )
    -- body
end

function GoldExchangeCell2:onTouchEnded( x, y )
    if cc.pGetDistance(cc.p(self._touchX, self._touchY),cc.p(x, y)) < 20 then
        xpcall(function ()
            LuaController:showToastDescription(self.data[1], self.m_nameLabel, self._rootNode);
        end, function ()
        end)
        
    end
end
