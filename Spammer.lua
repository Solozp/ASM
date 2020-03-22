local eventFrame = CreateFrame("Frame");
eventFrame:RegisterEvent("VARIABLES_LOADED");
function eventFrame:OnEvent(event, ...)
	if event == "VARIABLES_LOADED" then
		if SpammerDB ~= nil then
			if SpammerDB["delay"] ~= nil then spamwaittime:SetText(SpammerDB.delay); end
			if SpammerDB["channel"] ~= nil then spamchannel:SetText(SpammerDB.channel); end
			if SpammerDB["line1"] ~= nil then spamtext1:SetText(SpammerDB.line1); end
			if SpammerDB["line2"] ~= nil then spamtext2:SetText(SpammerDB.line2); end
			if SpammerDB["line3"] ~= nil then spamtext3:SetText(SpammerDB.line3); end			
		end
	end
end			
eventFrame:SetScript("OnEvent", eventFrame.OnEvent);

function Spammer_OnLoad()
	ChatEdit_InsertLink_old=ChatEdit_InsertLink;
	ChatEdit_InsertLink=GetLink;
	Spammer:SetScale(0.7);
end

function SaveDB()
	SpammerDB = { };
	SpammerDB["delay"] = spamwaittime:GetText();
	SpammerDB["channel"] = spamchannel:GetText();
	SpammerDB["line1"] = spamtext1:GetText();
	SpammerDB["line2"] = spamtext2:GetText();
	SpammerDB["line3"] = spamtext3:GetText();			
	ChatFrame1:AddMessage("|cff404040Spammer|r:\124cffFF4500 данные сохранены")
end

function LoadDB()
	spamwaittime:SetText(SpammerDB.delay);
	spamchannel:SetText(SpammerDB.channel);
	spamtext1:SetText(SpammerDB.line1);
	spamtext2:SetText(SpammerDB.line2);
	spamtext3:SetText(SpammerDB.line3);
	ChatFrame1:AddMessage("|cff404040Spammer|r:\124cffFF4500 данные загружены")
end

function Clear()
	spamtext1:SetText("");
	spamtext2:SetText("");
	spamtext3:SetText("");
end

function SpammerToggle()
	if ( Spammer:IsVisible() ) then
		HideUIPanel(Spammer);
	else
		ShowUIPanel(Spammer);
	end
end    

SlashCmdList["SpammerMENUT"] = SpammerToggle;
SLASH_SpammerMENUT1 = "/Spam";
SLASH_SpammerMENUT2 = "/ts";
SLASH_SpammerMENUT3 = "/sp";

function Spartaftw()
	PlaySoundFile("Interface\\AddOns\\Spammer\\This is Sparta.mp3")
end

AutospammerON=0
function timerbot_callback()
	if AutospammerON==1 then
		autospamwithtime_callback()
	end
end

function AutomsgspammerON()
	if AutospammerON==0 then
		AutospammerON=1
		ChatFrame1:AddMessage("|cff404040Spammer|r:\124cffFF4500 запущен")			
	else 
		ChatFrame1:AddMessage("|cff404040Spammer|r:\124cffFF4500 уже работает")    
	end
end

function AutomsgspammerOFF()
	if AutospammerON==1 then
		AutospammerON=0
		ChatFrame1:AddMessage("|cff404040Spammer|r:\124cffFF4500 остановлен")
		autospamwithtimestop();
	end
end

function autospamwithtimestop()
	rrecounter = 0
end    

timestampautospam = time();
rrecounter = 0

function autospamwithtimestop()
	rrecounter = 0
end

function GetLink(lnk)
	if spamtext1:HasFocus() then
		spamtext1:Insert(lnk);
	elseif spamtext2:HasFocus() then
		spamtext2:Insert(lnk);
	elseif spamtext3:HasFocus() then
		spamtext3:Insert(lnk);
	else
		ChatEdit_InsertLink_old(lnk);
	end
end

function autospamwithtime_callback()
	autopamwaittime = spamwaittime:GetNumber();
	currentautospam_time = time();
	if (currentautospam_time - timestampautospam > (autopamwaittime))  then
			if spamchannel:GetNumber()>0 and spamchannel:GetNumber()<10 then
				cht = "CHANNEL";
				chd = spamchannel:GetNumber()
			elseif spamchannel:GetText() == "г"	then
				cht = "GUILD"
			elseif spamchannel:GetText() == "к"	then
				cht = "YELL"
			else cht = nil
			end	
		SendChatMessage(spamtext1:GetText(), cht, GetDefaultLanguage("Player"), chd)
		SendChatMessage(spamtext2:GetText(), cht, GetDefaultLanguage("Player"), chd)
		SendChatMessage(spamtext3:GetText(), cht, GetDefaultLanguage("Player"), chd)
		timestampautospam = currentautospam_time;
		rrecounter = rrecounter+1
	end
end