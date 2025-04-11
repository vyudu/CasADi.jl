## Unary operations
-(x::C) where {C<:CasadiSymbolicObject} = pycall(casadi.minus, C, 0, x)
Base.sqrt(x::T) where {T<:CasadiSymbolicObject} = pycall(casadi.sqrt, T, x)
Base.sin(x::T) where {T<:CasadiSymbolicObject} = pycall(casadi.sin, T, x)
Base.cos(x::T) where {T<:CasadiSymbolicObject} = pycall(casadi.cos, T, x)
Base.sincos(x::CasadiSymbolicObject) = (sin(x), cos(x))
Base.sinc(x::CasadiSymbolicObject) = sin(x) / x
Base.abs(x::T) where {T<:CasadiSymbolicObject} = pycall(casadi.fabs, T, x)

## Binary operations
+(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.plus, C, x, y)
-(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.minus, C, x, y)
/(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.mrdivide, C, x, y)
^(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.power, C, x, y)
^(x::C, y::Integer) where {C<:CasadiSymbolicObject} = pycall(casadi.power, C, x, y)
\(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.solve, C, x, y)
×(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.cross, C, x, y)

function *(x::C, y::Real) where {C<:CasadiSymbolicObject}
    if size(x, 2) == size(y, 1)
        pycall(casadi.mtimes, C, x, y)
    else
        pycall(casadi.times, C, x, y)
    end
end

## Comparisons
>=(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.ge, C, x, y)
>(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.gt, C, x, y)
<=(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.le, C, x, y)
<(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.lt, C, x, y)
==(x::C, y::Real) where {C<:CasadiSymbolicObject} = pycall(casadi.eq, C, x, y)

## Symbolic substitution
substitute(
    ex::Union{C,AbstractVector{C},AbstractMatrix{C}},
    vars::C,
    vals::Number,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))

substitute(
    ex::Union{C,AbstractVector{C},AbstractMatrix{C}},
    vars::AbstractVector{C},
    vals::AbstractVector,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))

substitute(
    ex::Union{C,AbstractVector{C},AbstractMatrix{C}},
    vars::AbstractMatrix{C},
    vals::AbstractMatrix,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))
