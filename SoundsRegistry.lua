local ADDON_NAME, L = ...
local LSM = LibStub("LibSharedMedia-3.0")

for i = 1, 8 do
	LSM:Register(
			LSM.MediaType.SOUND, "CSC Sound " .. i,
			"Interface\\AddOns\\" .. ADDON_NAME .. "\\audios\\sound" .. i .. ".mp3"
	)
end
