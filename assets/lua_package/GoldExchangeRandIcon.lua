require "extern"
require "CCBReaderLoad"
require "common"

GoldExchangeRandIcon  = GoldExchangeRandIcon or {}
ccb["GoldExchangeRandLuaIcon"] = GoldExchangeRandIcon

GoldExchangeRandIcon = class("GoldExchangeRandIcon",
	function()
        return cc.Layer:create() 
	end
)
GoldExchangeRandIcon.__index = GoldExchangeRandIcon
function GoldExchangeRandIcon:create(parent,path,params)
    local node = GoldExchangeRandIcon.new()
    node:init(parent,path,params)
    return node
end
function GoldExchangeRandIcon:init(parent,path,params)
    local strPath = string.format(path)
    self.rootPath = strPath
    self.parentNode = parent
    self:setData(params)

    loadLuaResource(self.rootPath .. "/resources/randGold.plist")
    loadLuaResource(self.rootPath .. "/resources/lua_common.plist")
    local ccbiUrl = strPath .. "/" .. self:getCCBI()
    local proxy = cc.CCBProxy:create()
    self.ccbnode = CCBReaderLoad(ccbiUrl,proxy,GoldExchangeRandIcon)

    self.m_oldVersion = true
    xpcall( function ()
        local viewVersion = LuaController:getLuaViewVersion() or "ver_0"
        if viewVersion ~= "ver_0" then
            self.m_oldVersion = false
        end
    end, function ()
        self.m_oldVersion = true
    end)

    if self.ccbnode ~= nil then
        local layer = tolua.cast(self.ccbnode,"cc.Layer")
        if nil ~= GoldExchangeRandIcon["m_timeLabel"] then
            self.m_timeLabel = tolua.cast(GoldExchangeRandIcon["m_timeLabel"],"cc.Label")
        end
        if nil ~= GoldExchangeRandIcon["m_ani1"] then
            self.m_ani1Layer = tolua.cast(GoldExchangeRandIcon["m_ani1"],"cc.LayerColor")
        end
        if nil ~= GoldExchangeRandIcon["m_ani2"] then
            self.m_ani2Layer = tolua.cast(GoldExchangeRandIcon["m_ani2"],"cc.LayerColor")
        end
        if nil ~= GoldExchangeRandIcon["m_ani3"] then
            self.m_ani3Layer = tolua.cast(GoldExchangeRandIcon["m_ani3"],"cc.LayerColor")
        end
        if nil ~= GoldExchangeRandIcon["m_iconbg"] then
            self.m_iconbg = tolua.cast(GoldExchangeRandIcon["m_iconbg"],"cc.Sprite")
        end
        -- self:initParticale()
        if nil ~= self.parentNode then
            self.parentNode:addChild(self)
            self:addChild(self.ccbnode)
        end

        if nil ~= self.m_timeLabel then
            local titleStr = string.format(LuaController:getLang("79022079"))
                self.m_timeLabel:setString(titleStr)
        end


        --print "-----414----"
        local function scheduleBack(  )
            --print "_____GoldExchangeRandIcon:scheduleBack"
        end



         local function eventHandler( eventType )
            if eventType == "enter" then
           elseif eventType == "exit" then

            elseif eventType == "cleanup" then
                --print "GoldExchangeRandIcon cleanup"
                self.ccbnode:unregisterScriptHandler()
            end
        end
        self.ccbnode:registerScriptHandler(eventHandler)
    end
end
function GoldExchangeRandIcon:setData(params)
    local paramsStr = string.format(params)
    --print("params:" .. paramsStr)
    self.data = {}
    local index = 1
    local startI = 1
    local fIndex = string.find(paramsStr,",",startI)
    local tmpValue = "" 
    while (true) do
        tmpValue = string.sub(paramsStr,startI,fIndex-1)
        --print("params" .. string.format(index) .. ":" .. tmpValue)
        self.data[index] = tmpValue
        index = index + 1
        startI = fIndex + 1
        fIndex = string.find(paramsStr,",",startI)
        if (fIndex == nil) then
            tmpValue = string.sub(paramsStr,startI,string.len(paramsStr))
            --print("params" .. string.format(index) .. ":" .. tmpValue)
            self.data[index] = tmpValue
            break
        end
    end
end
function GoldExchangeRandIcon:removeAllEvent()
    -- releaseLuaResource(self.rootPath .. "/resources/".. self.data[19] .."icon")
    if self.m_timeLabel ~= nil then
        self.m_timeLabel:stopAllActions()
    end
    if nil ~= self.m_entryId then
        self.ccbnode:getScheduler():unscheduleScriptEntry(self.m_entryId)
        self.m_entryId = nil
    end
end

function GoldExchangeRandIcon:getCCBI()
    local actName = string.format(self.data[19])
    return "ccbi/GoldExchangeRandLuaIcon.ccbi"
end

function GoldExchangeRandIcon:initParticale()

end
