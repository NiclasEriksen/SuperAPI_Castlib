SLASH_CASTLIB1 = "/castlib"
SlashCmdList["CASTLIB"] = function(msg)
    if SuperAPI_Castlib_UI:IsShown() then
        SuperAPI_Castlib_UI:Hide()
    else
        SuperAPI_Castlib_UI:Show()
    end
end

local anchors = {
    "TOP", "BOTTOM", "LEFT", "RIGHT", "CENTER",
    "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"
}

local fonts = {
    ["Default"] = "GameFontWhite",
    ["Francois"] = "Interface\\AddOns\\SuperAPI_Castlib\\f\\francois.ttf",
    ["Yanone"] = "Interface\\AddOns\\SuperAPI_Castlib\\f\\yanone.ttf"
}

function SuperAPI_Castlib_AnchorDropDown_Initialize()
    local info = {}
    local selectedValue = UIDropDownMenu_GetSelectedValue(this)
    for _, anchor in ipairs(anchors) do
        info.text = anchor
        info.value = anchor
        info.func = SuperAPI_Castlib_AnchorDropDown_OnClick
        info.checked = (anchor == selectedValue)
        UIDropDownMenu_AddButton(info)
    end
end

function SuperAPI_Castlib_FontDropDown_Initialize()
    local info = {}
    local selectedValue = UIDropDownMenu_GetSelectedValue(this)
    -- We want a specific order: Default, Francois, Yanone
    local fontNames = {"Default", "Francois", "Yanone"}
    for _, name in ipairs(fontNames) do
        info.text = name
        info.value = fonts[name]
        info.func = SuperAPI_Castlib_FontDropDown_OnClick
        info.checked = (info.value == selectedValue)
        UIDropDownMenu_AddButton(info)
    end
end

function SuperAPI_Castlib_AnchorDropDown_OnClick()
    UIDropDownMenu_SetSelectedValue(getglobal(UIDROPDOWNMENU_OPEN_MENU), this.value)
    UIDropDownMenu_SetText(this.value, getglobal(UIDROPDOWNMENU_OPEN_MENU))
end

function SuperAPI_Castlib_FontDropDown_OnClick()
    UIDropDownMenu_SetSelectedValue(getglobal(UIDROPDOWNMENU_OPEN_MENU), this.value)
    UIDropDownMenu_SetText(this:GetText(), getglobal(UIDROPDOWNMENU_OPEN_MENU))
end

function SuperAPI_Castlib_LoadSettings()
    if not SuperAPI_Castlib_Settings then
        SuperAPI_Castlib_Settings = {
            barWidth = 98,
            barHeight = 9,
            barOffsetX = 0,
            barOffsetY = 0,
            iconOffsetX = -4,
            iconOffsetY = 0,
            iconSize = 20,
            barAnchor = "TOP",
            barAnchorParent = "BOTTOM",
            iconAnchor = "BOTTOMRIGHT",
            iconAnchorParent = "BOTTOMLEFT",
            showSpark = false,
            barFont = "GameFontWhite",
            barFontSize = 10,
            textOffsetX = 0,
            textOffsetY = 0,
            textAnchor = "CENTER",
            colorStart = { r = 1.0, g = 0.7, b = 0.0 },
            colorSuccess = { r = 0.0, g = 1.0, b = 0.0 },
            colorFail = { r = 1.0, g = 0.0, b = 0.0 },
            colorChannel = { r = 0.5, g = 0.7, b = 1.0 },
        }
    end

    local s = SuperAPI_Castlib_Settings
    if not s.barFont then s.barFont = "GameFontWhite" end
    if not s.barFontSize then s.barFontSize = 10 end
    if not s.textOffsetX then s.textOffsetX = 0 end
    if not s.textOffsetY then s.textOffsetY = 0 end
    if not s.textAnchor then s.textAnchor = "CENTER" end
    if not s.colorStart then s.colorStart = { r = 1.0, g = 0.7, b = 0.0 } end
    if not s.colorSuccess then s.colorSuccess = { r = 0.0, g = 1.0, b = 0.0 } end
    if not s.colorFail then s.colorFail = { r = 1.0, g = 0.0, b = 0.0 } end
    if not s.colorChannel then s.colorChannel = { r = 0.5, g = 0.7, b = 1.0 } end

    SuperAPI_Castlib_UIBarHorizontalInput:SetText(tostring(s.barOffsetX))
    SuperAPI_Castlib_UIBarVerticalInput:SetText(tostring(s.barOffsetY))
    SuperAPI_Castlib_UIBarWidthInput:SetText(tostring(s.barWidth))
    SuperAPI_Castlib_UIBarHeightInput:SetText(tostring(s.barHeight))
    SuperAPI_Castlib_UIIconHorizontalInput:SetText(tostring(s.iconOffsetX))
    SuperAPI_Castlib_UIIconVerticalInput:SetText(tostring(s.iconOffsetY))
    SuperAPI_Castlib_UIIconSizeInput:SetText(tostring(s.iconSize))
    SuperAPI_Castlib_UIFontSizeInput:SetText(tostring(s.barFontSize))
    SuperAPI_Castlib_UITextHorizontalInput:SetText(tostring(s.textOffsetX))
    SuperAPI_Castlib_UITextVerticalInput:SetText(tostring(s.textOffsetY))
    
    if s.showSpark then
        SuperAPI_Castlib_UIShowSparkCheckbox:SetChecked(1)
    else
        SuperAPI_Castlib_UIShowSparkCheckbox:SetChecked(0)
    end

    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UIBarAnchorDropDown, s.barAnchor)
    UIDropDownMenu_SetText(s.barAnchor, SuperAPI_Castlib_UIBarAnchorDropDown)

    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UIBarAnchorParentDropDown, s.barAnchorParent)
    UIDropDownMenu_SetText(s.barAnchorParent, SuperAPI_Castlib_UIBarAnchorParentDropDown)

    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UIIconAnchorDropDown, s.iconAnchor)
    UIDropDownMenu_SetText(s.iconAnchor, SuperAPI_Castlib_UIIconAnchorDropDown)

    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UIIconAnchorParentDropDown, s.iconAnchorParent)
    UIDropDownMenu_SetText(s.iconAnchorParent, SuperAPI_Castlib_UIIconAnchorParentDropDown)
    
    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UITextAnchorDropDown, s.textAnchor)
    UIDropDownMenu_SetText(s.textAnchor, SuperAPI_Castlib_UITextAnchorDropDown)
    
    local fontName = "Default"
    for name, path in pairs(fonts) do
        if path == s.barFont then
            fontName = name
            break
        end
    end
    UIDropDownMenu_SetSelectedValue(SuperAPI_Castlib_UIFontDropDown, s.barFont)
    UIDropDownMenu_SetText(fontName, SuperAPI_Castlib_UIFontDropDown)

    -- Set Color Swatches
    SuperAPI_Castlib_UIColorStartSwatchBG:SetVertexColor(s.colorStart.r, s.colorStart.g, s.colorStart.b)
    SuperAPI_Castlib_UIColorSuccessSwatchBG:SetVertexColor(s.colorSuccess.r, s.colorSuccess.g, s.colorSuccess.b)
    SuperAPI_Castlib_UIColorFailSwatchBG:SetVertexColor(s.colorFail.r, s.colorFail.g, s.colorFail.b)
    SuperAPI_Castlib_UIColorChannelSwatchBG:SetVertexColor(s.colorChannel.r, s.colorChannel.g, s.colorChannel.b)

    -- Apply to the actual bar variables in SuperAPI_Castlib.lua
    SuperAPI_Castlib_ApplySettings()
end

local testModeActive = false

function SuperAPI_Castlib_SaveSettings()
    local s = SuperAPI_Castlib_Settings
    s.barOffsetX = tonumber(SuperAPI_Castlib_UIBarHorizontalInput:GetText()) or 0
    s.barOffsetY = tonumber(SuperAPI_Castlib_UIBarVerticalInput:GetText()) or 0
    s.barWidth = tonumber(SuperAPI_Castlib_UIBarWidthInput:GetText()) or 98
    s.barHeight = tonumber(SuperAPI_Castlib_UIBarHeightInput:GetText()) or 9
    s.iconOffsetX = tonumber(SuperAPI_Castlib_UIIconHorizontalInput:GetText()) or -4
    s.iconOffsetY = tonumber(SuperAPI_Castlib_UIIconVerticalInput:GetText()) or 0
    s.iconSize = tonumber(SuperAPI_Castlib_UIIconSizeInput:GetText()) or 20
    s.barFontSize = tonumber(SuperAPI_Castlib_UIFontSizeInput:GetText()) or 10
    s.textOffsetX = tonumber(SuperAPI_Castlib_UITextHorizontalInput:GetText()) or 0
    s.textOffsetY = tonumber(SuperAPI_Castlib_UITextVerticalInput:GetText()) or 0
    s.showSpark = SuperAPI_Castlib_UIShowSparkCheckbox:GetChecked() == 1
    
    s.barAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIBarAnchorDropDown) or "TOP"
    s.barAnchorParent = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIBarAnchorParentDropDown) or "BOTTOM"
    s.iconAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIIconAnchorDropDown) or "BOTTOMRIGHT"
    s.iconAnchorParent = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIIconAnchorParentDropDown) or "BOTTOMLEFT"
    s.textAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UITextAnchorDropDown) or "CENTER"
    s.barFont = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIFontDropDown) or "GameFontWhite"

    SuperAPI_Castlib_ApplySettings()
end

function SuperAPI_Castlib_CancelSettings()
    if testModeActive then
        SuperAPI_Castlib_TestSettings() -- Stop testing
    end
    SuperAPI_Castlib_LoadSettings() -- Restore UI to saved values
    SuperAPI_Castlib_UI:Hide()
end

function SuperAPI_Castlib_TestSettings()
    if testModeActive then
        testModeActive = false
        SuperAPI_Castlib_SetTestMode(false)
        SuperAPI_Castlib_UITestButton:SetText("Test")
    else
        testModeActive = true
        
        -- Temporarily apply UI values
        local oldSettings = {}
        if SuperAPI_Castlib_Settings then
            for k, v in pairs(SuperAPI_Castlib_Settings) do 
                if type(v) == "table" then
                    oldSettings[k] = {}
                    for k2, v2 in pairs(v) do oldSettings[k][k2] = v2 end
                else
                    oldSettings[k] = v 
                end
            end
        else
            -- If for some reason settings don't exist yet
            SuperAPI_Castlib_LoadSettings()
            for k, v in pairs(SuperAPI_Castlib_Settings) do 
                if type(v) == "table" then
                    oldSettings[k] = {}
                    for k2, v2 in pairs(v) do oldSettings[k][k2] = v2 end
                else
                    oldSettings[k] = v 
                end
            end
        end
        
        SuperAPI_Castlib_Settings.barOffsetX = tonumber(SuperAPI_Castlib_UIBarHorizontalInput:GetText()) or 0
        SuperAPI_Castlib_Settings.barOffsetY = tonumber(SuperAPI_Castlib_UIBarVerticalInput:GetText()) or 0
        SuperAPI_Castlib_Settings.barWidth = tonumber(SuperAPI_Castlib_UIBarWidthInput:GetText()) or 98
        SuperAPI_Castlib_Settings.barHeight = tonumber(SuperAPI_Castlib_UIBarHeightInput:GetText()) or 9
        SuperAPI_Castlib_Settings.iconOffsetX = tonumber(SuperAPI_Castlib_UIIconHorizontalInput:GetText()) or -4
        SuperAPI_Castlib_Settings.iconOffsetY = tonumber(SuperAPI_Castlib_UIIconVerticalInput:GetText()) or 0
        SuperAPI_Castlib_Settings.iconSize = tonumber(SuperAPI_Castlib_UIIconSizeInput:GetText()) or 20
        SuperAPI_Castlib_Settings.barFontSize = tonumber(SuperAPI_Castlib_UIFontSizeInput:GetText()) or 10
        SuperAPI_Castlib_Settings.textOffsetX = tonumber(SuperAPI_Castlib_UITextHorizontalInput:GetText()) or 0
        SuperAPI_Castlib_Settings.textOffsetY = tonumber(SuperAPI_Castlib_UITextVerticalInput:GetText()) or 0
        SuperAPI_Castlib_Settings.showSpark = SuperAPI_Castlib_UIShowSparkCheckbox:GetChecked() == 1
        SuperAPI_Castlib_Settings.barAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIBarAnchorDropDown) or "TOP"
        SuperAPI_Castlib_Settings.barAnchorParent = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIBarAnchorParentDropDown) or "BOTTOM"
        SuperAPI_Castlib_Settings.iconAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIIconAnchorDropDown) or "BOTTOMRIGHT"
        SuperAPI_Castlib_Settings.iconAnchorParent = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIIconAnchorParentDropDown) or "BOTTOMLEFT"
        SuperAPI_Castlib_Settings.textAnchor = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UITextAnchorDropDown) or "CENTER"
        SuperAPI_Castlib_Settings.barFont = UIDropDownMenu_GetSelectedValue(SuperAPI_Castlib_UIFontDropDown) or "GameFontWhite"

        -- Colors are already in SuperAPI_Castlib_Settings if picked, but if not we should make sure they are there
        if not SuperAPI_Castlib_Settings.colorStart then SuperAPI_Castlib_Settings.colorStart = { r = 1, g = 0.7, b = 0 } end
        -- (They should be there from LoadSettings)

        SuperAPI_Castlib_ApplySettings()
        SuperAPI_Castlib_SetTestMode(true)
        SuperAPI_Castlib_UITestButton:SetText("Stop testing")
        
        -- Restore settings so they aren't saved unless "Save" is clicked
        SuperAPI_Castlib_Settings = oldSettings
    end
end

function SuperAPI_Castlib_OpenColorPicker(colorType)
    local s = SuperAPI_Castlib_Settings
    local color
    local colorTypeMixed = ""
    if colorType == "START" then 
        color = s.colorStart
        colorTypeMixed = "Start"
    elseif colorType == "SUCCESS" then 
        color = s.colorSuccess
        colorTypeMixed = "Success"
    elseif colorType == "FAIL" then 
        color = s.colorFail
        colorTypeMixed = "Fail"
    elseif colorType == "CHANNEL" then 
        color = s.colorChannel
        colorTypeMixed = "Channel"
    end

    local r, g, b = color.r, color.g, color.b
    local function swatchFunc()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        color.r, color.g, color.b = r, g, b
        local texture = getglobal("SuperAPI_Castlib_UIColor"..colorTypeMixed.."SwatchBG")
        if texture then texture:SetVertexColor(r, g, b) end
        if testModeActive then
            SuperAPI_Castlib_ApplySettings()
        end
    end

    local function cancelFunc()
        color.r, color.g, color.b = r, g, b
        local texture = getglobal("SuperAPI_Castlib_UIColor"..colorTypeMixed.."SwatchBG")
        if texture then texture:SetVertexColor(r, g, b) end
        if testModeActive then
            SuperAPI_Castlib_ApplySettings()
        end
    end

    ColorPickerFrame.func = swatchFunc
    ColorPickerFrame.cancelFunc = cancelFunc
    ColorPickerFrame.hasOpacity = false
    ColorPickerFrame:SetColorRGB(r, g, b)
    ColorPickerFrame:Show()
end
