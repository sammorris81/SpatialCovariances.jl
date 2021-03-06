using SpatialCorrelation
using Distances

# blas_set_num_threads(1)
ns = 300

s = hcat(linspace(1, 10, ns), linspace(1, 10, ns))
d = fill(0.0, ns, ns)
for j = 1:ns, i = 1:ns
  d[i, j] = Distances.euclidean(vec(s[i, :]), vec(s[j, :]))
end

σ² = 4
ϕ = 3
Σ = exponential(d, σ², ϕ)
ϕ = 5
exponential!(Σ, d, σ², ϕ)

ν = 0.7
ϕ = 2
Σ = matern(d, σ², ν, ϕ)
ν = 0.6
matern!(Σ, d, σ², ν, ϕ)

Σ = spherical(d, σ², ϕ)
spherical!(Σ, d, σ², ϕ)

@time for i = 1:500
  Σ = exponential(d, σ², ϕ)
end

@time for i = 1:500
  exponential!(Σ, d, σ², ϕ)
end

# Macbook Air, 2013
# julia exponential: 2.187 seconds for 500 iterations
# julia exponential!: 1.909 seconds for 500 iterations
# R: 2.124 seconds for 500 iterations

@time for i = 1:500
  Σ = matern(d, σ², ν, ϕ)
end

@time for i = 1:500
  matern!(Σ, d, σ², ν, ϕ)
end

# Macbook Air, 2013
# julia matern: 29.447 seconds for 500 iterations
# julia matern!: 28.658 seconds for 500 iterations
# R: 35.892 seconds for 500 iterations


