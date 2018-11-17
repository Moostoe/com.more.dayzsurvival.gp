require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"

GoldExchangeAdvLuaCell  = GoldExchangeAdvLuaCell or {}
ccb["GoldExchangeAdvLuaCell"] = GoldExchangeAdvLuaCell

GoldExchangeAdvCell = class("GoldExchangeAdvCell",
    function()
        return cc.Layer:create() 
    end
)
GoldExchangeAdvCell.__index = GoldExchangeAdvCell
function GoldExchangeAdvCell:create(parent,path,params)
    local node = GoldExchangeAdvCell.new()
    node:init(parent,path,params)
    return node
end
function GoldExchangeAdvCell:init(parent,path,params)
    local strPath = string.format(path)
    self.rootPath = strPath
    self.parentNode = parent

    self:initData(params)

    -- self.data[19] = "zspeed_f"

    -- self.data[7]  收益

    loadLuaResource(self.rootPath .. "/resources/".. self.data[19] .."adv.plist")
    loadLuaResource(self.rootPath .. "/resources/"..self.data[19]..".plist")
    loadLuaResource(self.rootPath .. "/resources/lua_common.plist")
    LuaController:autoDoResourceItemIcon(self)
    LuaController:autoDoResourceEquipIcon(self)

    local  proxy = cc.CCBProxy:create()
    GoldExchangeAdvLuaCell.onClickCostBtn = function()
        self:onClickCostBtn()
    end
    GoldExchangeAdvLuaCell.onBtnFree = function()
        self:onBtnFree()
    end
    GoldExchangeAdvLuaCell.onPackageBtnClick = function()
        self:onPackageBtnClick()
    end
    local ccbiURL = strPath .. "/ccbi/GoldExchangeAdv"..self.data[19].."LuaCell.ccbi"
    --print ("adv ccb :" .. ccbiURL)

    self.up_Y = 0
    self.down_Y = 0
    self.self_Y = 0
    self.m_oldVersion = true
    xpcall( function ()
        local viewVersion = LuaController:getLuaViewVersion() or "ver_0"
        if viewVersion ~= "ver_0" then
            self.m_oldVersion = false
        end
        print (">>> this is not old version")
    end, function ()
        self.self_Y=-75
        self.up_Y=-83
        self.down_Y=50
        self.m_oldVersion = true
        print (">>> this is old version")
    end)

    local ccbnode = CCBReaderLoad(ccbiURL,proxy,GoldExchangeAdvLuaCell)
    local layer = tolua.cast(ccbnode,"cc.Layer")

    self:setPositionY(self:getPositionY()+self.self_Y)

    xpcall(function ()
        -- 为了做奖励
        for i=1,4 do
            if nil ~= GoldExchangeAdvLuaCell["m_node_reward" .. i] then
                self["m_node_reward" .. i] = tolua.cast(GoldExchangeAdvLuaCell["m_node_reward" .. i],"cc.Node")
            end
            if nil ~= GoldExchangeAdvLuaCell["m_lab_reward" .. i] then
                self["m_lab_reward" .. i] = tolua.cast(GoldExchangeAdvLuaCell["m_lab_reward" .. i],"cc.Label")
            end
        end
        local itemCount = 1
        -- 联盟奖励
        if (self.data[29] ~= "") then
            local allianceRew = lua_string_split(self.data[29], '|')
            local tmpAlliance = {}
            for i = 1, #allianceRew do
                local xx = table.remove(allianceRew)
                if (xx ~= nil and xx ~= "" and xx ~= "nil") then
                    tmpAlliance[#tmpAlliance+1] = xx
                end
            end
            local max = #tmpAlliance > 4 and 4 or #tmpAlliance
            for i = 1, max-itemCount+1 do
                local _reward = lua_string_split(tmpAlliance[i], ';')
                local icon = _reward[1] or ""
                local name = _reward[2] or ""
                local des = _reward[3] or ""
                local num = _reward[4] or 0
                local color = tostring(_reward[5]) or "0"

                -- 背景图 
                local bgColor = "tool_1.png"
                if color == "0" then
                    bgColor = "tool_1.png"
                elseif color == "1" then
                    bgColor = "tool_2.png"
                elseif color == "2" then
                    bgColor = "tool_3.png"
                elseif color == "3" then
                    bgColor = "tool_4.png"
                elseif color == "4" then
                    bgColor = "tool_5.png"
                elseif color == "5" then
                    bgColor = "tool_6.png"
                elseif color == "6" then
                    bgColor = "tool_7.png"
                end
                local cloreframe = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgColor)
                if nil ~= cloreframe then
                    local sprBg = cc.Sprite:create()
                    sprBg:setSpriteFrame(cloreframe)
                    sprBg:setScale(76/sprBg:getContentSize().width)
                    self["m_node_reward" .. i]:addChild(sprBg) 
                end
                -- 资源图
                local bgName = tostring(icon) .. ".png"
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgName)
                if nil ~= frame then
                    local spr = cc.Sprite:create()
                    spr:setSpriteFrame(frame)
                    spr:setScale(74/spr:getContentSize().width)
                    self["m_node_reward" .. i]:addChild(spr)
                end
                self["m_lab_reward" .. i]:setString(tostring(num))
                itemCount = itemCount+1
            end
        end
        -- 道具显示
        local rewardList = lua_string_split(self.data[7], '|')

        local tmp = {}
        for i = 1, #rewardList do
            tmp[i] = table.remove(rewardList)
        end

        max = #tmp > 4 and 4 or #tmp
        for i = 1, max-itemCount+1 do
            local _reward = lua_string_split(tmp[i], ';')
            local item = _reward[1] or ""
            local count = _reward[2] or 0
            self["m_lab_reward" .. itemCount]:setString(tostring(count))
            LuaController:addItemIcon(self["m_node_reward" .. itemCount],item, nil)
            self["m_node_reward" .. itemCount]:setScale(1.55)
            itemCount = itemCount+1
        end
    end, function ()
        print(">>>>>>>>>>>>>>>> 123   2")
    end)

    if nil ~= GoldExchangeAdvLuaCell["m_lblDes"] then
        self.m_lblDes = tolua.cast(GoldExchangeAdvLuaCell["m_lblDes"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_labelBG"] then
        self.m_labelBG = tolua.cast(GoldExchangeAdvLuaCell["m_labelBG"],"cc.Sprite")
        if nil~= self.m_labelBG then
            self.m_labelBG:setVisible(false)
        end
    end
    if nil ~= GoldExchangeAdvLuaCell["m_timeLabel"] then
        self.m_timeLabel = tolua.cast(GoldExchangeAdvLuaCell["m_timeLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_percentLabel"] then
        self.m_percentLabel = tolua.cast(GoldExchangeAdvLuaCell["m_percentLabel"],"cc.LabelBMFont")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_moreLabel"] then
        self.m_moreLabel = tolua.cast(GoldExchangeAdvLuaCell["m_moreLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_desLabel"] then
        self.m_desLabel = tolua.cast(GoldExchangeAdvLuaCell["m_desLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_newPriceLabel"] then
        self.m_newPriceLabel = tolua.cast(GoldExchangeAdvLuaCell["m_newPriceLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_getGoldNumText"] then
        self.m_getGoldNumText = tolua.cast(GoldExchangeAdvLuaCell["m_getGoldNumText"],"cc.LabelBMFont")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_costBtn"] then
        self.m_costBtn = tolua.cast(GoldExchangeAdvLuaCell["m_costBtn"],"cc.ControlButton")
        xpcall(function ()
            if LuaController:isGM() then
                local id = cc.LabelTTF:create("ID:" .. tostring(self.data[1]), "Arial", 24);
                id:setPosition(cc.p(self.m_costBtn:getContentSize().width*0.5, 60));
                self.m_costBtn:addChild(id, 100)
            end
        end, function ()
            -- body
        end)
    end
    if nil ~= GoldExchangeAdvLuaCell["m_freeNode"] then
        self.m_freeNode = tolua.cast(GoldExchangeAdvLuaCell["m_freeNode"],"cc.Node")
        self.m_freeBtn = tolua.cast(GoldExchangeAdvLuaCell["m_freeBtn"],"cc.ControlButton")
        self.m_freeLabel = tolua.cast(GoldExchangeAdvLuaCell["m_freeLabel"],"cc.Label")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_showMoneyNode"] then
        self.m_showMoneyNode = tolua.cast(GoldExchangeAdvLuaCell["m_showMoneyNode"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeAdvLuaCell["m_showMoreNode"] then
        self.m_showMoreNode = tolua.cast(GoldExchangeAdvLuaCell["m_showMoreNode"],"cc.LayerColor")
        if nil ~= self.m_showMoreNode then
            if self.m_showMoreNode:isVisible() == true then
                local function onTouchBegan(x, y)
                    if(nil ~= self.m_showMoreNode) then
                        if(nil ~= self.m_showMoreNode:getParent()) then
                            local pos = self.m_showMoreNode:getParent():convertToNodeSpace(CCPoint(x,y))
                            local rect = self.m_showMoreNode:getBoundingBox()
                            if(cc.rectContainsPoint(rect, pos) == true) then
                                return true
                            end 
                        end
                    end
                    return false
                end
                local function onTouchMoved(x, y)
                end
                local function onTouchEnded(x, y)
                    if(nil == self.m_showMoreNode) then
                        return
                    end

                    if self.m_showMoreNode:isVisible() == false then
                        return
                    end

                    if(nil == self.m_showMoreNode:getParent()) then
                        return
                    end

                    local pos = self.m_showMoreNode:getParent():convertToNodeSpace(CCPoint(x,y))
                    local rect = self.m_showMoreNode:getBoundingBox()
                    if(cc.rectContainsPoint(rect, pos) == true) then
                        local itemid = string.format(self.data[1])
                        LuaController:showDetailPopup(itemid)
                        return
                    end
                end

                local function onTouch(eventType, x, y)
                    print (eventType)  
                    if eventType == "began" then
                        return onTouchBegan(x, y)  
                    elseif eventType == "moved" then  
                        return onTouchMoved(x, y)  
                    else  
                        return onTouchEnded(x, y)  
                    end
                end
                self.m_showMoreNode:registerScriptTouchHandler(onTouch)
                self.m_showMoreNode:setTouchEnabled(true)
            end
        end
    end

    if nil ~= GoldExchangeAdvLuaCell["m_upNode"] then
        self.m_upNode = tolua.cast(GoldExchangeAdvLuaCell["m_upNode"],"cc.Node")
        self.m_upNode:setPositionY(self.m_upNode:getPositionY()+self.up_Y)
    end

    if nil ~= GoldExchangeAdvLuaCell["m_downNode"] then
        self.m_downNode = tolua.cast(GoldExchangeAdvLuaCell["m_downNode"],"cc.Node")
        self.m_downNode:setPositionY(self.m_downNode:getPositionY()+self.down_Y)
    end

    if nil ~= GoldExchangeAdvLuaCell["m_diamond"] then
        self.m_diamond = tolua.cast(GoldExchangeAdvLuaCell["m_diamond"],"cc.Node")
    end

    if nil ~= GoldExchangeAdvLuaCell["m_bgSprite"] then
        self.m_bgSprite = tolua.cast(GoldExchangeAdvLuaCell["m_bgSprite"], "cc.Sprite")
        if self.data[19] == "RandomHero" and nil ~= self.data[28] then
            local heroId = tostring(self.data[28])
            if heroId ~= "" then
                if heroId ~= "240035" then
                    local bgName = heroId .. "_beijing.png"
                    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(bgName)
                    if nil ~= frame then
                        self.m_bgSprite:setSpriteFrame(frame)
                        self.m_bgSprite:setScale(1)
                    else
                        print("frame nil")
                    end
                end
            end
        end
    end

    if self.m_oldVersion then
        local width = 640
        local height = 440
        if self.m_diamond then
            local posX = self.m_diamond:getPositionX()
            local posY = self.m_diamond:getPositionY()
            print (">>> m_diamond pos: x: %f   y: %f", posX, posY)
            self.m_diamond:setPosition(cc.p(80, 110))
        end
        self.m_getGoldNumText:setAnchorPoint(cc.p(0, 0.5))
        self.m_getGoldNumText:setPosition(cc.p(110, 120))
    end


    self:initView()
    local function scheduleBack()
    if(nil ~= self.m_timeLabel) then
        local curTime = LuaController:getWorldTime()
        local lastTime = 0
        local expTime = tonumber(self.data[14])
        local endTime = tonumber(self.data[13])
        if expTime>0 then
            local gapTime = endTime - curTime
            local count=0
            if self.m_oldVersion == true then
                count =  gapTime / (expTime*3600)
                count = math.floor(count)
                lastTime = endTime - (expTime*3600)*count-curTime;
            else
                count =  gapTime / (expTime)
                count = math.floor(count)
                lastTime = endTime - (expTime)*count-curTime;
            end

        else
            lastTime = endTime - curTime
        end
        local timeStr = LuaController:getSECLang(lastTime)
        self.m_timeLabel:setString(timeStr)
        if (endTime - curTime <= 0 ) then
            self.m_costBtn:setEnabled(false)
            self:removeAllEvent()
            LuaController:removeAllPopup()
        end 
    end
    end

    local function eventHandler( eventType )
            if eventType == "enter" then
                scheduleBack()
                self.m_entryId = tonumber(ccbnode:getScheduler():scheduleScriptFunc(scheduleBack, 1, false))
            elseif eventType == "exit" then
                if nil ~= self.m_entryId then
                    ccbnode:getScheduler():unscheduleScriptEntry(self.m_entryId)
                end
            elseif eventType == "cleanup" then
                ccbnode:unregisterScriptHandler()
            end
    end
    ccbnode:registerScriptHandler(eventHandler)
    self.parentNode:addChild(self)
    self:addChild(ccbnode)

    if self.m_oldVersion then
        self:setContentSize(cc.size(540, 220))
        ccbnode:setPositionY(-66)
    else
        self:setContentSize(cc.size(540, 470))
        ccbnode:setPositionY(-225)
    end

    self.ccbNode = ccbnode

end

function GoldExchangeAdvCell:initData(params)
    local paramsStr = string.format(params)
    self.data = {}
    local index = 1
    local startI = 1
    local fIndex = string.find(paramsStr,",",startI)
    local tmpValue = ""
    while (true) do
        tmpValue = string.sub(paramsStr,startI,fIndex-1)
        self.data[index] = tmpValue
        index = index + 1
        startI = fIndex + 1
        fIndex = string.find(paramsStr,",",startI)
        if (fIndex == nil) then
            tmpValue = string.sub(paramsStr,startI,string.len(paramsStr))
            self.data[index] = tmpValue
            break
        end
    end
end
function GoldExchangeAdvCell:initView()
    if nil ~= self.m_getGoldNumText then
        local numKey = string.format(self.data[3]);
        local numStr = string.format(LuaController:getCMDLang(numKey))
        self.m_getGoldNumText:setString(numStr)
    end
    if nil ~= self.m_percentLabel then
        local percentStr = string.format(self.data[8])
        percentStr = percentStr .. "%"
        if self.data[19] == "RandomHero" then
                -- 随机英雄礼包的百分比是 英雄概率
                if nil == self.data[27] then
                    percentStr = ""
                else 
                    percentStr = string.format(self.data[27])
                    percentStr = percentStr .. "%"
                end
        end
        self.m_percentLabel:setString(percentStr)
    end
    local itemNull = false
    local itemStr = string.format(self.data[7])
    if string.len(itemStr) == 0 then
        if nil ~= self.m_moreLabel then
            self.m_moreLabel:setString("")
        end
        if nil ~= self.m_showMoreNode then
            self.m_showMoreNode:setVisible(false)
        end
        if nil ~= self.m_desLabel then
            self.m_desLabel:setString("")
        end
    else
        if nil ~= self.m_moreLabel then
            local moreStr = string.format(LuaController:getLang("102271"))
            self.m_moreLabel:setString(moreStr)
        end
        if nil ~= self.m_showMoreNode then
            self.m_showMoreNode:setVisible(true)
        end
        if nil ~= self.m_desLabel then
            local desStr = string.format(LuaController:getLang("101237"))
            self.m_desLabel:setString(desStr)
        end

        local desString1 = "";
        if  self.data[19] == "zalliance1" 
            or self.data[19] == "zalliance2"
            or self.data[19] == "zalliance3"
            then
            desString1 = string.format(LuaController:getLang("101379"))
        elseif self.data[19] == "zequip_tongyu" then
            desString1 = string.format(LuaController:getLang("101068"))
        elseif self.data[19] == "zg_spy" then
            desString1 = string.format(LuaController:getLang("101069"))
        elseif self.data[19] == "zjap" then
            desString1 = string.format(LuaController:getLang("101072"))
        elseif self.data[19] == "zbuild_zombie" then
            desString1 = string.format(LuaController:getLang("101067"))
        elseif self.data[19] == "zmother" then
            desString1 = string.format(LuaController:getLang("101071"))
        elseif self.data[19] == "zequip_kaituo" then
            desString1 = string.format(LuaController:getLang("101073"))
        elseif self.data[19] == "zg_sniper" then
            desString1 = string.format(LuaController:getLang("101074"))
        elseif self.data[19] == "RandomHero" then
            if nil ~= self.data[27] then
                local str = tostring(self.data[27])
                str = str .. "%"
                local str1 = tostring(self.data[23])
                desString1 = tostring(LuaController:getLang1(str1, str))
            end
        end

        if desString1 == "" then
            desString1 = tostring(LuaController:getLang(self.data[23]))
        end
        if "" ~= desString1 and nil ~= self.m_lblDes then
            self.m_lblDes:setString(desString1)
            if nil ~= self.m_labelBG then
                self.m_labelBG:setVisible(true)
            end
        end

    end
    if nil ~= self.m_newPriceLabel then
        local dollar = string.format(self.data[4])
        local pID = string.format(self.data[11])
        local newPrice = string.format(LuaController:getDollarString(dollar,pID))
        self.m_newPriceLabel:setString(newPrice)
    end

    if nil ~= self.m_freeNode then
        local  amount = tonumber(self.data[26])
        if amount == 0 then
            self.m_freeNode:setVisible(false)
            self.m_freeBtn:setEnabled(false)
        else
            self.m_freeNode:setVisible(true)
            self.m_freeBtn:setEnabled(true)
            local str = string.format(LuaController:getLang("171030"))
            self.m_freeLabel:setString(str)
        end
    end
end
function GoldExchangeAdvCell:removeAllEvent()
    releaseLuaResource(self.rootPath .. "/resources/".. self.data[19] .."adv")
    releaseLuaResource(self.rootPath .. "/resources/".. self.data[19])
    GoldExchangeAdvLuaCell.onClickCostBtn = nil
    GoldExchangeAdvLuaCell.onBtnFree = nil
    if nil ~= self.m_freeBtn then
        self.m_freeBtn:setEnabled(false)
    end
    if nil ~= self.m_showMoreNode then
        self.m_showMoreNode:unregisterScriptTouchHandler()
    end
    if nil ~= self.m_costBtn then
        self.m_costBtn:setEnabled(false)
    end
    if nil ~= self.m_timeLabel then
        self.m_timeLabel:stopAllActions()
    end
    if nil ~= self.ccbNode then
        self.ccbNode:unregisterScriptHandler()
    end
end

function GoldExchangeAdvCell:onClickCostBtn()
    local itemid = string.format(self.data[1])
    LuaController:callPayment(itemid)
    self:removeAllEvent()
    LuaController:removeAllPopup()
end
function GoldExchangeAdvCell:onBtnFree()
    self:removeAllEvent()
    LuaController:removeAllPopup()
    local itemid = string.format(self.data[1])
    LuaController:onBtnFree(itemid)
end
function GoldExchangeAdvCell:onPackageBtnClick()
    if nil ~= self.data[21] then
        self:removeAllEvent()
        LuaController:removeAllPopup()
        local itemid = string.format(self.data[1])
        LuaController:toSelectUser(itemid,false,2)
    end
end

function GoldExchangeAdvCell:getCostBtnRect()
    if nil ~= self.m_costBtn then
        local size = self.m_costBtn:getContentSize()
        local pos = CCPoint(self.m_costBtn:getPosition())
        pos = self.m_costBtn:getParent():convertToWorldSpace(pos)
        pos = self.ccbNode:convertToNodeSpace(pos)
        local tmp = 0
        if not self.m_oldVersion then
            tmp = 10
        end
        return pos.x, pos.y+self.self_Y+tmp, size.width, size.height
    end
    return 0,0,0,0
end
