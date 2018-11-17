function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

print(" main script Script xx aa");

Test = Test or {}

collectgarbage("setpause", 100) 
collectgarbage("setstepmul", 5000)

function addPackagePath(path)
	local strPath = string.format(path)
	local packagePath = string.format(package.path)
	packagePath = strPath .. "?.lua;" .. packagePath
	package.path = packagePath
	print("XXXXXXXX "..packagePath)
end
function showGoldRandView(path,params)
    print(">>>> show GOLD XX  AA")
	require("lua_package.GoldExchangeRandView")
	local view = LuaController:getInstance():getSaleViewContainer()
	if nil ~= view then
		Test["goldRandView"] = GoldExchangeRandView:create(view,path,params)
	end
end
function refreshRandView(path,params)
	require("lua_package.GoldExchangeRandView")
	if nil ~= Test["goldRandView"] then
		local view = LuaController:getInstance():getSaleViewContainer()
		if nil ~= view then
			if nil == Test["goldRandView"] then
				Test["goldRandView"] = GoldExchangeRandView:create(view,path,params)
			else
				Test["goldRandView"]:setData(view,path,params)
				Test["goldRandView"]:refreshBtn()
			end
		end
	end
end
function showGoldExchangeView(path,params,swallow)
	require("GoldExchangeView")
	local view = LuaController:getInstance():getSaleViewContainer()
	if nil ~= view then
		GoldExchangeView:create(view,path,params,swallow)
	end
end
function createGoldExchangeAdvCell(path,params)
	local view = LuaController:getInstance():getAdvCellContainer()
	if nil ~= view then
		require("GoldExchangeAdvCell")
		GoldExchangeAdvCell:create(view,path,params)
	end
end
function createGoldExchangeAdvCell1(path,params)
	local view = LuaController:getInstance():getAdvCellContainer()
	if nil ~= view then
		require("GoldExchangeAdvCell")
		local node = GoldExchangeAdvCell:create(view,path,params)
		return node:getCostBtnRect()
	end
	return 0,0,0,0
end
function updateGoldExchangeAdvCell(params)
	local cell = LuaController:getInstance():getAdvCell()
	if nil ~= cell then
		cell:setData(params)
	end
end
function createGoldExchangeIcon(path,params)
	local view = LuaController:getInstance():getIconContainer()
	if nil ~= view then
		require("GoldExchangeIcon")
		GoldExchangeIcon:create(view,path,params)
	end
end
function createExchangeRandIcon(path,params)
	local view = LuaController:getInstance():getIconContainer()
	if nil ~= view then
		require("lua_package.GoldExchangeRandIcon")
		GoldExchangeRandIcon:create(view,path,params)
	end
end
function addChatNotice(params,path,time)
	print ("step _____ 0")
	local view = LuaController:getInstance():getChatNoticeContainer()
	if nil ~= view then
		print ("step _____ 1")
		require("ChatNoticeView")
		local node = ChatNoticeView:create(view,path,params,time,false)
		ChatNoticeView:create(view,path,params,time,true)
		return node:getTime()
	end
	return 0
end

function createActivityAdCell( path, params )
	require("ActivityAdCell")
	return ActivityAdCell:create(path, params)
end

function createActivityListCellSprite( path, params )
	require("ActivityListCellSprite")
	return ActivityListCellSprite:create(path, params)
end
