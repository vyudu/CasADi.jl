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

SX(x::T) where {T<:Number} = casadi.SX(x)
SX(x::T) where {T<:AbstractVecOrMat{SX}} = convert(SX, x)
SX(x::AbstractVecOrMat{T}) where {T<:AbstractFloat} = casadi.SX(x)
SX(x::AbstractVecOrMat{T}) where {T<:Integer} = casadi.SX(x)
SX(x::AbstractString) = casadi.SX.sym(x)
SX(x::AbstractString, i1::Integer) = casadi.SX.sym(x, i1)
SX(x::AbstractString, i1::Integer, i2::Integer) = casadi.SX.sym(x, i1, i2)
SX(i1::Integer, i2::Integer) = casadi.SX(i1, i2)

MX(x::T) where {T<:Number} = casadi.MX(x)
MX(x::T) where {T<:AbstractVecOrMat{MX}} = convert(MX, x)
MX(x::AbstractVecOrMat{T}) where {T<:AbstractFloat} = casadi.MX(x)
MX(x::AbstractVecOrMat{T}) where {T<:Integer} = casadi.MX(x)
MX(x::AbstractString) = casadi.MX.sym(x)
MX(x::AbstractString, i1::Integer) = casadi.MX.sym(x, i1)
MX(x::AbstractString, i1::Integer, i2::Integer) = casadi.MX.sym(x, i1, i2)
MX(i1::Integer, i2::Integer) = casadi.MX(i1, i2)

convert(::Type{C}, s::AbstractString) where {C<:CasadiSymbolicObject} = C(s)

## promote up to symbolic so that mathops work
promote_rule(::Type{T}, ::Type{S}) where {T<:CasadiSymbolicObject,S<:Real} = T
convert(::Type{Py}, s::CasadiSymbolicObject) = s.sym

"""
Convert a numeric CasADi value to a numeric Julia value.
"""
function to_julia(x::CasadiSymbolicObject)
    if size(x, 1) == 1 && size(x, 2) == 1
        return casadi.evalf(x).toarray()[1]
    end
    if size(x, 2) == 1
        return casadi.evalf(x).toarray()[:]
    end

    return reshape(casadi.evalf(x).toarray(), size(x))
end
