function loadLuaResource(path)
	if (nil ~=path) then
		local subPath = path:match("(.*/)")
		local pathToAdd = subPath .. "../font/"
		cc.FileUtils:getInstance():addSearchPath(pathToAdd)
		if ( cc.FileUtils:getInstance():isFileExist(path) ) then
			cc.SpriteFrameCache:getInstance():addSpriteFrames(path)
		end
    end
end
function releaseLuaResource(path)
	if(nil ~= path) then
		local plistPath = path .. ".plist"
		print ("release plist: " .. plistPath)
		cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plistPath)
		local texturePath = path .. ".pvr.ccz"
		local texture  = cc.Director:getInstance():getTextureCache():getTextureForKey(texturePath)
        if(nil ~= texture) then
        	print ("release texture" .. texturePath)
            cc.Director:getInstance():getTextureCache():removeTextureForKey(texturePath)
        end
	end
end
function loadCommonResource(index,isLoad)
	LuaController:doResourceByCommonIndex(index,isLoad)
end

-- lua 字符串分割函数  
-------------------------------------------------------  
-- 参数:待分割的字符串,分割字符  
-- 返回:子串表.(含有空串)  
function lua_string_split(str, split_char)      
	 local sub_str_tab = {};  
	   
	 while (true) do          
		 local pos = string.find(str, split_char);    
		 if (not pos) then              
			  local size_t = table.getn(sub_str_tab)  
			  table.insert(sub_str_tab,size_t+1,str);  
			  break;    
		 end  
		   
		 local sub_str = string.sub(str, 1, pos - 1);                
		 local size_t = table.getn(sub_str_tab)  
		 table.insert(sub_str_tab,size_t+1,sub_str);  
		 local t = string.len(str);  
		 str = string.sub(str, pos + 1, t);     
	 end      
	 return sub_str_tab;  
end  