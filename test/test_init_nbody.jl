const YEAR  = 365.242
const GNEWT = 39.4845/YEAR^2  # Units of MSUN*AU^3/YEAR^2
const NDIM  = 3
const third = 1./3.

include("../src/init_nbody.jl")

@testset "init_nbody" begin

elements = readdlm("elements.txt",',')

n_body = 4
t0 = 7257.93115525
jac_init     = zeros(Float64,7*n_body,7*n_body)
jac_init_num = zeros(BigFloat,7*n_body,7*n_body)
x,v = init_nbody(elements,t0,n_body,jac_init)
elements0 = copy(elements)
#dq = big.([1e-10,1e-5,1e-6,1e-6,1e-6,1e-5,1e-5])
dq = big.([1e-10,1e-8,1e-8,1e-8,1e-8,1e-8,1e-8])

#dq = big.([1e-15,1e-15,1e-15,1e-15,1e-15,1e-15,1e-15])
t0big = big(t0)
# Now, compute derivatives numerically:
for j=1:n_body
  for k=1:7
    elementsbig = big.(elements0)
    dq0 = dq[k]; if j==1 && k==1 ; dq0 = big(1e-15); end
    elementsbig[j,k] += dq0
    xp,vp = init_nbody(elementsbig,t0big,n_body)
    elementsbig[j,k] -= 2dq0
    xm,vm = init_nbody(elementsbig,t0big,n_body)
    for l=1:n_body, p=1:3
      i1 = (l-1)*7+p
      if k == 1
        j1 = j*7
      else
        j1 = (j-1)*7+k-1
      end
      jac_init_num[i1,  j1] = (xp[p,l]-xm[p,l])/dq0*.5
      jac1 = jac_init[i1,j1]; jac2 = jac_init_num[i1,j1]
      if abs(jac1-jac2) > 1e-4*abs(jac1+jac2) && abs(jac1+jac2) > 1e-14
        println(l," ",p," ",j," ",k," ",jac_init_num[i1,j1]," ",jac_init[i1,j1]," ",jac_init_num[i1,j1]/jac_init[i1,j1])
      end
      jac_init_num[i1+3,j1] = (vp[p,l]-vm[p,l])/dq0*.5
      jac1 = jac_init[i1+3,j1]; jac2 = jac_init_num[i1+3,j1]
      if abs(jac1-jac2) > 1e-4*abs(jac1+jac2) && abs(jac1+jac2) > 1e-14
        println(l," ",p+3," ",j," ",k," ",jac_init_num[i1+3,j1]," ",jac_init[i1+3,j1]," ",jac_init_num[i1+3,j1]/jac_init[i1+3,j1])
      end
    end
  end
  jac_init_num[j*7,j*7]=1.0
end

#println("Maximum jac_init-jac_init_num: ",maximum(abs.(jac_init-jac_init_num)))
println("Maximum jac_init-jac_init_num: ",maximum(abs.(asinh.(jac_init)-asinh.(jac_init_num))))
#@test isapprox(jac_init_num,jac_init)
@test isapprox(jac_init_num,jac_init;norm=maxabs)
end
