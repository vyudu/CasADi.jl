struct Opti
    py::Py
end

struct OptiSol
    py::Py
end

function Opti()
    Opti(casadi.Opti())
end

function variable!(opti::Opti, dims...)
    MX(opti.py._variable(dims...))
end

function parameter!(opti::Opti, dims...) 
    MX(opti.py._parameter(dims...))
end

function set_value!(opti::Opti, p::MX, val) 
    opti.py.set_value(p, val)
end

function set_initial!(opti::Opti, x::MX, val) 
    opti.py.set_initial(x, val)
end

function subject_to!(opti::Opti, expr::MX)
    opti.py._subject_to(expr)
end

function minimize!(opti::Opti, expr::MX) 
    opti.py.minimize(expr)
end

function solver!(opti::Opti, solver::String, plugin_options::Dict = Dict(), solver_options::Dict = Dict())
    for (k, v) in solver_options
        v isa Dict && (solver_options[k] = PyDict(v))
    end
    opti.py.solver(solver, PyDict(plugin_options), PyDict(solver_options))
end

function solve(opti::Opti) 
    psol = opti.py.solve()
    OptiSol(psol)
end

function value(sol::OptiSol, expr::MX) 
    pyconvert(Any, sol.py.value(expr))
end

function debug_value(opti::Opti, expr::MX)
    pyconvert(Any, opti.debug.value(expr))
end
