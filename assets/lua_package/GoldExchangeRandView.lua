require "lua_package.extern"
require "lua_package.CCBReaderLoad"
require "lua_package.common"
require "lua_package.GoldExchangeCell"
require "lua_package.GoldExchangeCell2"
require "lua_package.GoldExchangeCell1"


GoldExchangeLuaView  = GoldExchangeLuaView or {}
ccb["GoldExchangeLuaView"] = GoldExchangeLuaView

GoldExchangeRandView = class("GoldExchangeRandView",
	function()
        return cc.Layer:create()
	end
)
GoldExchangeRandView.__index = GoldExchangeRandView
function GoldExchangeRandView:create(parent,path,params)
	local node = GoldExchangeRandView.new()
	node:init(parent,path,params)
    parent:addChild(node)
	return node
end 

function GoldExchangeRandView:refreshBtn()
    print("refreshBtn view")

-- 粒子
    if nil ~= self.m_ani1Layer then
        for i = 1 , 3 do
            local particlesa= LuaController:createParticleForLua(self.rootPath .. "/particles/libaoshuaxin_" .. tostring(i))
            if nil ~= particlesa then
                self.m_ani1Layer:addChild(particlesa)
            end
        end
    end

    for i=1,#self.cellVec do

        local time = (i-1)*0.05
        local time1 = 0.06
        local seq = cc.Sequence:create(
            cc.DelayTime:create(time),
            cc.ScaleTo:create(time1,1,0.7),
            cc.ScaleTo:create(time1,1,0.3),
            cc.ScaleTo:create(time1,1,-0.3),
            cc.ScaleTo:create(time1,1,-0.7),
            cc.EaseSineIn:create(cc.ScaleTo:create(time1,1,1))
            )

        if nil ~= self.cellVec[i]["cell"] and nil ~= self.cellVec[i]["cell"]:getCellNode() then
            self.cellVec[i]["cell"]:getCellNode():runAction(seq)
        end
    end
end

function GoldExchangeRandView:setData(parent,path,params)
    local strPath = string.format(path)
    self.rootPath = strPath
    self.parentNode = parent
    self.isRemove =false

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
    self:initItems()
    self:initEquips()

    if nil ~= self.m_getGoldNumText then
            local numKey = string.format(self.data[3]);
            local numStr = string.format(LuaController:getCMDLang(numKey))
            self.m_getGoldNumText:setString(numStr)
    end
    if nil ~= self.m_percentLabel then
        local percentStr = string.format(self.data[8])
        percentStr = percentStr .. "%"
        self.m_percentLabel:setString(percentStr)
    end
    if nil ~= self.m_newPriceLabel then
        local dollar = string.format(self.data[4])
        local pID = string.format(self.data[11])
        local newPrice = string.format(LuaController:getDollarString(dollar,pID))
        self.m_newPriceLabel:setString(newPrice)
    end
    if nil ~= self.m_oldPriceLabel then
        local dollar1 = string.format(self.data[9])
        local oldPrice = string.format(LuaController:getDollarString(dollar1,""))
        self.m_oldPriceLabel:setString(oldPrice)
    end
    
    local cellHeight_height=90
    if self._isPad == true then
        cellHeight_height=72
    end

    self.cellVec = {}

    if nil ~= self.m_listNode then
            local size = self.m_listNode:getContentSize()
            self.m_listNode:removeAllChildren()
            self.scrollView1 = cc.ScrollView:create()
            if nil ~= self.scrollView1 then
                self.scrollView1:setViewSize(self.m_listNode:getContentSize())
                self.scrollView1:setPosition(CCPoint(0,0))
                self.scrollView1:setScale(1.0)
                self.scrollView1:ignoreAnchorPointForPosition(true)
                self.scrollView1:setDirection(1)
                self.scrollView1:setClippingToBounds(true)
                self.scrollView1:setBounceable(true)
                local offsetTotalY = 0
                local cellTotalHeight = cellHeight_height
                local tCount = table.getn(self.items)
                local offsetY = 0
                local posIndex = 1
                local  containerNode = cc.Layer:create()
                if nil ~= containerNode then
                    containerNode:setContentSize(cc.size(480,450))
                    self.scrollView1:setContainer(containerNode)
                end
                -- 总的Y
                offsetY = math.ceil(tCount)*cellTotalHeight
                local function showSingleItemData( index )
                    local sprite = GoldExchangeCell1:create(self.rootPath,self.items[index], self.data[19], self, 0)
                    sprite:setPositionX(45)
                    self.scrollView1:addChild(sprite)
                    sprite:setPositionY(offsetY)
                    self.cellVec[#self.cellVec+1] = {}
                    self.cellVec[#self.cellVec]["cell"] = sprite
                end

                for i = 1, tCount do
                        offsetY = offsetY - cellTotalHeight
                        showSingleItemData(tCount-i+1)
                        offsetTotalY = offsetTotalY + cellTotalHeight
                end
                local scrollviewWidth = 500
                self.scrollView1:setContentSize(cc.size(scrollviewWidth,offsetTotalY))
                local cH = self.m_listNode:getContentSize().height
                self.scrollView1:setContentOffset(CCPoint(0, cH - offsetTotalY))
                self.m_listNode:addChild(self.scrollView1);

                print("<<<<<<<< m_listNode setData")
            end
        end
end

function GoldExchangeRandView:init(parent,path,params)
    -- debug test
    print(" xxx  aa xxx")
    print("GoldExchangeRandView AA")
    local strPath = string.format(path)
    self.rootPath = strPath
	self.parentNode = parent
    self.isRemove =false

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
    self:initItems()
    self:initEquips()
    local popImg = string.format(self.data[19])

    loadLuaResource(self.rootPath .. "/resources/randGold.plist")
    loadLuaResource(self.rootPath .. "/resources/lua_common.plist")
    LuaController:autoDoResourceEquipIcon(self)
    LuaController:autoDoResourceItemIcon(self)  

    self.m_oldVersion = true
    xpcall( function ()
        local viewVersion = LuaController:getLuaViewVersion() or "ver_0"
        if viewVersion ~= "ver_0" then
            self.m_oldVersion = false
        end
    end, function ()
        self.m_oldVersion = true
    end)

    local  proxy = cc.CCBProxy:create()
    GoldExchangeLuaView.onClickCostBtn = function()
    	self:onClickCostBtn()
	end
   	GoldExchangeLuaView.onCloseBtnClick = function()
   		self:onCloseBtnClick()
    end
    GoldExchangeLuaView.onPackageBtnClick = function ()
        self:onPackageBtnClick()
    end
    GoldExchangeLuaView.onBtnRand = function()
        self:onBtnRand()
    end

    self._isPad = false;
    xpcall( function ()
        self._isPad = LuaController:isPad()
    end, function ()
        
    end)

    local ccbiURL = strPath .. "/ccbi/GoldExchangeRandLuaView.ccbi"
    local node  = CCBReaderLoad(ccbiURL,proxy,GoldExchangeLuaView)

    local  layer = tolua.cast(node,"cc.Layer")
    if nil ~= GoldExchangeLuaView["m_timeLabel"] then
        self.m_timeLabel = tolua.cast(GoldExchangeLuaView["m_timeLabel"],"cc.Label")
        if nil ~= self.m_timeLabel then
            self.m_timeLabel:setString("m_timeLabel")
        end
    end
    if nil ~= GoldExchangeLuaView["m_titleLabel"] then
        self.m_titleLabel = tolua.cast(GoldExchangeLuaView["m_titleLabel"],"cc.Label")
        if nil ~= self.m_titleLabel then
            local titleStr = string.format(LuaController:getLang("79022079"))
            self.m_titleLabel:setString(titleStr)
        end
    end
    
    if nil ~= GoldExchangeLuaView["m_percentLabel"] then
        self.m_percentLabel = tolua.cast(GoldExchangeLuaView["m_percentLabel"],"cc.LabelBMFont")
        if nil ~= self.m_percentLabel then
            local percentStr = string.format(self.data[8])
            percentStr = percentStr .. "%"
            self.m_percentLabel:setString(percentStr)
        end
    end

    if nil ~= GoldExchangeLuaView["m_getGoldNumText"] then
        self.m_getGoldNumText = tolua.cast(GoldExchangeLuaView["m_getGoldNumText"],"cc.LabelBMFont")
        if nil ~= self.m_getGoldNumText then
            local numKey = string.format(self.data[3]);
            local numStr = string.format(LuaController:getCMDLang(numKey))
            self.m_getGoldNumText:setString(numStr)
        end
    end

    if nil ~= GoldExchangeLuaView["m_getLabel1"] then
        self.m_getLabel1 = tolua.cast(GoldExchangeLuaView["m_getLabel1"],"cc.Label")
        if nil ~= self.m_getLabel1 then
            local lblGet1Str = string.format(LuaController:getLang1("101237",""))
            --print(lblGet1Str)
            self.m_getLabel1:setString(lblGet1Str)
        end
    end

    if nil ~= GoldExchangeLuaView["m_getLabel"] then
        self.m_getLabel = tolua.cast(GoldExchangeLuaView["m_getLabel"],"cc.Label")
        if nil ~= self.m_getLabel then
            local lblGetStr = string.format(LuaController:getLang1("115073",""))
            --print(lblGetStr)
            self.m_getLabel:setString(lblGetStr)
        end
    end

    if nil ~= GoldExchangeLuaView["m_presentPriceLable"] then
        self.m_presentPriceLable = tolua.cast(GoldExchangeLuaView["m_presentPriceLable"],"cc.Label")
        if nil ~= self.m_presentPriceLable then
            local dollar = string.format(self.data[4])
            local pID = string.format(self.data[11])
            local newPrice = string.format(LuaController:getDollarString(dollar,pID))
            self.m_presentPriceLable:setString(newPrice)
        end
    end
    if nil ~= GoldExchangeLuaView["m_newPriceLabel"] then
        self.m_newPriceLabel = tolua.cast(GoldExchangeLuaView["m_newPriceLabel"],"cc.Label")
        if nil ~= self.m_newPriceLabel then
            local dollar = string.format(self.data[4])
            local pID = string.format(self.data[11])
            local newPrice = string.format(LuaController:getDollarString(dollar,pID))
            self.m_newPriceLabel:setString(newPrice)
        end
    end

    if nil ~= GoldExchangeLuaView["m_oldPriceLabel"] then
        self.m_oldPriceLabel = tolua.cast(GoldExchangeLuaView["m_oldPriceLabel"],"cc.Label")
        if nil ~= self.m_oldPriceLabel then
            local dollar1 = string.format(self.data[9])
            local oldPrice = string.format(LuaController:getDollarString(dollar1,""))
            self.m_oldPriceLabel:setString(oldPrice)
        end
    end

    self.m_lblDesBg = tolua.cast(GoldExchangeLuaView["m_lblDesBg"],"cc.Sprite")

    if nil ~= GoldExchangeLuaView["m_lblDes"] then
        self.m_lblDes = tolua.cast(GoldExchangeLuaView["m_lblDes"],"cc.Label")
        if nil ~= self.m_lblDes then
            local desString1 = ""
            if "" == desString1 then
                desString1 = tostring(LuaController:getLang(self.data[23]))
            end
            if "" == desString1 and self.m_lblDesBg ~= nil then
            	self.m_lblDesBg:setVisible(false)
            end
            self.m_lblDes:setString(desString1)
        end
    end
    if nil ~= GoldExchangeLuaView["m_lblDes1"] then
        self.m_lblDes1 = tolua.cast(GoldExchangeLuaView["m_lblDes1"],"cc.Label")
        if nil ~= self.m_lblDes1 then
            local desString2 = nil
        end
    end

    if nil ~= GoldExchangeLuaView["m_soleOutSpr"] then
        self.m_soleOutSpr = tolua.cast(GoldExchangeLuaView["m_soleOutSpr"],"cc.Sprite")
        if nil ~= self.m_soleOutSpr then
        end
    end

    if nil ~= GoldExchangeLuaView["m_moreNode"] then
    	self.m_moreNode = tolua.cast(GoldExchangeLuaView["m_moreNode"],"cc.LayerColor")
    	if nil ~= self.m_moreNode then
    		local w = self.m_moreNode:getContentSize().width
    		local h = self.m_moreNode:getContentSize().height
            self.m_moreNode:setVisible(false)
    	end
    end

    if nil ~= GoldExchangeLuaView["m_moreSpr"] then
        self.m_moreSpr = tolua.cast(GoldExchangeLuaView["m_moreSpr"],"cc.Sprite")
        if nil ~= self.m_moreSpr then
        end
    end

    if nil ~= GoldExchangeLuaView["m_sprCha"] then
        self.m_sprCha = tolua.cast(GoldExchangeLuaView["m_sprCha"],"cc.Sprite")
    end

    if nil ~= GoldExchangeLuaView["m_moreLabel"] then
        self.m_moreLabel = tolua.cast(GoldExchangeLuaView["m_moreLabel"],"cc.Label")
        if nil ~= self.m_moreLabel then
            local moreStr = string.format(LuaController:getLang("102162"))
            self.m_moreLabel:setString(moreStr)
        end
    end

    if nil ~= GoldExchangeLuaView["m_touchMoreNode"] then
    	self.m_touchMoreNode = tolua.cast(GoldExchangeLuaView["m_touchMoreNode"],"cc.LayerColor")
    end

    if nil ~= GoldExchangeLuaView["m_touchNode1"] then
        self.m_touchNode1 = tolua.cast(GoldExchangeLuaView["m_touchNode1"],"cc.LayerColor")
    end

    if nil ~= GoldExchangeLuaView["m_touchNode"] then
    	self.m_touchNode = tolua.cast(GoldExchangeLuaView["m_touchNode"],"cc.LayerColor")
    	if nil ~= self.m_touchNode then
    		local size = self.m_touchNode:getContentSize()
    		function onTouch(eventType, x, y)
				if eventType == "began" then
					return self:onTouchBegan(x, y)
				elseif eventType == "moved" then
					return self:onTouchMoved(x, y)
    			else
        			return self:onTouchEnded(x, y)
    			end
    		end
    		self.m_touchNode:registerScriptTouchHandler(onTouch)
    		self.m_touchNode:setTouchEnabled(true)
    	end
    end

    if nil ~= GoldExchangeLuaView["m_buyNode"] then
        self.m_buyNode = tolua.cast(GoldExchangeLuaView["m_buyNode"],"cc.LayerColor")
    end

    if nil ~= GoldExchangeLuaView["m_packageBtn"] then
        self.m_packageBtn = tolua.cast(GoldExchangeLuaView["m_packageBtn"],"cc.ControlButton")
    end

    if nil ~= GoldExchangeLuaView["m_costBtn"] then
        self.m_costBtn = tolua.cast(GoldExchangeLuaView["m_costBtn"],"cc.ControlButton")
        if nil ~= self.m_costBtn then

            xpcall(function ()
                if LuaController:isGM() then
                    local id = cc.LabelTTF:create("ID:" .. tostring(self.data[1]), "Arial", 24);
                    id:setPosition(cc.p(self.m_costBtn:getContentSize().width*0.55, 70));
                    self.m_costBtn:addChild(id, 100)
                end
            end, function ()
                -- body
            end)

            local extWidth = 0
            local lableW = self.m_oldPriceLabel:getContentSize().width
            local maxWidth = (self.m_costBtn:getPreferredSize().width - 100) * 0.5
            
            if lableW > maxWidth then
                extWidth = lableW - maxWidth
                if nil ~= self.m_sprCha then
                end
            end
            lableW = self.m_newPriceLabel:getContentSize().width
            if lableW > maxWidth then
                extWidth = lableW - maxWidth + extWidth
            end
            if extWidth > 0 then
                local costsize = self.m_costBtn:getContentSize()
                costsize.width = costsize.width + extWidth
                self.m_costBtn:setPreferredSize(costsize)
            end
            LuaController:addButtonLight(self.m_costBtn)
            local showPackBtn = false
            if self.data[21] ~= nil then
                if self.data[21] == "1" then
                    showPackBtn = true
                end
            end
            if showPackBtn == true then
                if self.m_packageBtn ~= nil then
                    self.m_packageBtn:setVisible(true)
                    if extWidth > 0 then
                        self.m_packageBtn:setPositionX(self.m_packageBtn:getPositionX() + extWidth*0.5)
                    end
                end
                if self.m_buyNode ~= nil then
                    self.m_buyNode:setPositionX(-35)
                end
            else
                if self.m_packageBtn ~= nil then
                    self.m_packageBtn:setVisible(false)
                end
                if self.m_buyNode ~= nil then
                    self.m_buyNode:setPositionX(0)
                end
            end
        end
    end
    
    if nil ~= GoldExchangeLuaView["m_costNode"] then
        self.m_costNode = tolua.cast(GoldExchangeLuaView["m_costNode"],"cc.Node")
    end
    if nil ~= GoldExchangeLuaView["m_randNode"] then
        self.m_randNode = tolua.cast(GoldExchangeLuaView["m_randNode"],"cc.Node")
    end
    if nil ~= GoldExchangeLuaView["m_randBtn"] then
        self.m_randBtn = tolua.cast(GoldExchangeLuaView["m_randBtn"],"cc.ControlButton")   
    end
    if nil ~= GoldExchangeLuaView["m_randBtnLabel"] then
        self.m_randBtnLabel = tolua.cast(GoldExchangeLuaView["m_randBtnLabel"],"cc.Label") 
    end
    if nil ~= GoldExchangeLuaView["m_ani1"] then
        self.m_ani1Layer = tolua.cast(GoldExchangeLuaView["m_ani1"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeLuaView["m_ani2"] then
        self.m_ani2Layer = tolua.cast(GoldExchangeLuaView["m_ani2"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeLuaView["m_ani3"] then
        self.m_ani3Layer = tolua.cast(GoldExchangeLuaView["m_ani3"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeLuaView["m_ani4"] then
        self.m_ani4Layer = tolua.cast(GoldExchangeLuaView["m_ani4"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeLuaView["m_ani5"] then
        self.m_ani5Layer = tolua.cast(GoldExchangeLuaView["m_ani5"],"cc.LayerColor")
    end
    if nil ~= GoldExchangeLuaView["m_ani6"] then
        self.m_ani6Layer = tolua.cast(GoldExchangeLuaView["m_ani6"],"cc.LayerColor")
    end

    if nil ~= GoldExchangeLuaView["m_labTimerTip"] then
        self.m_labTimerTip = tolua.cast(GoldExchangeLuaView["m_labTimerTip"],"cc.Label")
        self.m_labTimerTip:setVisible( true )
        self.m_labTimerTip:setString("Rinaime:")
    end

    --[[
        在这个地方根据popImg不同则创建不同的布局
    ]]

    local cellHeight_height=90
    if self._isPad == true then
        cellHeight_height=72
    end

    self.cellVec = {}
    if nil ~= GoldExchangeLuaView["m_listNode"] then
    	self.m_listNode = tolua.cast(GoldExchangeLuaView["m_listNode"],"cc.LayerColor")
    	if nil ~= self.m_listNode then
            local size = self.m_listNode:getContentSize()
            self.m_listNode:removeAllChildren()
            self.scrollView1 = cc.ScrollView:create()
            if nil ~= self.scrollView1 then
                self.scrollView1:setViewSize(self.m_listNode:getContentSize())
                self.scrollView1:setPosition(CCPoint(0,0))
                self.scrollView1:setScale(1.0)
                self.scrollView1:ignoreAnchorPointForPosition(true)
                self.scrollView1:setDirection(1)
                self.scrollView1:setClippingToBounds(true)
                self.scrollView1:setBounceable(true)
                local offsetTotalY = 0
                local cellTotalHeight = cellHeight_height
                local tCount = table.getn(self.items)
                local offsetY = 0
                local posIndex = 1
                local  containerNode = cc.Layer:create()
                if nil ~= containerNode then
                    containerNode:setContentSize(cc.size(480,450))
                    self.scrollView1:setContainer(containerNode)
                end

                -- 总的Y
                offsetY = math.ceil(tCount)*cellTotalHeight

                local function showSingleItemData( index )
                    local sprite = GoldExchangeCell1:create(self.rootPath,self.items[index], self.data[19], self, 0)
                    sprite:setPositionX(45 + (posIndex - 1)*cellHeight_height)
                    self.scrollView1:addChild(sprite)
                    sprite:setPositionY(offsetY)

                    self.cellVec[#self.cellVec+1] = {}
                    self.cellVec[#self.cellVec]["cell"] = sprite
                end

                for i = 1, tCount do
                        offsetY = offsetY - cellTotalHeight
                        showSingleItemData(tCount-i+1)
                        offsetTotalY = offsetTotalY + cellTotalHeight
                end
		        
                local scrollviewWidth = 500
                self.scrollView1:setContentSize(cc.size(scrollviewWidth,offsetTotalY))
                local cH = self.m_listNode:getContentSize().height
                self.scrollView1:setContentOffset(CCPoint(0, cH - offsetTotalY))
                self.m_listNode:addChild(self.scrollView1);
            end
    	end
    end


    if(self.data[15] == "1") then
        self.m_soleOutSpr:setVisible(true)
        self.m_costBtn:setEnabled(false)
    else
        self.m_soleOutSpr:setVisible(false)
        self.m_costBtn:setEnabled(true)
    end

    if nil ~= self.m_randBtnLabel then
        local str = string.format(LuaController:getLang("104932"))
        self.m_randBtnLabel:setString(str)
    end
    if nil ~= self.m_randBtn then
        self.m_randBtn:setEnabled(true)
    end

    if nil ~= self.m_timeLabel then
        schedule(self.m_timeLabel,scheduleDealWithFunc({target = self}),1)
    end

   	self.parentNode:addChild(node);
    local nodeSize = node:getContentSize()
    local winSize = cc.Director:getInstance():getWinSize()
    node:setPosition(CCPoint((winSize.width-nodeSize.width)*0.5,(winSize.height-nodeSize.height)*0.5))

    self.ccbNode = node

    local function onNodeEvent(event)
        if event == "enter" then
            if self._isPad == true then
                node:setScale(1.25)
            end
        elseif event == "exit" then
            self:onExit()
        end
    end
    self.ccbNode:registerScriptHandler(onNodeEvent)

end

function GoldExchangeRandView:onClickCostBtn()
    local itemid = string.format(self.data[1])
    -- LuaController:callPayment(itemid)
    LuaController:callPayRandRackage()
    Test["goldRandView"] = nil
    if(self.isRemove == false ) then
        self:destroySelf()
    end
end
function GoldExchangeRandView:onBtnRand()
    local itemid = string.format(self.data[1])
    LuaController:getRandPackage()
end
function GoldExchangeRandView:onCloseBtnClick()
   Test["goldRandView"] = nil
   self:destroySelf()
end
function GoldExchangeRandView:destroySelf()
    LuaController:removeLastPopup()
end
function GoldExchangeRandView:onExit()

    self:removeAllEvent()
    releaseLuaResource(self.rootPath .. "/resources/"..self.data[19])
    releaseLuaResource(self.rootPath .. "/resources/"..self.data[19] .."adv")
    
end
function GoldExchangeRandView:onPackageBtnClick()
    if nil ~= self.data[21] then
        if(self.isRemove == false ) then
            self:destroySelf()
        end
        local itemid = string.format(self.data[1])
        LuaController:toSelectUser(itemid,false,1)
    end
end
function GoldExchangeRandView:removeAllEvent()

    GoldExchangeLuaView.onClickCostBtn = nil
    GoldExchangeLuaView.onCloseBtnClick = nil
    GoldExchangeLuaView.onPackageBtnClick = nil
    GoldExchangeLuaView.onBtnRand = nil
    if nil~= self.m_touchNode then
        self.m_touchNode:unregisterScriptTouchHandler()
    end
    if nil ~= self.m_costBtn then
        self.m_costBtn:setTouchEnabled(false)
    end
    if nil ~= self.m_randBtn then
        self.m_randBtn:setTouchEnabled(false)
    end
    if nil ~=self.m_timeLabel then
        self.m_timeLabel:stopAllActions()
    end
    if nil ~= self.ccbNode then
        self.ccbNode:unregisterScriptHandler()
    end
end
function GoldExchangeRandView:callbackFunc()
	if(self.isRemove == true) then
        self:destroySelf()
    end
end
function GoldExchangeRandView:scheduleBack()

end
function GoldExchangeRandView:onTouchBegan(x, y)
    if(self.isRemove==false) then
        if(nil ~= self.m_touchNode1) then
            if(nil ~= self.m_touchNode1:getParent()) then
                local pos = self.m_touchNode1:getParent():convertToNodeSpace(CCPoint(x,y))
                local rect = self.m_touchNode1:getBoundingBox()
                if (cc.rectContainsPoint(rect, pos) == true) then
                    return true
                end
            end
        end
        if(nil ~= self.m_touchNode) then
            if(nil ~= self.m_touchNode:getParent()) then
                local pos = self.m_touchNode:getParent():convertToNodeSpace(CCPoint(x,y))
                local rect = self.m_touchNode:getBoundingBox()
                if (cc.rectContainsPoint(rect, pos) == true) then
                    return false
                end
            end
        end
        if nil ~= self.m_costBtn then
            if(nil ~= self.m_costBtn:getParent()) then
                local pos = self.m_costBtn:getParent():convertToNodeSpace(cc.p(x,y))
                local rect = self.m_costBtn:getBoundingBox()
                if(cc.rectContainsPoint(rect, pos) == true) then
                    return false
                end
            end
        end
        if nil ~= self.m_packageBtn then
            if(nil ~= self.m_packageBtn:getParent()) then
                local pos = self.m_packageBtn:getParent():convertToNodeSpace(cc.p(x,y))
                local rect = self.m_packageBtn:getBoundingBox()
                if(cc.rectContainsPoint(rect, pos) == true) then
                    return false
                end
            end
        end
    end
    return true
end
function GoldExchangeRandView:onTouchMoved(x, y)
	print "touch move"
end
function GoldExchangeRandView:onTouchEnded(x, y)
    local close = true
    if(nil ~= self.m_touchNode1) then
        if(nil ~= self.m_touchNode1:getParent()) then
            local pos = self.m_touchNode1:getParent():convertToNodeSpace(CCPoint(x,y))
            local rect = self.m_touchNode1:getBoundingBox()
            if (cc.rectContainsPoint(rect, pos) == true) then
                xpcall(function ()
                    close = false
                    LuaController:showDetailPopUpView(self.data[25])
                end, function ()
                end)
            end
        end
    end
    if (close == true) then
        self:onCloseBtnClick()
    end
    
end
function GoldExchangeRandView:initItems()
    local itemsStr = string.format(self.data[7])
    --print(itemsStr)
    self.items = {}
    local itemIndex = 1
    local itemSIndex = 1
    local itemFIndex = string.find(itemsStr,"|",itemSIndex)
    while(true) do
        local itemValueTmp = string.sub(itemsStr,itemSIndex,itemFIndex-1)
        local itemFindIndex =  string.find(itemValueTmp,";",1);
        local tabelValue1 = string.sub(itemValueTmp,1,itemFindIndex-1)
        local tabelVaule2 = string.sub(itemValueTmp,itemFindIndex+1,string.len(itemValueTmp))
        local iValue = {tabelValue1,tabelVaule2}
        self.items[itemIndex] = iValue;
        itemIndex = itemIndex + 1
        itemSIndex =  itemFIndex + 1
        itemFIndex = string.find(itemsStr,"|",itemSIndex)
        if itemFIndex == nil then
            itemValueTmp = string.sub(itemsStr,itemSIndex,string.len(itemsStr))
            itemFindIndex =  string.find(itemValueTmp,";",1)
            tabelValue1 = string.sub(itemValueTmp,1,itemFindIndex-1)
            tabelVaule2 = string.sub(itemValueTmp,itemFindIndex+1,string.len(itemValueTmp))
            iValue = {tabelValue1,tabelVaule2}
            self.items[itemIndex] = iValue;
            return
        end
    end
end
function GoldExchangeRandView:initEquips()
    self.equips = nil
    if nil == self.data[20] then
        return
    end
    local itemsStr = string.format(self.data[20])
    if(itemsStr == "") then
        return
    end

    self.equips = {}
    local itemIndex = 1
    local itemSIndex = 1
    local itemFIndex = string.find(itemsStr,"|",itemSIndex)
    while(true) do
        local itemValueTmp = string.sub(itemsStr,itemSIndex,itemFIndex-1)
        local itemFindIndex =  string.find(itemValueTmp,";",1);
        local tabelValue1 = string.sub(itemValueTmp,1,itemFindIndex-1)
        local tabelVaule2 = string.sub(itemValueTmp,itemFindIndex+1,string.len(itemValueTmp))
        local iValue = {tabelValue1,tabelVaule2}
        self.equips[itemIndex] = iValue;
        itemIndex = itemIndex + 1
        itemSIndex =  itemFIndex + 1
        itemFIndex = string.find(itemsStr,"|",itemSIndex)
        if itemFIndex == nil then
            itemValueTmp = string.sub(itemsStr,itemSIndex,string.len(itemsStr))
            itemFindIndex =  string.find(itemValueTmp,";",1)
            tabelValue1 = string.sub(itemValueTmp,1,itemFindIndex-1)
            tabelVaule2 = string.sub(itemValueTmp,itemFindIndex+1,string.len(itemValueTmp))
            iValue = {tabelValue1,tabelVaule2}
            self.equips[itemIndex] = iValue;
            return
        end
    end
end
