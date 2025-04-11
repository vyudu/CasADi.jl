for f in [:inv,
          :sqrt,
          :sin,
          :cos,
          :vec,
          :transpose]
   @eval begin
       Base.$f(x::T) where {T <: CasadiSymbolicObject} = pycall(casadi.$f, T, x)
   end
end

Base.size(x::CasadiSymbolicObject) = x.size()
Base.reshape(x::T, t::Tuple{Int,Int}) where {T<:CasadiSymbolicObject} =
    pycall(casadi.reshape, T, x, t)
