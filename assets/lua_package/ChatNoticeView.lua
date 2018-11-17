require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"

ChatNoticeLuaView  = ChatNoticeLuaView or {}
ccb["ChatNoticeLuaView"] = ChatNoticeLuaView

ChatNoticeView = class("ChatNoticeView",
    function()
        return cc.Layer:create() 
    end
)
ChatNoticeView.__index = ChatNoticeView
function ChatNoticeView:create(parent,path,params,time,shadow)
    local node = ChatNoticeView.new()
    node:init(parent,path,params,time,shadow)
    return node
end
function ChatNoticeView:init(parent,path,params,time,shadow)
    local strPath = string.format(path)
    self.rootPath = strPath
    self.parentNode = parent
    self.data = params
    self.showTime = time
    self.tick = 0.33
    self.speed = 20
    self.bshadow = shadow
    self.isRemove=false
    loadLuaResource(self.rootPath .. "/resources/chatNotice.plist")
    local proxy = cc.CCBProxy:create()
    local ccbiUrl = strPath .. "/" .. self:getCCBI()
    local winsize = cc.Director:getInstance():getWinSize()
    if self.bshadow == true then
        self.maxW = winsize.width
    else
        self.maxW = winsize.width*0.9
    end
    local ccbnode = CCBReaderLoad(ccbiUrl,proxy,ChatNoticeLuaView)
    if ccbnode ~= nil then
        local layer = tolua.cast(ccbnode,"cc.Layer")
        if nil ~= ChatNoticeLuaView["mScale9BG"] then
            self.bgSpr = tolua.cast(ChatNoticeLuaView["mScale9BG"],"ccui.Scale9Sprite")
            if nil ~= self.bgSpr then
                self.bgSpr:setPreferredSize(CCSize(self.maxW,self.bgSpr:getPreferredSize().height))
            end
        end
        if nil ~= ChatNoticeLuaView["mSpr1"] then
            self.spr1 = tolua.cast(ChatNoticeLuaView["mSpr1"],"cc.Sprite")
            if nil ~= self.spr1 then
                self.spr1:setPositionX(-self.maxW*0.5 + 30)
            end
        end
        local listPosX = 0
        if nil ~= ChatNoticeLuaView["mNameLabel"] then
            self.mNameLabel = tolua.cast(ChatNoticeLuaView["mNameLabel"],"cc.Label")
            if nil ~= self.mNameLabel then
                local showName = "null"
                if nil ~= self.data then
                    if nil ~= self.data.senderUid then
                        local uidString = string.format(self.data.senderUid)
                        if uidString == "3000002" then
                            showName = LuaController:getLang("3000002") .. ": "
                        else
                            if nil ~= self.data.senderName then
                                if nil ~= self.data.asn then
                                    showName = "(" .. self.data.asn .. ")" .. self.data.senderName .. ": "
                                else
                                    showName = self.data.senderName .. ": "
                                end
                            end
                        end
                    end
                end
                self.mNameLabel:setString(showName)
                if nil ~= self.spr1 then
                    self.mNameLabel:setPositionX(self.spr1:getPositionX() + 15)
                end
                listPosX = self.mNameLabel:getPositionX() + self.mNameLabel:getContentSize().width + 10
            end
        end
        if nil ~= ChatNoticeLuaView["mSpr2"] then
            self.spr2 = tolua.cast(ChatNoticeLuaView["mSpr2"],"cc.Sprite")
            if nil ~= self.spr2 then
                self.spr2:setPositionX(self.maxW*0.5 - 30)
            end
        end
        if nil ~= ChatNoticeLuaView["mNodeClose"] then
            self.nodeClose = tolua.cast(ChatNoticeLuaView["mNodeClose"],"cc.LayerColor")
            if nil ~= self.nodeClose then
                local size = self.nodeClose:getContentSize()
                local function onTouch(eventType, x, y)  
                    if eventType == "began" then
                        --print "eventType == began"
                        --print "function ChatNoticeView:onTouchBegan(x, y)"
                        if(nil ~= self.nodeClose) then
                            --print "1"
                            if(nil ~= self.nodeClose:getParent()) then
                                --print "2"
                                local pos = self.nodeClose:getParent():convertToNodeSpace(CCPoint(x,y))
                                --print "3"
                                local rect = self.nodeClose:getBoundingBox()
                                --print "4"
                                if(cc.rectContainsPoint(rect, pos) == true) then
                                    --print "5"
                                    return true
                                end
                            end
                        end
                        --print "6"
                        return false  
                        --return self:onTouchBegan(x, y)  
                    elseif eventType == "moved" then  
                        --print "eventType == moved" 
                        --print "touch move ing ing" 
                        --return self:onTouchMoved(x, y)  
                    else  
                        --print "eventType == end" 
                        --print "LuaController:getInstance():closeChatNotice()"
                        LuaController:getInstance():closeChatNotice() 
                        --return self:onTouchEnded(x, y)  
                    end
                end
                self.nodeClose:registerScriptTouchHandler(onTouch)
                self.nodeClose:setTouchEnabled(true)
                self.nodeClose:setSwallowsTouches(true)
                if nil ~= self.spr2 then
                    self.nodeClose:setPositionX(self.spr2:getPositionX() - 30)
                end
            end
            
            --self.nodeClose:setTouchPriority(-1)
            
            ----print "m_touchNode___init____[" .. size.width .. "," .. size.height .."]"
        end
        --print "9"
        if nil ~= ChatNoticeLuaView["mNodeList"] then
            self.nodeList = tolua.cast(ChatNoticeLuaView["mNodeList"],"cc.LayerColor")
            if nil ~= self.nodeList then
                local tmpSize = self.maxW * 0.5 - listPosX - 60
                self.nodeList:setContentSize(CCSize(tmpSize,self.nodeList:getContentSize().height))
                self.nodeList:setPositionX(listPosX)
                local contentStr = "null"
                if nil ~= self.data then
                    if nil ~= self.data.msg then
                        contentStr = string.format(self.data.msg)
                    end
                end
                local contents = {}
                local cLen = LuaController:getStringLength(contentStr)
                local cStep = 20
                if cLen>cStep then
                    local bGo = true
                    local startIndex = 0
                    while(bGo) do
                        if startIndex > cLen then
                            bGo = false
                            break
                        end
                        local endIndex = startIndex + cStep - 1
                        if endIndex > cLen then
                            local cStrTmp1 = LuaController:getUTF8SubString(contentStr,startIndex,cLen)
                            --print("ff[" .. string.format(startIndex) .. "," .. string.format(cLen) .. "]" .. cStrTmp1)
                            if LuaController:getStringLength(cStrTmp1) >0 then
                                local nSize = table.getn(contents)
                                contents[nSize+1] = cStrTmp1
                            end
                            bGo =false
                            break
                        else
                            local cStrTmp2 = LuaController:getUTF8SubString(contentStr,startIndex,endIndex)
                            --print("cc[" .. string.format(startIndex) .. "," .. string.format(endIndex) .. "]" .. cStrTmp2)
                            if LuaController:getStringLength(cStrTmp2) >0 then
                                local nSize = table.getn(contents)
                                contents[nSize+1] = cStrTmp2
                            end
                            startIndex = startIndex + cStep
                        end
                    end
                else
                    local nSize = table.getn(contents)
                    contents[nSize+1] = contentStr
                    --print("contents[1] = " .. contentStr)
                end
                self.maxW = self.nodeList:getContentSize().width

                self.scrollView1 = cc.ScrollView:create()
                self.scrollView1:setViewSize(self.nodeList:getContentSize())
                self.scrollView1:setPosition(CCPoint(0,0))
                self.scrollView1:setScale(1.0)
                self.scrollView1:ignoreAnchorPointForPosition(true)
                self.scrollView1:setDirection(0)
                self.scrollView1:setClippingToBounds(true)
                self.scrollView1:setBounceable(false)
                self.scrollView1:setTouchEnabled(false)
                self.nodeList:addChild(self.scrollView1)


                local nodeContent = cc.Node:create()
                self.scrollView1:addChild(nodeContent)

                local lblH = 25
                local totalLen = 0
                local offsetX = 0
                for i,v in ipairs(contents) do
                    --print(i,v)
                    local label1 = cc.Label:create()
                    label1:setAnchorPoint(CCPoint(0,0.5))
                    label1:setColor(cc.c3b(255,255,255))
                    label1:setSystemFontSize(24)
                    label1:setSystemFontName("Helvetica")
                    label1:setString(v)
                    nodeContent:addChild(label1)
                    local lblSize1 = label1:getContentSize()
                    totalLen = lblSize1.width + totalLen
                    label1:setPosition(offsetX,lblH)
                    offsetX = offsetX + lblSize1.width
                end

                if totalLen > self.maxW then
                    local defineSTime = self.showTime
                    local perSp = self.speed / self.tick

                    local scrollTime = (totalLen+self.maxW) / perSp
                    --if scrollTime < defineSTime then
                        local addLen = 0
                        offsetX = offsetX + 80
                        for i,v in ipairs(contents) do
                            local label2 = cc.Label:create()
                            label2:setAnchorPoint(CCPoint(0,0.5))
                            label2:setColor(cc.c3b(255,255,255))
                            label2:setSystemFontSize(24)
                            label2:setSystemFontName("Helvetica")
                            label2:setString(v)
                            nodeContent:addChild(label2)
                            local lblSize2 = label2:getContentSize()
                            addLen = lblSize2.width + addLen
                            label2:setPosition(offsetX,lblH)
                            offsetX = offsetX + lblSize2.width
                        end
                        totalLen = totalLen + 80 + addLen
                        self.showTime = (totalLen+self.maxW) / perSp
                    --else
                    --    self.showTime = scrollTime + self.tick    
                    --end
                    self.scrollView1:setContentSize(CCSize(totalLen + 10,50))
                    self.scrollView1:getContainer():setPositionX(self.maxW)
                    self.offset = self.scrollView1:getContentOffset()
                    self.scrollView1:getContainer():runAction(cc.MoveTo:create(self.showTime, CCPoint(-totalLen, self.offset.y)))
                else
                    self.scrollView1:setContentSize(CCSize(totalLen + 10 ,50))
                    --self.scrollView1:getContainer():setPositionX((self.maxW - totalLen)*0.5)
                    --self.scrollView1:setPositionX((self.maxW - totalLen)*0.5)                    
                end
            end
        end
        if nil ~= self.parentNode then
            if self.bshadow == false then
                -- ccbnode:setTag(99999)
                self:setTag(99999)
                ccbnode:setPosition(CCPoint(0,winsize.height-160))
            else
                -- ccbnode:setTag(99998)
                self:setTag(99998)
                ccbnode:setPosition(CCPoint(0,winsize.height-130))
            end
            -- self.parentNode:addChild(ccbnode)
            self.parentNode:addChild(self)
            self:addChild(ccbnode)
        end
    end
    self.ccbNode = ccbnode
    local function onNodeEvent(event)
        if event == "enter" then
        elseif event == "exit" then
            self:onExit()
        end
    end
    self.ccbNode:registerScriptHandler(onNodeEvent)
end
function ChatNoticeView:scheduleBack()
    if self.isRemove == true then
        LuaController:getInstance():closeChatNotice()
    end
    --print ("scrollView1 offset " .. string.format(self.offset.x) .. "," .. string.format(self.offset.y)) 
end
function ChatNoticeView:onExit()
    --print "ChatNoticeView_exit"
    if nil ~= self.ccbNode then
        self.ccbNode:unregisterScriptHandler()
    end
    if nil ~= self.nodeClose then
        self.nodeClose:unregisterScriptTouchHandler()
    end
    releaseLuaResource(self.rootPath .. "/resources/chatNotice")
end
function ChatNoticeView:getTime()
    --print("______showTime:" .. string.format(self.showTime))
    return self.showTime
end
--[[
function ChatNoticeView:onTouchBegan(x, y)
    if(nil ~= self.nodeClose) then
        if(nil ~= self.nodeClose:getParent()) then
            local pos = self.nodeClose:getParent():convertToNodeSpace(CCPoint(x,y))
            local rect = self.nodeClose:getBoundingBox()
            if(cc.rectContainsPoint(rect, pos) == true) then
                return true
            end
        end
    end
    return false
end
function ChatNoticeView:onTouchMoved(x, y)
    print "touch move"
end
function ChatNoticeView:onTouchEnded(x, y)
    LuaController:getInstance():closeChatNotice()
    --if(self.isRemove==false) then
    --    self.isRemove=true
    --    schedule(self.mNameLabel,scheduleDealWithFunc({target = self}),0.2)
    --end
end
]]
function ChatNoticeView:getCCBI()
    --local actName = string.format(self.data[19])
    --return "ccbi/GoldExchange"..actName.."LuaIcon.ccbi"
    if self.bshadow == true then
        return "ccbi/ChatNoticeLuaView.ccbi"
    else
        return "ccbi/ChatNoticeSLuaView.ccbi"
    end
end
