--- A double-linked-list class.
--
-- The class features the following functionality:
--
-- * API compatible with the single-linked-list (easy to switch)
-- * adds lifo queue behaviour.
-- * adds method to swap 2 items in position
-- * adds methods for moving items up/down
-- * adds a reverse iterator
--
-- The `item` objects are mostly for internal use only. The actual value stored lives
-- in the `item.value` field.
-- @classmod linkedlist.double

local EMPTY = {}

local Item = {}
Item.__index = Item

function Item:insert_before(item_to_insert)
  item_to_insert.next = self
  item_to_insert.previous = self.previous
  item_to_insert.previous.next = item_to_insert
  item_to_insert.next.previous = item_to_insert
end

function Item:remove()
  self.previous.next = self.next
  self.next.previous = self.previous
end

function Item:swap(item)
  if self == item then
    return  -- same item, nothing to do

  elseif self == item.next then
    -- adjacent; "some-item" -> item -> self -> "another-item"
    item.previous.next, item.next, self.next, item.previous, self.previous, self.next.previous = self, self.next, item, self, item.previous, item
    return

  elseif self == item.previous then
    -- adjacent; "some-item" -> self -> item -> "another-item"
    self.previous.next, self.next, item.next, self.previous, item.previous, item.next.previous = item, item.next, self, item, self.previous, self
    return

  else -- not adjacent
    item.next, self.next = self.next, item.next
    item.previous, self.previous = self.previous, item.previous
    item.previous.next = item
    item.next.previous = item
    self.previous.next = self
    self.next.previous = self
    return
  end
  -- unreachable
end



local List = {}
List.__index = List
setmetatable(List, {
  __call = function(self, ...)
    return self.new(...)
  end
})

-- note: idx MUST be positive and valid (1-size)
local function get_by_index(self, idx)
  if idx < (self.size/2 + 1) then
    -- start from start
    local pointer = self.first.next
    while idx > 1 do
      idx = idx - 1
      pointer = pointer.next
    end
    return pointer
  else
    -- start from end
    idx = self.size - idx + 1
    local pointer = self.last.previous
    while idx > 1 do
      idx = idx - 1
      pointer = pointer.previous
    end
    return pointer
  end
end

--- Methods additional to the Single linked list interface.
-- @section Double


--- Swaps two items.
-- Updates the positions of the two items in the list. If the items are the same
-- item, nothing happens.
-- @tparam item item1 must be an item object as returned when added.
-- @tparam item item2 must be an item object as returned when added.
-- @return nothing
function List:swap(item1, item2)
  item1:swap(item2)
end


--- Moves an item 1 element up.
-- Moves 1 position towards the start of the list. Does nothing
-- if the item is already at the top of the list.
-- @tparam item item must be an item object as returned when added.
-- @return true if successful, false if already at the top
function List:move_up(item)
  local item2 = item.previous
  if item2 == self.first then
    -- this is the start node, so we're at the top already
    return false
  end
  item:swap(item2)
  return true
end


--- Moves an item 1 element down.
-- Moves 1 position towards the end of the list. Does nothing
-- if the item is already at the end of the list.
-- @tparam item item must be an item object as returned when added.
-- @return true if successful, false if already at the end
function List:move_down(item)
  local item2 = item.next
  if item2 == self.last then
    -- this is the end node, so we're at the end already
    return false
  end
  item:swap(item2)
  return true
end


--- Gets the previous item.
-- @tparam[opt] item item an item object as returned when added, if not provided, the
-- last item in the list will be returned.
-- @return the previous/last item, or nil+"not found"
function List:get_previous(item)
  if not item then
    -- default to first item if available
    if self.size == 0 then
      return nil, "not found"
    end
    return self.last.previous
  end

  local item = item.previous
  if item == self.first then
    return nil, "not found"
  end
  return item
end


--- Pops the value at the end (lifo).
-- @return the value at the end, or `nil+"not found"` if empty
function List:pop_lifo()
  local item = self.last.previous
  if item == self.first then
    return nil, "not found"
  end
  item:remove()
  self.size = self.size - 1
  return item.value
end


--- Returns the value at the end (lifo), without removing it.
-- @return the value at the end, or `nil+"not found"` if empty
function List:peek_lifo()
  if self.size == 0 then
    -- list is empty
    return nil, "not found"
  end
  return self.last.previous.value
end


--- Iterator over the list, in reverse order.
-- Note: the returned `count` will be from 1 to `size`, ascending.
-- @return iterator returning count and value
-- @usage
-- for cnt, value in my_list:iter() do
--     print(value)
-- end
function List:reverse_iter()
  local pointer = self.last.previous
  local i = 0
  return function()
    if pointer == self.first then
      return -- we're done
    end
    local value = pointer.value
    pointer = pointer.previous
    i = i + 1
    return i, value
  end
end



--- Single linked list interface.
-- This part is the same interface that the Single linked list has. The interface is
-- identical, so it should be easy to update from Single to Double.
-- @section Single



--- Create a new Linked List object.
-- @return Linked List object
-- @usage
-- local lst = List.new()
-- -- or alternatively
-- local lst = List()
function List.new()
  local self = setmetatable({
    first = {
      insert_after = Item.insert_after
    },
    last = {
      insert_before = Item.insert_before
    },
    size = 0,
  }, List)

  self.first.next = self.last
  self.last.previous = self.first
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
  local item = setmetatable({ value = value }, Item)

  if idx == nil or idx > 0 then
    -- positive; assign default and limit range
    idx = math.min(size + 1, idx or (size+1))
  elseif idx == 0 then
    idx = 1
  elseif idx < 0 then
    idx = math.max(1, size + idx + 2)
  end

  if idx > size then
    -- append at the end
    self.last:insert_before(item)
    self.size = size + 1
    return item
  end

  get_by_index(self, idx):insert_before(item)
  self.size = size + 1
  return item
end


--- Gets the first item in the list.
-- Does not remove the item from the list.
-- @return the first item, or nil+"not found"
function List:first_item()
  local r = self.first.next
  if r == self.last then
    return nil, "not found"
  end
  return r
end


--- Gets the first value in the list.
-- Does not remove the value from the list.
-- @return the first value, or nil+"not found"
function List:first_value()
  local r = self.first.next
  if r == self.last then
    return nil, "not found"
  end
  return r.value
end


--- Gets the last item in the list.
-- Does not remove the item from the list.
-- @return the last item
function List:last_item()
  local r = self.last.previous
  if r == self.first then
    return nil, "not found"
  end
  return r
end


--- Gets the last value in the list.
-- Does not remove the value from the list.
-- @return the last value
function List:last_value()
  local r = self.last.previous
  if r == self.first then
    return nil, "not found"
  end
  return r.value
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

  local item = get_by_index(self, idx)
  return item, item == nil and "not found" or nil
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
    return self.first.next
  end

  local item = item.next
  if item == self.last then
    return nil, "not found"
  end
  return item
end


--- Adds a value to the end of the list.
-- @param value the value to store in the list, can be any type, inlcuding `nil`
-- @return the added item.
function List:push(value)
  local item = setmetatable({ value = value }, Item)
  self.last:insert_before(item)
  self.size = self.size + 1
  return item
end


--- Pops the value at the top/start.
-- @return the value at the start, or `nil+"not found"` if empty
function List:pop()
  local item = self.first.next
  if item == self.last then
    return nil, "not found"
  end
  item:remove()
  self.size = self.size - 1
  return item.value
end


--- Returns the value at the top/start, without removing it.
-- @return the value at the start, or `nil+"not found"` if empty
function List:peek()
  if self.size == 0 then
    -- list is empty
    return nil, "not found"
  end
  return self.first.next.value
end


--- Clears the list.
-- @return true
function List:clear()
  self.first.next = self.last
  self.last.previous = self.first
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
  local pointer = self.first.next
  local i = 0
  return function()
    if pointer == self.last then
      return -- we're done
    end
    local value = pointer.value
    pointer = pointer.next
    i = i + 1
    return i, value
  end
end

return List
