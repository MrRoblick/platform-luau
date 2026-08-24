--!optimize 2
--!strict
--!nolint DeprecatedGlobal
--!nolint DeprecatedApi

--[[

platform-luau

Developer: @MrRoblick
License: MIT
Repository: https://github.com/MrRoblick/platform-luau

]]

const UserInputService = game:GetService('UserInputService')
const GuiService = game:GetService('GuiService')
const TextService = game:GetService('TextService')
const VRService = game:GetService('VRService')

const NonCharacterUTF8 = "\u{FFFF}"
const PrivateUseAreaCharacterUTF8 = "\u{E0FF}"
const AppleLogoCharacterUTF8 = "\u{F8FF}"

const NonCharacterSize = TextService:GetTextSize(
	NonCharacterUTF8, 16, Enum.Font.SourceSans, Vector2.one * 1000.0
)

@checked const function GetArchitecture(): number
	const Addr = tostring({}):sub(10)
	return if #Addr > 8 then 64 else 32
end

@checked const function IsValidCharacter(Char: string): boolean
	const Size = TextService:GetTextSize(Char, 16, Enum.Font.SourceSans, Vector2.one * 1000.0)
	return Size.Magnitude ~= NonCharacterSize.Magnitude
end

const Architecture = GetArchitecture()

@checked export function GetPlatform(): (Enum.Platform, number)
	const ClientVersion = version()
	const VrEnabled = UserInputService.VREnabled and VRService.VREnabled
	const TouchEnabled = UserInputService.TouchEnabled

	const IsMacOSClient = ClientVersion:match("^0%.") ~= nil
	const IsConsoleClient = ClientVersion:match("^1%.") ~= nil
	const IsUWPClient = ClientVersion:match("^2%.") ~= nil
	const IsTenFoot = GuiService:IsTenFootInterface()
	const IsConsoleOrTenFoot = IsTenFoot or IsConsoleClient

	if GuiService.IsWindows then
		if IsUWPClient then
			return Enum.Platform.UWP, Architecture
		elseif IsConsoleOrTenFoot then
			return Enum.Platform.XBoxOne, Architecture
		elseif IsValidCharacter(PrivateUseAreaCharacterUTF8) then
			return Enum.Platform.Linux, Architecture
		else
			return Enum.Platform.Windows, Architecture
		end
	elseif IsMacOSClient then
		return Enum.Platform.OSX, Architecture
	elseif IsConsoleOrTenFoot then
		const Icon = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect):lower()
		if Icon:match("ps5") then
			return Enum.Platform.PS5, Architecture
		elseif Icon:match("ps4") then
			return Enum.Platform.PS4, Architecture
		elseif Icon:match("xbox") then
			return Enum.Platform.XBoxOne, Architecture
		elseif TouchEnabled then
			return if IsValidCharacter(AppleLogoCharacterUTF8) then Enum.Platform.IOS else Enum.Platform.Android, Architecture
		elseif UserInputService.KeyboardEnabled then
			return Enum.Platform.Windows, Architecture
		end
	elseif IsUWPClient then
		if VrEnabled then
			return Enum.Platform.MetaOS, Architecture
		elseif Architecture == 32 then
			return if TouchEnabled then Enum.Platform.Android else Enum.Platform.Linux, Architecture
		else
			if IsValidCharacter(AppleLogoCharacterUTF8) then
				return Enum.Platform.IOS, Architecture
			elseif TouchEnabled then
				return Enum.Platform.Android, Architecture
			else
				return Enum.Platform.Linux, Architecture
			end
		end
	elseif VrEnabled then
		return Enum.Platform.MetaOS, Architecture
	elseif TouchEnabled then
		return if IsValidCharacter(AppleLogoCharacterUTF8) then Enum.Platform.IOS else Enum.Platform.Android, Architecture
	elseif UserInputService.KeyboardEnabled then
		return Enum.Platform.Windows, Architecture
	end
	return Enum.Platform.None, Architecture
end
