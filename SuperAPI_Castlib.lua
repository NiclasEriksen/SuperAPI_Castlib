SUPERAPI_SpellEvents = {}

-- catch all nameplates
local frames
local initialized = 0
local parentcount = 0

local sparkToggle = false

local barWidth = 98
local barHeight = 9
local barOffsetX = 0
local barOffsetY = 0
local barAnchor = "TOP"
local barAnchorParent = "BOTTOM"
local barTexture = "Interface\\AddOns\\SuperAPI_Castlib\\t\\bar.tga"
local barFont = "GameFontWhite"
local barFontSize = 10
local textOffsetX = 0
local textOffsetY = 0
local textAnchor = "CENTER"

local iconWidth = 20
local iconHeight = 20
local iconOffsetX = -4
local iconOffsetY = 0
local iconAnchor = "BOTTOMRIGHT"
local iconAnchorParent = "BOTTOMLEFT"

local testMode = false

function SuperAPI_Castlib_ApplySettings()
	if not SuperAPI_Castlib_Settings then return end
	local s = SuperAPI_Castlib_Settings
	barWidth = s.barWidth
	barHeight = s.barHeight
	barOffsetX = s.barOffsetX
	barOffsetY = s.barOffsetY
	barAnchor = s.barAnchor
	barAnchorParent = s.barAnchorParent
	iconWidth = s.iconSize
	iconHeight = s.iconSize
	iconOffsetX = s.iconOffsetX
	iconOffsetY = s.iconOffsetY
	iconAnchor = s.iconAnchor
	iconAnchorParent = s.iconAnchorParent
	sparkToggle = s.showSpark
	barFont = s.barFont or "GameFontWhite"
	barFontSize = s.barFontSize or 10
	textOffsetX = s.textOffsetX or 0
	textOffsetY = s.textOffsetY or 0
	textAnchor = s.textAnchor or "CENTER"

	-- Update existing nameplate bars if any
	if frames then
		for _, plate in ipairs(frames) do
			if plate and plate.castbar then
				plate.castbar:SetWidth(barWidth)
				plate.castbar:SetHeight(barHeight)
				plate.castbar:ClearAllPoints()
				plate.castbar:SetPoint(barAnchor, plate, barAnchorParent, barOffsetX, barOffsetY)
				if sparkToggle then
					if plate.castbar.spark == nil then
						plate.castbar.spark = plate.castbar:CreateTexture(nil, "OVERLAY")
						plate.castbar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
						plate.castbar.spark:SetWidth(32)
						plate.castbar.spark:SetHeight(10)
						plate.castbar.spark:SetBlendMode("ADD")
					end
					plate.castbar.spark:Show()
				elseif plate.castbar.spark then
					plate.castbar.spark:Hide()
				end
				if plate.castbar.icon then
					plate.castbar.icon:SetWidth(iconWidth)
					plate.castbar.icon:SetHeight(iconHeight)
					plate.castbar.icon:ClearAllPoints()
					plate.castbar.icon:SetPoint(iconAnchor, plate.castbar, iconAnchorParent, iconOffsetX, iconOffsetY)
				end
				if plate.castbar.text then
					plate.castbar.text:ClearAllPoints()
					plate.castbar.text:SetPoint(textAnchor, plate.castbar, textAnchor, textOffsetX, textOffsetY)
					if barFont == "GameFontWhite" then
						plate.castbar.text:SetFont("Fonts\\FRIZQT__.TTF", barFontSize, "THINOUTLINE")
					else
						plate.castbar.text:SetFont(barFont, barFontSize, "THINOUTLINE")
					end
				end
				
				-- Apply colors to active bar if it matches an event
				local unitGUID = plate:GetName(1)
				local unitCastInfo = SUPERAPI_SpellEvents[unitGUID]
				if testMode then
					plate.castbar:SetStatusBarColor(s.colorStart.r, s.colorStart.g, s.colorStart.b)
				elseif unitCastInfo then
					if unitCastInfo.event == "START" then
						plate.castbar:SetStatusBarColor(s.colorStart.r, s.colorStart.g, s.colorStart.b)
					elseif unitCastInfo.event == "CAST" then
						plate.castbar:SetStatusBarColor(s.colorSuccess.r, s.colorSuccess.g, s.colorSuccess.b)
					elseif unitCastInfo.event == "FAIL" then
						plate.castbar:SetStatusBarColor(s.colorFail.r, s.colorFail.g, s.colorFail.b)
					elseif unitCastInfo.event == "CHANNEL" then
						plate.castbar:SetStatusBarColor(s.colorChannel.r, s.colorChannel.g, s.colorChannel.b)
					end
				end
			end
		end
	end
end

function SuperAPI_Castlib_Load()
	-- if client was not launched with the mod, shutdown
	if not SetAutoloot then
		this:SetScript("OnUpdate", nil)
		return
	end

	this:RegisterEvent("UNIT_CASTEVENT")
	this:SetScript("OnEvent", SuperAPI_Castlib_OnEvent)
end

function SuperAPI_Castlib_Update(elapsed)
	SuperAPI_SpellCastsUpdate(elapsed)
	SuperAPI_NameplateUpdateAll(elapsed)
end

function SuperAPI_Castlib_OnEvent()
	if (event == "UNIT_CASTEVENT") then
		--		if UnitIsUnit(arg1, "player") then return end
		if arg3 == "MAINHAND" or arg3 == "OFFHAND" then
			return
		end
		if arg3 == "CAST" then
			local currentCastInfo = SUPERAPI_SpellEvents[arg1]
			if not currentCastInfo or arg4 ~= currentCastInfo.spell then
				return
			end
		end
		arg5 = arg5 / 1000
		SUPERAPI_SpellEvents[arg1] = nil
		SUPERAPI_SpellEvents[arg1] = { target = arg2, spell = arg4, event = arg3, timer = arg5, start = GetTime() }

		if not SuperAPI_nameplatebars then
			SuperAPI_nameplatebars = true
		end
		-- If you want to disable this module's nameplate castbars, type in chat
		-- "   /run SuperAPI_nameplatebars = false  "
	end
end

function SuperAPI_SpellCastsUpdate(elapsed)
	for unit, castinfo in pairs(SUPERAPI_SpellEvents) do
		if castinfo.start + castinfo.timer + 1.5 < GetTime() then
			SUPERAPI_SpellEvents[unit] = nil
		elseif (castinfo.event == "CAST" or castinfo.event == "FAIL") and castinfo.start + castinfo.timer + 1 < GetTime() then
			SUPERAPI_SpellEvents[unit] = nil
		end
	end
end

function SuperAPI_NameplateCastbarInitialize(plate)
	plate.castbar = CreateFrame("StatusBar", "castbar", plate)
	plate.castbar:SetWidth(barWidth)
	plate.castbar:SetHeight(barHeight)
	plate.castbar:ClearAllPoints()
	plate.castbar:SetPoint(barAnchor, plate, barAnchorParent, barOffsetX, barOffsetY)
	plate.castbar:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	                            insets = { left = -1, right = -1, top = -1, bottom = -1 } })
	plate.castbar:SetBackdropColor(0, 0, 0, 1)
	plate.castbar:SetStatusBarTexture(barTexture)

	if plate.castbar.spark == nil then
		plate.castbar.spark = plate.castbar:CreateTexture(nil, "OVERLAY")
		plate.castbar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		plate.castbar.spark:SetWidth(32)
		plate.castbar.spark:SetHeight(10)
		plate.castbar.spark:SetBlendMode("ADD")
	end

	if sparkToggle then
		plate.castbar.spark:Show()
	else
		plate.castbar.spark:Hide()
	end

	if plate.castbar.text == nil then
		plate.castbar.text = plate.castbar:CreateFontString(nil, "HIGH", "GameFontHighlightSmall")
		plate.castbar.text:ClearAllPoints()
		plate.castbar.text:SetPoint(textAnchor, plate.castbar, textAnchor, textOffsetX, textOffsetY)
		if barFont == "GameFontWhite" then
			plate.castbar.text:SetFont("Fonts\\FRIZQT__.TTF", barFontSize, "THINOUTLINE")
		else
			plate.castbar.text:SetFont(barFont, barFontSize, "THINOUTLINE")
		end
	end

	if plate.castbar.icon == nil then
		plate.castbar.icon = plate.castbar:CreateTexture(nil, "BORDER")
		plate.castbar.icon:ClearAllPoints()
		plate.castbar.icon:SetPoint(iconAnchor, plate.castbar, iconAnchorParent, iconOffsetX, iconOffsetY)
		plate.castbar.icon:SetWidth(iconWidth)
		plate.castbar.icon:SetHeight(iconHeight)
		plate.castbar.icon:Show()
	end
end

function SuperAPI_NameplateUpdateFrames()
	parentcount = WorldFrame:GetNumChildren()
	if initialized < parentcount then
		frames = { WorldFrame:GetChildren() }
		initialized = parentcount
	end
end

function SuperAPI_Castlib_SetTestMode(enabled)
	testMode = enabled
	if not enabled and frames then
		for _, plate in ipairs(frames) do
			if plate and plate.castbar then
				plate.castbar:Hide()
			end
		end
	end
end

function SuperAPI_NameplateUpdateAll(elapsed)
	SuperAPI_NameplateUpdateFrames()

	for _, plate in ipairs(frames) do
		if plate then
			if plate:IsShown() and plate:IsObjectType("Button") then
				local unitGUID = plate:GetName(1)
				if plate.castbar == nil then
					SuperAPI_NameplateCastbarInitialize(plate)
				end
				local unitCastInfo = SUPERAPI_SpellEvents[unitGUID]

				if testMode then
					plate.castbar:Show()
					plate.castbar:SetMinMaxValues(0, 100)
					plate.castbar:SetValue(50)
					local s = SuperAPI_Castlib_Settings
					if s then
						plate.castbar:SetStatusBarColor(s.colorStart.r, s.colorStart.g, s.colorStart.b)
					else
						plate.castbar:SetStatusBarColor(1.0, 0.7, 0.0)
					end
					plate.castbar.text:SetText("Test Casting")
					plate.castbar.icon:SetTexture("Interface\\Icons\\Spell_Nature_HealingTouch")
					plate.castbar:SetAlpha(1.0)
					if plate.castbar.spark then
						plate.castbar.spark:SetPoint("CENTER", plate.castbar, "LEFT", plate.castbar:GetWidth() / 2, 0);
					end
				elseif not unitCastInfo or not SuperAPI_nameplatebars then
					plate.castbar:Hide()
				else

					plate.castbar:Show()
					plate.castbar:SetMinMaxValues(unitCastInfo.start, unitCastInfo.start + unitCastInfo.timer)

					plate.castbar:SetValue(GetTime())

					local sparkPosition
					if sparkToggle then
						sparkPosition = min(max(plate.castbar:GetWidth() * (GetTime() - unitCastInfo.start) / unitCastInfo.timer, 0), plate.castbar:GetWidth())
					end

					local spellname, _, spellicon = SpellInfo(unitCastInfo.spell)
					if not spellname then
						spellname = "UNKNOWN SPELL"
					end
					if not spellicon then
						spellicon = "Interface\\Icons\\INV_Misc_QuestionMark"
					end

					plate.castbar.text:SetText(spellname)
					plate.castbar.icon:SetTexture(spellicon)
					plate.castbar:SetAlpha(1 - GetTime() + unitCastInfo.start + unitCastInfo.timer)

					local s = SuperAPI_Castlib_Settings
					if unitCastInfo.event == "START" then
						if s then
							plate.castbar:SetStatusBarColor(s.colorStart.r, s.colorStart.g, s.colorStart.b)
						else
							plate.castbar:SetStatusBarColor(1.0, 0.7, 0.0)
						end
						plate.castbar:SetMinMaxValues(unitCastInfo.start, unitCastInfo.start + unitCastInfo.timer)
					elseif unitCastInfo.event == "CAST" then
						if s then
							plate.castbar:SetStatusBarColor(s.colorSuccess.r, s.colorSuccess.g, s.colorSuccess.b)
						else
							plate.castbar:SetStatusBarColor(0.0, 1.0, 0.0)
						end
						plate.castbar:SetMinMaxValues(unitCastInfo.start - 1, unitCastInfo.start)
					elseif unitCastInfo.event == "FAIL" then
						if s then
							plate.castbar:SetStatusBarColor(s.colorFail.r, s.colorFail.g, s.colorFail.b)
						else
							plate.castbar:SetStatusBarColor(1.0, 0.0, 0.0)
						end
						plate.castbar.text:SetText("INTERRUPTED")
						plate.castbar:SetMinMaxValues(unitCastInfo.start - 1, unitCastInfo.start)
					elseif unitCastInfo.event == "CHANNEL" then
						if s then
							plate.castbar:SetStatusBarColor(s.colorChannel.r, s.colorChannel.g, s.colorChannel.b)
						else
							plate.castbar:SetStatusBarColor(0.5, 0.7, 1.0)
						end
						plate.castbar:SetMinMaxValues(unitCastInfo.start, unitCastInfo.start + unitCastInfo.timer)
						plate.castbar:SetValue(unitCastInfo.start + unitCastInfo.timer - GetTime() + unitCastInfo.start)
						if sparkToggle then
							sparkPosition = min(max(plate.castbar:GetWidth() * (unitCastInfo.start + unitCastInfo.timer - GetTime()) / unitCastInfo.timer, 0), plate.castbar:GetWidth())
						end
						plate.castbar:SetAlpha(1 + unitCastInfo.start + unitCastInfo.timer - GetTime())
					end
					if sparkToggle then
						plate.castbar.spark:SetPoint("CENTER", plate.castbar, "LEFT", sparkPosition, 0);
					end
				end
			end
		end
	end
end

function NameplateInterruptCast(unitGUID, spellname, spellicon)
	SuperAPI_NameplateUpdateFrames()
	for i, plate in ipairs(frames) do
		if plate then
			if plate:IsShown() and plate:IsObjectType("Button") then
				if plate:GetName(1) == unitGUID then
					if plate.castbar == nil then
						SuperAPI_NameplateCastbarInitialize(plate)
					end
					plate.castbar:Show()
					local s = SuperAPI_Castlib_Settings
					if s then
						plate.castbar:SetStatusBarColor(s.colorFail.r, s.colorFail.g, s.colorFail.b)
					else
						plate.castbar:SetStatusBarColor(1.0, 0.0, 0.0)
					end
					plate.castbar:SetMinMaxValues(0, 1)
					plate.castbar:SetValue(1)
					plate.castbar:SetValue(GetTime())
					plate.castbar.text:SetText("INTERRUPTED")
					plate.castbar.icon:SetTexture(spellicon)
				end
			end
		end
	end
end

function NameplateCastbarEnd(this)
	this:SetValue(0)
	this:SetMinMaxValues(0, 1)
	this.text:SetText(" ")
	this.icon:SetTexture(nil)
	this:Hide()
end
