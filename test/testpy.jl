macro test_py(testexpr)
    quote
        pybool = $testexpr
        @test pyconvert(Bool, pybool)
    end
end
