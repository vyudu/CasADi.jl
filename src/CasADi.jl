module CasADi

using PythonCall

import Base: convert, getproperty, hcat, length, promote_rule, show, size, vcat
import Base: +, -, *, /, \, ^
import Base: >, >=, <, <=, ==
import LinearAlgebra: ×

export CasadiSymbolicObject, SX, MX
export casadi, to_julia, substitute

include("types.jl")
include("constructors.jl")
include("numbers.jl")
include("math.jl")
include("generic.jl")
include("utils.jl")

##################################################

const casadi = PythonCall.pynew()

function __init__()
    ## Define casadi
    PythonCall.pycopy!(casadi, pyimport("casadi"))
end

end # module
