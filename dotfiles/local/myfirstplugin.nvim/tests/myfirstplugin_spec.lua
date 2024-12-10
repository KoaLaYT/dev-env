describe("myfirstplugin", function()
    it("can be required", function()
        require("myfirstplugin")
    end)

    it("assert 1 + 1 == 2", function()
        assert.is_equal(2, 1 + 1, "1 + 1 should equals to 2")
    end)
end)
