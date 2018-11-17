require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"

GoldExchangeLuaCell1  = GoldExchangeLuaCell1 or {}
ccb["GoldExchangeLuaCell1"] = GoldExchangeLuaCell1

GoldExchangeCell1 = class("GoldExchangeCell1",
    function()
        return cc.Layer:create() 
    end
)
GoldExchangeCell1.__index = GoldExchangeCell1
function GoldExchangeCell1:create(path,params, popup_image, root, isAlliance)
    local node = GoldExchangeCell1.new()
    node:init(path,params, popup_image, root, isAlliance)
    return node
end
function GoldExchangeCell1:init(path,params, popup_image, root, isAlliance)
    self.rootPath = path
    self.data = params
    self._popup_image = popup_image
    self._rootNode = root
    local  proxy = cc.CCBProxy:create()
    local ccbiUrl = self.rootPath .. "/ccbi/GoldExchangeLuaCell4.ccbi"
    local  node  = CCBReaderLoad(ccbiUrl,proxy,GoldExchangeLuaCell1)
    if(nil == node) then
        return
    end
    
    local  layer = tolua.cast(node,"cc.Layer")
    if nil ~= GoldExchangeLuaCell1["m_nameLabel"] then
        self.m_nameLabel = tolua.cast(GoldExchangeLuaCell1["m_nameLabel"],"cc.Label")
        if nil ~= self.m_nameLabel then
            self.m_nameLabel:setString("")
        end
    end

    if nil ~= GoldExchangeLuaCell1["m_cellNode"] then
        self.m_cellNode = tolua.cast(GoldExchangeLuaCell1["m_cellNode"], "cc.Node")
        print("self.m_cellNode have")
    end

    if nil ~= GoldExchangeLuaCell1["m_numLabel"] then
        self.m_numLabel = tolua.cast(GoldExchangeLuaCell1["m_numLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeLuaCell1["m_line"] then
        self.m_line = tolua.cast(GoldExchangeLuaCell1["m_line"],"cc.Sprite")
        if nil ~= self.m_line then
            if popup_image == "zg_kuangtu_f" then
                self.m_line:setColor(cc.c3b(68, 182, 0));
            elseif popup_image == "ZHunter" then
                self.m_line:setColor(cc.c3b(163, 101, 42));
            elseif popup_image == "TArms" then
                self.m_line:setColor(cc.c3b(96, 184, 217));
            elseif popup_image == "SpecialArms" then
                self.m_line:setColor(cc.c3b(255, 193, 25));
            elseif popup_image == "ResidentExpert" then
                self.m_line:setColor(cc.c3b(170, 231, 76));
            end
        end
    end
    if nil ~= GoldExchangeLuaCell1["m_iconNode1"] then
        self.m_iconNode = tolua.cast(GoldExchangeLuaCell1["m_iconNode1"],"cc.LayerColor")
    end
    if isAlliance == 1 then
        -- 联盟礼包
        if nil ~= self.m_numLabel then
            local numStr = string.format(self.data[4])
            self.m_numLabel:setString("X" .. numStr)
        end
        if nil ~= self.m_iconNode then
            local bgColor = "tool_1.png"
            if self.data[5] == "0" then
                bgColor = "tool_1.png"
            elseif self.data[5] == "1" then
                bgColor = "tool_2.png"
            elseif self.data[5] == "2" then
                bgColor = "tool_3.png"
            elseif self.data[5] == "3" then
                bgColor = "tool_4.png"
            elseif self.data[5] == "4" then
                bgColor = "tool_5.png"
            elseif self.data[5] == "5" then
                bgColor = "tool_6.png"
            elseif self.data[5] == "6" then
                bgColor = "tool_7.png"
            end
            local cloreframe = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgColor)
            if nil ~= cloreframe then
                local sprBg = cc.Sprite:create()
                sprBg:setSpriteFrame(cloreframe)
                sprBg:setScale(52/sprBg:getContentSize().width)
                self.m_iconNode:addChild(sprBg)
                sprBg:setPosition(cc.p(26,26))   
            end

            local bgName = tostring(self.data[1]) .. ".png"
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgName)
            if nil ~= frame then
                local spr = cc.Sprite:create()
                spr:setSpriteFrame(frame)
                spr:setScale(50/spr:getContentSize().width)
                spr:setPosition(cc.p(26,26))
                self.m_iconNode:addChild(spr)
            end
        end

        local name = string.format(LuaController:getLang(self.data[2]))
        self.m_nameLabel:setString(name)
    else
        if nil ~= self.m_numLabel then
            local numStr = string.format(self.data[2])
            self.m_numLabel:setString("X" .. numStr)
        end
        if nil ~= self.m_iconNode then
            LuaController:addItemIcon(self.m_iconNode,self.data[1],self.m_nameLabel)
        end
    end
    

    -- 设置可点击，Toast
    if nil ~= GoldExchangeLuaCell1["m_bg"] then
        self.m_bg = tolua.cast(GoldExchangeLuaCell1["m_bg"],"cc.LayerColor")
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

function GoldExchangeCell1:onTouchBegan( x, y )
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

function GoldExchangeCell1:onTouchMoved( x, y )
    -- body
end

function GoldExchangeCell1:onTouchEnded( x, y )
    if cc.pGetDistance(cc.p(self._touchX, self._touchY),cc.p(x, y)) < 20 then
        xpcall(function ()
            local name = self.data[2] or ""
            local des = self.data[3] or ""
            LuaController:showToastDescription(self.data[1], self.m_nameLabel, self._rootNode, LuaController:getLang(name), LuaController:getLang(des));
        end, function ()
            LuaController:showToastDescription(self.data[1], self.m_nameLabel, self._rootNode);
        end)
        
    end
end

function GoldExchangeCell1:getCellNode()
    if self.m_cellNode ~= nil then
        return self.m_cellNode
    end
    return nil
end
