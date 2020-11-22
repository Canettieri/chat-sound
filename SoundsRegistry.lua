local ADDON_NAME, L = ...
local LSM = LibStub("LibSharedMedia-3.0")

for i = 1, 12 do
	LSM:Register(
			LSM.MediaType.SOUND, "CSC Sound " .. i,
			"Interface\\AddOns\\" .. ADDON_NAME .. "\\audios\\sound" .. i .. ".mp3"
	)
end

LSM:Register(
		LSM.MediaType.SOUND,
		"Murloc Aggro",
		556000
)
