--- A single-linked-list class.
--
-- The class features the following functionality:
--
-- * it is nil-safe. Any values, including nils can be stored.
-- * has push/pop/peek semantics for (fifo) queue behaviour.
-- * keeps track of first + last item, for cheap pushing/popping.
-- * has methods for indexing (array-like), getting/storing values (though not efficient)
--
-- The `item` objects are mostly for internal use only. The actual value stored lives
-- in the `item.value` field.
--
-- Traversing the list:
--
--      local item = lst:get_next()
--      while item do
--        print(item.value)
--
--        item = lst:get_next(item)
--      end
-- @classmod linkedlist.single

local EMPTY = {}


local List = {}
List.__index = List
setmetatable(List, {
  __call = function(self, ...)
    return self.new(...)
  end
})

--- Create a new Linked List object.
-- @return Linked List object
-- @usage
-- local lst = List.new()
-- -- or alternatively
-- local lst = List()
function List.new()
  local self = setmetatable({
    first = nil,
    last = nil,
    size = 0,
  }, List)

  return self
end


--- Gets the length of the list.
-- @return integer, length of the list
function List:get_size()
  return self.size
end


--- Adds an item to the list.
-- Note that the `idx` position, is the position where the item ends up after insertion.
-- Too high or too low indices will not return errors, but insert at the start/end.
-- @param value the value to store in the list, can be any type, inlcuding `nil`
-- @tparam[opt=size+1] int idx position where to add (negative indices allowed, `idx = 0`
-- will add at the start). By default appends at end.
-- @return the added item.
function List:add_value(value, idx)
  local size = self.size
  local item = { value = value }

  if size == 0 then
    -- first element added
    self.first = item
    self.last = item
    self.size = 1
    return item
  end

  if idx == nil or idx > 0 then
    -- positive; assign default and limit range
    idx = math.min(size + 1, idx or (size+1))
  elseif idx == 0 then
    idx = 1
  elseif idx < 0 then
    idx = math.max(1, size + idx + 2)
  end

  if idx == 1 then
    -- prepend at start
    item.next = self.first
    self.first = item
    self.size = size + 1
    return item
  elseif idx > size then
    -- append at the end
    self.last.next = item
    self.last = item
    self.size = size + 1
    return item
  end

  -- count from start
  local pointer = self.first
  while idx > 2 do
    pointer = pointer.next
    idx = idx - 1
  end
  item.next = pointer.next
  pointer.next = item

  self.size = size + 1
  return item
end


--- Gets the first item in the list.
-- Does not remove the item from the list.
-- @return the first item, or nil+"not found"
function List:first_item()
  local r = self.first
  return r, r == nil and "not found" or nil
end


--- Gets the first value in the list.
-- Does not remove the value from the list.
-- @return the first value, or nil+"not found"
function List:first_value()
  local r = self.first
  return (r or EMPTY).value, r == nil and "not found" or nil
end


--- Gets the last item in the list.
-- Does not remove the item from the list.
-- @return the last item
function List:last_item()
  local r = self.last
  return r, r == nil and "not found" or nil
end


--- Gets the last value in the list.
-- Does not remove the value from the list.
-- @return the last value
function List:last_value()
  local r = self.last
  return (r or EMPTY).value, r == nil and "not found" or nil
end


--- Gets the item at the specified index.
-- Note: this method iterates over the list to find the index, so it is
-- not efficient, especially with larger lists.
-- @tparam int idx index of the item to return
-- @return the item, or nil+"not found"
function List:get_item(idx)
  if idx < 0 then
    idx = self.size + idx + 1
  end

  if idx < 1 or idx > self.size then
    return nil, "not found"
  end

  local pointer = self.first
  while idx > 1 and pointer do
    pointer = pointer.next
    idx = idx - 1
  end

  return pointer, pointer == nil and "not found" or nil
end

--- Gets the value at the specified index.
-- Note: this method iterates over the list to find the index, so it is
-- not efficient, especially with larger lists.
-- @tparam int idx index of the value to return
-- @return the value, or nil+"not found"
function List:get_value(idx)
  local item, err = self:get_item(idx)
  return (item or EMPTY).value, err
end


--- Gets the next item.
-- @tparam[opt] item item an item object as returned when added, if not provided, the
-- first item in the list will be returned.
-- @return the next/first item, or nil+"not found"
function List:get_next(item)
  if not item then
    -- default to first item if available
    if self.size == 0 then
      return nil, "not found"
    end
    return self.first
  end

  if item == self.last then
    return nil, "not found"
  end
  return item.next
end


--- Adds a value to the end of the list.
-- @param value the value to store in the list, can be any type, inlcuding `nil`
-- @return the added item.
function List:push(value)
  return self:add_value(value)
end


--- Pops the value at the top/start.
-- @return the value at the start, or `nil+"not found"` if empty
function List:pop()
  local item = self.first
  local size = self.size
  if size < 2 then
    if size == 0 then
      -- list is empty
      return nil, "not found"
    end
    -- list has 1 item
    self.first = nil
    self.last = nil
    self.size = 0
    return item.value
  end

  self.first = item.next
  self.size = size - 1
  return item.value
end


--- Returns the value at the top/start, without removing it.
-- @return the value at the start, or `nil+"not found"` if empty
function List:peek()
  if self.size == 0 then
    -- list is empty
    return nil, "not found"
  end
  return self.first.value
end


--- Clears the list.
-- @return true
function List:clear()
  self.first = nil
  self.last = nil
  self.size = 0
  return true
end


--- Iterator over the list.
-- @return iterator returning idx and value
-- @usage
-- for i, value in my_list:iter() do
--     print(value)
-- end
function List:iter()
  local pointer = self.first
  local i = 0
  return function()
    if not pointer then
      return -- we're done
    end
    local value = pointer.value
    pointer = pointer.next
    i = i + 1
    return i, value
  end
end

return List
