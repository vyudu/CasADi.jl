## Extra functions
substitute(
    ex::Union{C, AbstractVector{C}, AbstractMatrix{C}},
    vars::C,
    vals::Number,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))

substitute(
    ex::Union{C, AbstractVector{C}, AbstractMatrix{C}},
    vars::AbstractVector{C},
    vals::AbstractVector,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))

substitute(
    ex::Union{C,AbstractVector{C},AbstractMatrix{C}},
    vars::AbstractMatrix{C},
    vals::AbstractMatrix,
) where {C<:CasadiSymbolicObject} = casadi.substitute(C(ex), C(vars), C(vals))
