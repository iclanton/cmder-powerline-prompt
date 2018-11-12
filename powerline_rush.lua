local function get_rush_json_dir(path)

  -- return parent path for specified entry (either file or directory)
  local function pathname(path)
          local prefix = ""
          local postfix = ""
          local i = path:find("[\\/:][^\\/:]*$")
          if i then
                  prefix = path:sub(1, i-1)

          end
          return prefix
  end

  if not path or path == '.' then path = clink.get_cwd() end

  local parent_path = pathname(path)
  return io.open(path..'\\rush.json') or (parent_path ~= path and get_rush_json_dir(parent_path) or nil)
end

-- * Segment object with these properties:
---- * isNeeded: sepcifies whether a segment should be added or not. For example: no Git segment is needed in a non-git folder
---- * text
---- * textColor: Use one of the color constants. Ex: colorWhite
---- * fillColor: Use one of the color constants. Ex: colorBlue
local segment = {
  isNeeded = false,
  text = "",
  textColor = colorWhite,
  fillColor = colorOrange
}

---
-- Sets the properties of the Segment object, and prepares for a segment to be added
---
local function init()
  segment.isNeeded = get_rush_json_dir()
  if segment.isNeeded then
    local rush_json = segment.isNeeded:read('*a')
    segment.isNeeded:close()

    local rush_version = string.match(rush_json, '"rushVersion"%s*:%s*"(.-)"')
    if rush_version == nil then
            rush_version = '(unmanaged)'
    end

    segment.text = " rush v"..rush_version.." "
  end
end

---
-- Uses the segment properties to add a new segment to the prompt
---
local function addAddonSegment()
  init()
  if segment.isNeeded then
      addSegment(segment.text, segment.textColor, segment.fillColor)
  end
end

-- Register this addon with Clink
clink.prompt.register_filter(addAddonSegment, 60)
