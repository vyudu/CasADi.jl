## Unary operations
-(x::C) where {C<:CasadiSymbolicObject} = C(casadi.minus(0, x))
Base.sqrt(x::T) where {T<:CasadiSymbolicObject} = T(casadi.sqrt(x))
Base.sin(x::T) where {T<:CasadiSymbolicObject} = T(casadi.sin(x))
Base.cos(x::T) where {T<:CasadiSymbolicObject} = T(casadi.cos(x))
Base.sincos(x::T) where {T <: CasadiSymbolicObject} = T(sin(x)), T(cos(x))
Base.sinc(x::T) where {T <: CasadiSymbolicObject} = T(sin(x) / x)
Base.abs(x::T) where {T<:CasadiSymbolicObject} = T(casadi.fabs(x))

## Binary operations
+(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.plus(x, y))
-(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.minus(x, y))
/(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.mrdivide(x, y))
^(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.power(x, y))
^(x::C, y::Integer) where {C<:CasadiSymbolicObject} = C(casadi.power(x, y))
\(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.solve(x, y))
×(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.cross(x, y))

function *(x::C, y::Real) where {C<:CasadiSymbolicObject}
    v = if size(x, 2) == size(y, 1)
        casadi.mtimes(x, y)
    else
        casadi.times(x, y)
    end
    C(v)
end

## Comparisons
>=(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.ge(x, y))
>(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.gt(x, y))
<=(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.le(x, y))
<(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.lt(x, y))
==(x::C, y::Real) where {C<:CasadiSymbolicObject} = C(casadi.eq(x, y))

## Symbolic substitution
function substitute(ex::Union{C, AbstractVector{C}, AbstractMatrix{C}}, vars, vals)  where {C <: CasadiSymbolicObject}
    v = if (vars isa AbstractMatrix{C} && vals isa AbstractMatrix) || (vars isa AbstractVector{C}) || (vars isa C && vals isa Number)
        casadi.substitute(C(ex), C(vars), C(vals))
    else
        error()
    end
    C(v)
end
