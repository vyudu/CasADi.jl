module CasADi

using PythonCall

import Base: convert, getproperty, hcat, length, promote_rule, show, size, vcat
import Base: +, -, *, /, \, ^
import Base: >, >=, <, <=, ==
import LinearAlgebra: ×

export CasadiSymbolicObject, SX, MX, DM
export casadi, to_julia, substitute
export nlpsol, qpsol, solve!, solve
export Opti, variable!, subject_to!, minimize!, parameter!, set_initial!, set_value!, solver!, value

include("types.jl")
include("math.jl")
include("array_utils.jl")
include("opti.jl")
include("solvers.jl")

##################################################

const casadi = PythonCall.pynew()
function __init__()
    PythonCall.pycopy!(casadi, pyimport("casadi"))
end

end # module
