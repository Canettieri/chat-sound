local LSM = LibStub("LibSharedMedia-3.0")

for i = 1, 8 do
	LSM:Register(LSM.MediaType.SOUND, "CSC Sound " .. i, "Interface\\AddOns\\Chat_Sound\\audios\\sound" .. i .. ".mp3")
end
