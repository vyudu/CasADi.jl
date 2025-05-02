## Indexing
Base.getindex(x::T, j::Union{Int,UnitRange{Int},Colon}) where {T <: CasadiSymbolicObject} = T(pygetitem(x.x, (1:length(x))[j] .- 1))

function Base.getindex(x::T, j1::Union{Int,UnitRange{Int},Colon}, j2::Union{Int,UnitRange{Int},Colon}) where {T <: CasadiSymbolicObject} 
    (m, n) = size(x)
    T(pygetitem(x.x, ((1:m)[j1 isa Int ? (j1:j1) : j1] .- 1, (1:n)[j2 isa Int ? (j2:j2) : j2] .- 1)))
end

function Base.setindex!(x::CasadiSymbolicObject, v::Number, j::Union{Int,UnitRange{Int},Colon}) 
    pysetitem(x.x, (1:length(x))[j isa Int ? (j:j) : j] .- 1, v)
    x
end

function Base.setindex!(
    x::CasadiSymbolicObject,
    v::Number,
    j1::Union{Int,UnitRange{Int},Colon},
    j2::Union{Int,UnitRange{Int},Colon},
)
    (m, n) = size(x)
    J1 = j1 isa Int ? (j1:j1) : j1
    J2 = j2 isa Int ? (j2:j2) : j2
    pysetitem(x.x, ((1:m)[j1 isa Int ? (j1:j1) : j1] .- 1, (1:n)[j2 isa Int ? (j2:j2) : j2] .- 1), v)
end

Base.lastindex(x::CasadiSymbolicObject) = length(x)
Base.lastindex(x::CasadiSymbolicObject, j::Int) = size(x, j)

## one, zero, zeros, ones
Base.one(::Type{C}) where {C<:CasadiSymbolicObject} = C(getproperty(casadi, Symbol(C)).eye(1))
Base.one(x::C) where {C<:CasadiSymbolicObject} =
    if size(x, 1) == size(x, 2)
        C(getproperty(casadi, Symbol(C)).eye(size(x, 1)))
    else
        throw(DimensionMismatch("multiplicative identity defined only for square matrices"))
    end

Base.zero(::Type{C}) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).zeros())
Base.zero(x::C) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).zeros(size(x)))

Base.ones(::Type{C}, j::Integer) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).ones(j))
Base.ones(::Type{C}, j1::Integer, j2::Integer) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).ones(j1, j2))

Base.zeros(::Type{C}, j::Integer) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).zeros(j))
Base.zeros(::Type{C}, j1::Integer, j2::Integer) where {C<:CasadiSymbolicObject} =
    C(getproperty(casadi, Symbol(C)).zeros(j1, j2))

## Size related operations
Base.size(x::CasadiSymbolicObject) = pyconvert(Tuple, x.size())

function Base.size(x::C, j::Integer) where {C<:CasadiSymbolicObject}
    if j == 1
        return pyconvert(Int, getproperty(casadi, Symbol(C)).size1(x))
    elseif j == 2
        return pyconvert(Int, getproperty(casadi, Symbol(C)).size2(x))
    else
        throw(DimensionMismatch("arraysize: dimension out of range"))
    end
end
Base.length(x::C) where {C<:CasadiSymbolicObject} = pyconvert(Int, getproperty(casadi, Symbol(C)).numel(x))

## Concatenations
Base.hcat(x::Vector{T}) where {T<:CasadiSymbolicObject} = T(casadi.hcat(x))
Base.vcat(x::Vector{T}) where {T<:CasadiSymbolicObject} = T(casadi.vcat(x))

## Matrix operations
Base.transpose(x::T) where {T <: CasadiSymbolicObject} = T(casadi.transpose(x))
Base.adjoint(x::CasadiSymbolicObject) = transpose(x)
Base.repeat(x::T, counts::Integer...) where {T <: CasadiSymbolicObject} = T(casadi.repmat(x, counts...))
Base.reshape(x::T, t::Tuple{Int,Int}) where {T <: CasadiSymbolicObject} = T(casadi.reshape(x, t))
Base.inv(x::T) where {T <: CasadiSymbolicObject} = T(casadi.inv(x))
Base.vec(x::T) where {T <: CasadiSymbolicObject} = T(casadi.vec(x))

# From vector to SX/MX
Base.convert(::Type{Τ}, V::AbstractVector{Τ}) where {Τ<:CasadiSymbolicObject} =
    casadi.vcat(pyrowlist(V))

# From matrix to SX/MX
Base.convert(::Type{Τ}, M::AbstractMatrix{Τ}) where {Τ<:CasadiSymbolicObject} =
    casadi.blockcat(pyrowlist(M))

# Convert SX/MX to vector
function Base.Vector(V::T) where {T <: CasadiSymbolicObject} 
    v = pyconvert(Vector, casadi.vertsplit(V))
    v = map(el -> T(Py(el)), v)
end

# Convert SX/MX to Matrix{SX/MX}
function Base.Matrix(M::T) where {T <: CasadiSymbolicObject} 
    m = casadi.blocksplit(M)
    m = reduce(vcat, pyconvert(Vector, m))
    m = map(el -> T(Py(el)), m)
    i, j = size(M)
    permutedims(reshape(m, (j, i)))
end

## Solve linear systems
Base.:\(A::Matrix{C}, b::Vector{C}) where {C<:CasadiSymbolicObject} =
    Vector(C(casadi.solve(C(A), C(b))))

Base.:\(A::AbstractMatrix{C}, b::AbstractMatrix{N}) where {C<:CasadiSymbolicObject, N<:Number} =
    Matrix(C(casadi.solve(C(A), C(b))))

Base.:\(A::AbstractMatrix{N}, b::AbstractMatrix{C}) where {C<:CasadiSymbolicObject, N<:Number} =
    Matrix(C(casadi.solve(C(A), C(b))))
