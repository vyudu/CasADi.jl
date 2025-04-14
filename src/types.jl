abstract type CasadiSymbolicObject <: Real end

struct SX <: CasadiSymbolicObject
    x::Py
end

struct MX <: CasadiSymbolicObject
    x::Py
end

PythonCall.Py(x::MX) = x.x
PythonCall.Py(x::SX) = x.x
PythonCall.pyconvert(::Type{MX}, x::Py) = MX(x)
PythonCall.pyconvert(::Type{SX}, x::Py) = SX(x)

## text/plain

function Base.getproperty(o::C, s::Symbol) where {C<:CasadiSymbolicObject}
    if s in fieldnames(C)
        getfield(o, s)
    else
        pyconvert(Any, getproperty(o.x, s))
    end
end

SX(x::T) where {T<:Number} = pyconvert(SX, casadi.SX(x))
SX(x::AbstractVecOrMat{T}) where {T<:Number} = pyconvert(SX, casadi.SX(pyrowlist(x)))
SX(x::AbstractVecOrMat{SX}) = convert(SX, x)
SX(x::AbstractString) = pyconvert(SX, casadi.SX.sym(x))
SX(x::AbstractString, i1::Integer) = pyconvert(SX, casadi.SX.sym(x, i1))
SX(x::AbstractString, i1::Integer, i2::Integer) = pyconvert(SX, casadi.SX.sym(x, i1, i2))
SX(i1::Integer, i2::Integer) = pyconvert(SX, casadi.SX(i1, i2))

MX(x::T) where {T<:Number} = pyconvert(MX, casadi.MX(x))
MX(x::AbstractVecOrMat{T}) where {T<:Number} = pyconvert(MX, casadi.MX(pyrowlist(x)))
MX(x::AbstractVecOrMat{MX}) = convert(MX, x)
MX(x::AbstractString) = pyconvert(MX, casadi.MX.sym(x))
MX(x::AbstractString, i1::Integer) = pyconvert(MX, casadi.MX.sym(x, i1))
MX(x::AbstractString, i1::Integer, i2::Integer) = pyconvert(MX, casadi.MX.sym(x, i1, i2))
MX(i1::Integer, i2::Integer) = pyconvert(MX, casadi.MX(i1, i2))

convert(::Type{C}, s::AbstractString) where {C<:CasadiSymbolicObject} = C(s)

## promote up to symbolic so that mathops work
promote_rule(::Type{T}, ::Type{S}) where {T<:CasadiSymbolicObject,S<:Real} = T
convert(::Type{Py}, s::CasadiSymbolicObject) = s.x

"""
Convert a numeric CasADi value to a numeric Julia value.
"""
function to_julia(x::CasadiSymbolicObject)
    vals = pyconvert(Vector, casadi.evalf(x).toarray())
    if size(x) == (1, 1)
        return pyconvert(Float64, vals[1][1])
    elseif size(x, 2) == 1 || size(x, 1) == 1
        return pyconvert(Vector{Float64}, reduce(vcat, vals))
    else
        vals = reduce(vcat, vals)
        i, j = size(x)
        vals = permutedims(reshape(vals, (j, i)))
    end
end
