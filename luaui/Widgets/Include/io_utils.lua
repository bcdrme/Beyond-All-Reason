-- Do not use for general purpose file writing
--
-- This method is unoptimized for large files and does not work on binary or
-- any files without an accurate string representation
--
-- If you need a general purpose file copy function, use this if you are able
-- to adapt to VFS:
--
-- local function CopyFile(old_path, new_path)
--    local old_file = io.open(old_path, "rb")
--    local new_file = io.open(new_path, "wb")
--    local old_file_sz, new_file_sz = 0, 0
--    if not old_file or not new_file then
--      return false
--    end
--    while true do
--      local block = old_file:read(2^13)
--      if not block then
--        old_file_sz = old_file:seek( "end" )
--        break
--      end
--      new_file:write(block)
--    end
--    old_file:close()
--    new_file_sz = new_file:seek( "end" )
--    new_file:close()
--    return new_file_sz == old_file_sz
--  end
local function copyFileString(path_from, path_to)
	if not VFS.FileExists(path_from) then return end

	local contents = tostring(VFS.LoadFile(path_from))

	if not contents then return end

	local file = io.open(path_to, "a")

	if not file then return end

	file:write(contents)
	file:close()

	return true
end

local lfs = require("lfs") -- LuaFileSystem is optional for getting modification time
-- Function to watch a file
local function watch_file(filepath, on_change)
	local last_mod_time = lfs.attributes(filepath, "modification") or 0
	while true do
		local current_mod_time = lfs.attributes(filepath, "modification") or 0
		if current_mod_time ~= last_mod_time then
			last_mod_time = current_mod_time
			local file = io.open(filepath, "r")
			if file then
				local content = file:read("*all")
				file:close()
				-- Trigger the on_change callback with the new content
				on_change(content)
			else
				print("Failed to open file:", filepath)
			end
		end
		-- Add a delay to avoid excessive CPU usage
		os.execute("sleep 1")
	end
end

return {
	copyFileString = copyFileString,
	watch_file = watch_file
}
