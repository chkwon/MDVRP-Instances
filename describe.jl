using Printf 
using Infiltrator

files = readdir("dat")

struct Customer
    idx::Int
    x::Float64
    y::Float64
    d::Int
    q::Int
    f::Int
    a::Int
end

struct Depot 
    idx::Int
    x::Float64
    y::Float64
end

@printf "%4s : %4s %3s %3s %3s %3s %3s %7s %7s \n" "inst" "type" "m" "n" "t" "D" "Q" "servic" "loads"
println("-----------------------------------------------")
for f in files
    dat_file = joinpath("dat", f)
    
    lines = readlines(dat_file)
    type, m, n, t = parse.(Int, split(lines[1]))

    constraints = [parse.(Int, split(l)) for l in lines[2:1+t]]
    durations = [constraints[i][1] for i in 1:length(constraints)]
    capacities = [constraints[i][2] for i in 1:length(constraints)]

    customer_data = lines[1+t+1:1+t+n]
    customers = Customer[]
    for c in customer_data 
        ss = split(c)
        cc = Customer(
            parse(Int, ss[1]), 
            parse(Float64, ss[2]), 
            parse(Float64, ss[3]), 
            parse(Int, ss[4]),
            parse(Int, ss[5]),
            parse(Int, ss[6]), 
            parse(Int, ss[7])
        )
        push!(customers, cc)
    end

    depot_data = lines[1+t+n+1:end]
    depots = Depot[]
    for d in depot_data 
        ss = split(d)
        dd = Depot(
            parse(Int, ss[1]), 
            parse(Float64, ss[2]), 
            parse(Float64, ss[3])
        )
        push!(depots, dd)
    end

    service_times = [c.d for c in customers]
    demands = [c.q for c in customers]

    @printf "%4s : %4d %3d %3d %3d %3d %3d %3d~%3d %3d~%3d \n" f type m n t maximum(durations) maximum(capacities) minimum(service_times) maximum(service_times) minimum(demands) maximum(demands)
end

