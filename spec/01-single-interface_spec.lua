for _, list_type in ipairs { "Single", "Double" } do

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



  describe(list_type.." Linked List", function()

    local List, lst

    before_each(function()
      if list_type == "Single" then
        List = require "linkedlist.single"
      else
        List = require "linkedlist.double"
      end
      lst = List()
    end)

    after_each(function()
      List = nil
    end)



    it("get_size() returns the size", function()
      assert.equal(0, lst:get_size())
      assert(lst:add_value("one"))
      assert.equal(1, lst:get_size())
      assert(lst:add_value("two"))
      assert.equal(2, lst:get_size())
    end)



    describe("add_value()", function()

      it("appends an item without index", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.equal(2, lst:get_size())
        assert.same( { "one", "two" }, poppem(lst))
      end)


      it("appends an item with positive index", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert(lst:add_value("three", 2))    -- at last
        assert.same( { "one", "three", "two" }, poppem(lst))
        assert.equal(3, lst:get_size())

        assert(lst:add_value("four", 1))     -- at first
        assert.same( { "four", "one", "three", "two" }, poppem(lst))
        assert.equal(4, lst:get_size())

        assert(lst:add_value("five", 5))     -- append
        assert.same( { "four", "one", "three", "two", "five" }, poppem(lst))
        assert.equal(5, lst:get_size())

        assert(lst:add_value("six", 999))   -- way beyond
        assert.same( { "four", "one", "three", "two", "five", "six" }, poppem(lst))
        assert.equal(6, lst:get_size())

        -- add some more
        assert(lst:add_value(1, 4))
        assert(lst:add_value(2, 4))
        assert(lst:add_value(3, 4))
        assert(lst:add_value(4, 4))
        assert(lst:add_value(5, 4))
        assert.same( { "four", "one", "three", 5, 4, 3, 2, 1, "two", "five", "six" }, poppem(lst))
        assert.equal(11, lst:get_size())
      end)


      it("appends an item with negative index", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert(lst:add_value("three", -1))    -- at last
        assert.same( { "one", "two", "three" }, poppem(lst))
        assert.equal(3, lst:get_size())

        assert(lst:add_value("four", -4))     -- 1 before
        assert.same( { "four", "one", "two", "three" }, poppem(lst))
        assert.equal(4, lst:get_size())

        assert(lst:add_value("five", -4))     -- at currrent first
        assert.same( { "four", "five", "one", "two", "three" }, poppem(lst))
        assert.equal(5, lst:get_size())

        assert(lst:add_value("six", -999))   -- way beyond
        assert.same( { "six", "four", "five", "one", "two", "three" }, poppem(lst))
        assert.equal(6, lst:get_size())
      end)


      it("appends an item with index 0 at the start", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert(lst:add_value("three", 0))    -- at start
        assert.same( { "three", "one", "two" }, poppem(lst))
        assert.equal(3, lst:get_size())
      end)

    end)



    describe("first_item()", function()

      it("returns first item", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("one", lst:first_item().value)
      end)


      it("doesn't remove the item", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("one", lst:first_item().value)
        assert.same("one", lst:first_item().value) -- same value again
        assert.equal(2, lst:get_size())
      end)


      it("returns an error on an empty list", function()
        assert.same({nil, "not found"}, {lst:first_item()})
      end)

    end)



    describe("first_value()", function()

      it("returns first value", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("one", lst:first_value())
      end)


      it("doesn't remove the value", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("one", lst:first_value())
        assert.same("one", lst:first_value()) -- same value again
        assert.equal(2, lst:get_size())
      end)


      it("returns an error on an empty list", function()
        assert.same({nil, "not found"}, {lst:first_value()})
      end)

    end)



    describe("last_item()", function()

      it("returns last item", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("two", lst:last_item().value)
      end)


      it("doesn't remove the item", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("two", lst:last_item().value)
        assert.same("two", lst:last_item().value) -- same value again
        assert.equal(2, lst:get_size())
      end)


      it("returns an error on an empty list", function()
        assert.same({nil, "not found"}, {lst:last_item()})
      end)

    end)



    describe("last_value()", function()

      it("returns last value", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("two", lst:last_value())
      end)


      it("doesn't remove the value", function()
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same("two", lst:last_value())
        assert.same("two", lst:last_value()) -- same value again
        assert.equal(2, lst:get_size())
      end)


      it("returns an error on an empty list", function()
        assert.same({nil, "not found"}, {lst:last_value()})
      end)

    end)



    describe("get_item()", function()

      it("returns the item at the specified index", function()
        -- on an empty list
        assert.same({nil, "not found"}, {lst:get_item(2)})
        assert.same({nil, "not found"}, {lst:get_item(1)})
        assert.same({nil, "not found"}, {lst:get_item(0)})
        assert.same({nil, "not found"}, {lst:get_item(-1)})
        assert.same({nil, "not found"}, {lst:get_item(-2)})
        -- on a non-empty list
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert(lst:add_value("three"))
        assert(lst:add_value("four"))
        assert(lst:add_value("five"))
        assert.same({nil, "not found"}, {lst:get_item(6)})
        assert.same("five",  lst:get_item(5).value)
        assert.same("four",  lst:get_item(4).value)
        assert.same("three", lst:get_item(3).value)
        assert.same("two",   lst:get_item(2).value)
        assert.same("one",   lst:get_item(1).value)
        assert.same({nil, "not found"}, {lst:get_item(0)})
        assert.same("five",  lst:get_item(-1).value)
        assert.same("four",  lst:get_item(-2).value)
        assert.same("three", lst:get_item(-3).value)
        assert.same("two",   lst:get_item(-4).value)
        assert.same("one",   lst:get_item(-5).value)
        assert.same({nil, "not found"}, {lst:get_item(-6)})
      end)

    end)



    describe("get_value()", function()

      it("returns the value at the specified index", function()
        -- on an empty list
        assert.same({nil, "not found"}, {lst:get_value(2)})
        assert.same({nil, "not found"}, {lst:get_value(1)})
        assert.same({nil, "not found"}, {lst:get_value(0)})
        assert.same({nil, "not found"}, {lst:get_value(-1)})
        assert.same({nil, "not found"}, {lst:get_value(-2)})
        -- on a non-empty list
        assert(lst:add_value("one"))
        assert(lst:add_value("two"))
        assert.same({nil, "not found"}, {lst:get_value(3)})
        assert.same("two", lst:get_value(2))
        assert.same("one", lst:get_value(1))
        assert.same({nil, "not found"}, {lst:get_value(0)})
        assert.same("two", lst:get_value(-1))
        assert.same("one", lst:get_value(-2))
        assert.same({nil, "not found"}, {lst:get_value(-3)})
      end)

    end)



    describe("get_next()", function()

      it("defaults to the first item if not given", function()
        assert.same({nil, "not found"}, {lst:get_next()})
        local item1 = assert(lst:add_value("one"))
        local item2 = assert(lst:add_value("two"))
        assert.equal(item1, lst:get_next())
        assert.not_equal(item2, lst:get_next())
      end)

      it("returns the next item", function()
        local item1 = assert(lst:add_value("one"))
        local item2 = assert(lst:add_value("two"))
        assert.same({nil, "not found"}, {lst:get_next(item2)})
        assert.equal(item2, lst:get_next(item1))
      end)

    end)



    describe("push()", function()

      it("pushes a value in the list", function()
        assert(lst:push("one"))
        assert.equal(1, lst:get_size())
        assert(lst:push("two"))
        assert.equal(2, lst:get_size())
        assert.same( { "one", "two" }, poppem(lst))
      end)

    end)



    describe("pop()", function()

      it("pops values from the list", function()
        assert(lst:push("one"))
        assert(lst:push("two"))
        assert.equal("one", lst:pop())
        assert.equal("two", lst:pop())
        assert.same({nil, "not found" }, {lst:pop()})
      end)

    end)



    describe("peek()", function()

      it("returns values without removing from the list", function()
        assert.same({nil, "not found" }, {lst:peek()})
        assert(lst:push("one"))
        assert(lst:push("two"))
        assert.equal("one", lst:peek())
        assert.equal("one", lst:peek())
        assert.equal(2, lst:get_size())
      end)

    end)



    describe("clear()", function()

      it("clears the list", function()
        assert(lst:push("one"))
        assert(lst:push("two"))
        assert(lst:clear())
        assert.equal(0, lst:get_size())
        assert.same({nil, "not found" }, {lst:first_item()})
        assert.same({nil, "not found" }, {lst:last_item()})
      end)

    end)



    describe("iter()", function()

      it("returns the list one by one", function()
        assert(lst:push("one"))
        assert(lst:push("two"))
        assert(lst:push("three"))
        local r = {}
        for idx, value in lst:iter() do
          r[idx] = value
        end
        assert.equal(3, lst:get_size()) -- unchanged
        assert.same({ "one", "two", "three" }, r)
      end)

    end)

  end)

end
