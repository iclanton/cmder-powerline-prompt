local function get_node_version(path)
  local result = io.popen("node -v")
  if result then
    for line in result:lines() do
      result:close()
      return line
    end
  else
    return false
  end
end

-- * Segment object with these properties:
---- * isNeeded: sepcifies whether a segment should be added or not. For example: no Git segment is needed in a non-git folder
---- * text
---- * textColor: Use one of the color constants. Ex: colorWhite
---- * fillColor: Use one of the color constants. Ex: colorBlue
local segment = {
  isNeeded = false,
  text = "",
  textColor = colorBlack,
  fillColor = colorGreen
}

---
-- Sets the properties of the Segment object, and prepares for a segment to be added
---
local function init()
  segment.isNeeded = get_node_version()
  if segment.isNeeded then
    segment.text = "   "..segment.isNeeded.." "
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
