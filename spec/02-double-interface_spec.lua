-- returns a regular Lua list with all contents
local poppem = function(lst)
  local res = {}
  local i = 1

  local item = lst:first_item()
  local last = lst:last_item()

  while item do
    res[i] = item.value

    if item == last then break end
    i = i + 1
    item = item ~= last and item.next
  end
  return res
end



describe("Double Linked List", function()

  local List, lst

  before_each(function()
    List = require "linkedlist.double"
    lst = List()
  end)

  after_each(function()
    List = nil
  end)



  describe("swap()", function()

    it("moves items to new positions", function()
      local item1 = assert(lst:add_value("one"))
      local item2 = assert(lst:add_value("two"))
      local item3 = assert(lst:add_value("three"))
      local item4 = assert(lst:add_value("four"))
      assert(lst:add_value("five"))
      assert.same( { "one", "two", "three", "four", "five" }, poppem(lst))
      lst:swap(item2, item4) -- 2 not next to each other
      assert.same( { "one", "four", "three", "two", "five" }, poppem(lst))
      lst:swap(item3, item3) -- swap the same item
      assert.same( { "one", "four", "three", "two", "five" }, poppem(lst))
      lst:swap(item1, item4) -- 2 next to each other
      assert.same( { "four", "one", "three", "two", "five" }, poppem(lst))
    end)

  end)



  describe("move_up()", function()

    it("moves items 1 position towards start of list", function()
      assert(lst:add_value("one"))
      assert(lst:add_value("two"))
      local item3 = assert(lst:add_value("three"))
      assert.same( { "one", "two", "three" }, poppem(lst))
      assert(lst:move_up(item3))
      assert.same( { "one", "three", "two" }, poppem(lst))
      assert(lst:move_up(item3))
      assert.same( { "three", "one", "two" }, poppem(lst))
      assert.is_false(lst:move_up(item3))
      assert.same( { "three", "one", "two" }, poppem(lst))
    end)

  end)



  describe("move_down()", function()

    it("moves items 1 position towards end of list", function()
      local item1 = assert(lst:add_value("one"))
      assert(lst:add_value("two"))
      assert(lst:add_value("three"))
      assert.same( { "one", "two", "three" }, poppem(lst))
      assert(lst:move_down(item1))
      assert.same( { "two", "one", "three" }, poppem(lst))
      assert(lst:move_down(item1))
      assert.same( { "two", "three", "one" }, poppem(lst))
      assert.is_false(lst:move_down(item1))
      assert.same( { "two", "three", "one" }, poppem(lst))
    end)

  end)



  describe("get_previous()", function()

    it("defaults to the last item if not given", function()
      assert.same({nil, "not found"}, {lst:get_previous()})
      local item1 = assert(lst:add_value("one"))
      local item2 = assert(lst:add_value("two"))
      assert.equal(item2, lst:get_previous())
      assert.not_equal(item1, lst:get_previous())
    end)

    it("returns the next item", function()
      local item1 = assert(lst:add_value("one"))
      local item2 = assert(lst:add_value("two"))
      assert.same({nil, "not found"}, {lst:get_previous(item1)})
      assert.equal(item1, lst:get_previous(item2))
    end)

  end)



  describe("pop_lifo()", function()

    it("pops values from the end of the list", function()
      assert(lst:push("one"))
      assert(lst:push("two"))
      assert.equal("two", lst:pop_lifo())
      assert.equal("one", lst:pop_lifo())
      assert.same({nil, "not found" }, {lst:pop_lifo()})
    end)

  end)



  describe("peek_lifo()", function()

    it("returns values without removing from the list", function()
      assert.same({nil, "not found" }, {lst:peek_lifo()})
      assert(lst:push("one"))
      assert(lst:push("two"))
      assert.equal("two", lst:peek_lifo())
      assert.equal("two", lst:peek_lifo())
      assert.equal(2, lst:get_size())
    end)

  end)



  describe("reverse_iter()", function()

    it("returns the list one by one in reverse order", function()
      assert(lst:push("one"))
      assert(lst:push("two"))
      assert(lst:push("three"))
      local r = {}
      for idx, value in lst:reverse_iter() do
        r[idx] = value
      end
      assert.equal(3, lst:get_size()) -- unchanged
      assert.same({ "three", "two", "one" }, r)
    end)

  end)

end)

