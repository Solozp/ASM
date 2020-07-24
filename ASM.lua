local ASMFrame = CreateFrame("Frame");
ASMFrame:RegisterEvent("ADDON_LOADED");
ASMFrame:RegisterEvent("VARIABLES_LOADED");
ASMFrame:RegisterEvent("CHAT_MSG_ADDON");

function ASMFrame:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		ASM:RegisterForDrag("LeftButton");
		if ... == "ASM" then
			ChatEdit_InsertLink_old=ChatEdit_InsertLink;
			ChatEdit_InsertLink=GetLink;
			local channels = { GetChannelList(); };
		end
	elseif event == "VARIABLES_LOADED" then
		if ASMDB ~= nil then
			if ASMDB.delay ~= nil then waittime:SetText(ASMDB.delay); end
			if ASMDB.channel ~= nil then channel:SetText(ASMDB.channel); end
			if ASMDB.line1 ~= nil then text1:SetText(ASMDB.line1); end
			if ASMDB.line2 ~= nil then text2:SetText(ASMDB.line2); end
			if ASMDB.line3 ~= nil then text3:SetText(ASMDB.line3); end			
		end
		LangDropDownLabel = "язык";
	elseif event == "CHAT_MSG_ADDON" then
		s_prefix,  s_text,  s_channel, s_sender = ...; 
		if s_prefix == "ASM" then
			sender = s_sender;
			tm = tonumber(s_text);
			stk = time();
		end
	end
end
ASMFrame:SetScript("OnEvent", ASMFrame.OnEvent);

function spmr_list(s, t)
	if not s == UnitName("player") then
		i = tonumber(string.match(MSG:GetText(), "%d+"))
		if  (i == nil) then
			MSG:SetText("Отправляет "..s..":"..(1).."/"..t)
		elseif 	(i < t) then
			MSG:SetText("Отправляет "..s..":"..(i+1).."/"..t)
		else MSG:SetText("Последним отправлял "..s)
			stk = ""				
		end
	end
end

function SaveDB()
	ASMDB = { };
	ASMDB.delay = waittime:GetText();
	ASMDB.channel = channel:GetText();
	ASMDB.line1 = text1:GetText();
	ASMDB.line2 = text2:GetText();
	ASMDB.line3 = text3:GetText();			
	ChatFrame1:AddMessage("|cff404040ASM|r:\124cffFF4500 данные сохранены")
end

function LoadDB()
	waittime:SetText(ASMDB.delay);
	channel:SetText(ASMDB.channel);
	text1:SetText(ASMDB.line1);
	text2:SetText(ASMDB.line2);
	text3:SetText(ASMDB.line3);
	ChatFrame1:AddMessage("|cff404040ASM|r:\124cffFF4500 данные загружены")
end

function Clear()
	text1:SetText("");
	text2:SetText("");
	text3:SetText("");
end

function ASMToggle()
	if ASM:IsVisible() then
		HideUIPanel(ASM);
	else
		ShowUIPanel(ASM);
	end
end    

SlashCmdList["ASMMENU"] = ASMToggle;
SLASH_ASMMENU1 = "/asm";

function Spartaftw()
	PlaySoundFile("Interface\\AddOns\\ASM\\This is Sparta.mp3")
end

local asm_breaker = 0
function timerbot_callback()
	if asm_breaker == 1 then
		asm_withtime_callback()
	end
	if type(stk) == "number" then
		c_time = time();
		sl_t = (c_time - stk)
		if sl_t == 1 then
			stk = c_time
			spmr_list(sender, tm)			
		end
	end
end

function ASM_ON()
	if asm_breaker == 0 then
		asm_breaker = 1
		ChatFrame1:AddMessage("|cff404040ASM|r:\124cffFF4500 запущен")
		ASMButtonStart:SetText("Работает")
		ASMButtonStop:SetText("Стоп")
	else 
		ChatFrame1:AddMessage("|cff404040ASM|r:\124cffFF4500 уже работает")    
	end
end

function ASM_OFF()
	if asm_breaker == 1 then
		asm_breaker = 0
		ChatFrame1:AddMessage("|cff404040ASM|r:\124cffFF4500 остановлен")
		ASMButtonStart:SetText("Пуск!")
		ASMButtonStop:SetText("Остановлен")
	end
end

timestamp_asm = time();

function GetLink(lnk)
	if text1:HasFocus() then
		text1:Insert(lnk);
	elseif text2:HasFocus() then
		text2:Insert(lnk);
	elseif text3:HasFocus() then
		text3:Insert(lnk);
	else
		ChatEdit_InsertLink_old(lnk);
	end
end

local lng = GetDefaultLanguage("Player");

function asm_withtime_callback()
	asm_withtime = waittime:GetNumber();
	current_asm_time = time();
	if (current_asm_time - timestamp_asm > asm_withtime)  then
			if channel:GetNumber()>0 and channel:GetNumber()<10 then
				cht = "CHANNEL";
				chd = channel:GetNumber()
			elseif channel:GetText() == "г"	then
				cht = "GUILD"
			elseif channel:GetText() == "к"	then
				cht = "YELL"
			else cht = nil
			end	
		SendChatMessage(text1:GetText(), cht, lng, chd)
		SendChatMessage(text2:GetText(), cht, lng, chd)
		SendChatMessage(text3:GetText(), cht, lng, chd)		
		timestamp_asm = current_asm_time;
		SendAddonMessage("ASM", waittime:GetNumber(), "GUILD")
	end
end

function Channels()								-- автовыбора канала
	local channels = { GetChannelList(); }
	local channels_user = {};
	local iter = 0;
	if Switch:GetChecked(true) then
		for i,title in ipairs(channels) do	
			if i % 2 ~= 0 then
				iter = iter + 1;
				channels_user[iter] = title;				
			else
				if title == "ПоискСпутников" then
					channel:SetText(channels_user[iter]);
				end				
				channels_user[iter] = channels_user[iter] .. ". " .. title;				
			end		
		end
	end
end

function StartASM()
	if  waittime:GetNumber() > 30 then
		Spartaftw();
		ASM_ON();
		Channels();		
	elseif waittime:GetNumber() <= 30 then
		ChatFrame1:AddMessage("|cff404040ASM|r: Ваш персонаж может быть |cffFF4500забанен|r на сутки, при отправка сообщений |cffFF4500чаще 1го раза в 30 секунд|r. Установите интервал |cff00FF00более 30 секунд")
	end
end