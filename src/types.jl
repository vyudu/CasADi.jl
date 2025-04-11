#################################################
## CasadiSymbolicObject types have field x::Py ##
## Symbol class for controlling dispatch

abstract type CasadiSymbolicObject <: Real end

struct SX <: CasadiSymbolicObject
    sym::Py
end

struct MX <: CasadiSymbolicObject
    sym::Py
end

Base.convert(::Type{C}, x::Py) where {C<:CasadiSymbolicObject} = C(x)

## text/plain
Base.show(io::IO, s::CasadiSymbolicObject) = print(io, pybuiltins.print(s))

function Base.getproperty(o::C, s::Symbol) where {C<:CasadiSymbolicObject}
    if s in fieldnames(C)
        getfield(o, s)
    else
        getproperty(pyconvert(o), s)
    end
end
