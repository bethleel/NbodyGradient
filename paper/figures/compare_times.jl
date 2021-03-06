rebound = readdlm("rebound_times.txt",',')
nbodygrad = readdlm("nbodygradient_times.txt",',')

using PyPlot

clf()
semilogy(nbodygrad[:,1],nbodygrad[:,2],label="NbodyGrad, no gradient",linestyle="dashed",c="b",linewidth=2)
semilogy(nbodygrad[:,1],nbodygrad[:,2],".",c="b",markersize=15)
semilogy(nbodygrad[:,1],nbodygrad[:,3],label="NbodyGrad, gradient",c="b",linewidth=2)
semilogy(nbodygrad[:,1],nbodygrad[:,3],".",c="b",markersize=15)
semilogy(rebound[:,1],rebound[:,2],label="Rebound, no gradient",linestyle="dashed",c="r",linewidth=2)
semilogy(rebound[:,1],rebound[:,2],".",c="r",markersize=15)
semilogy(rebound[:,1],rebound[:,3],label="Rebound, gradient",c="r",linewidth=2)
semilogy(rebound[:,1],rebound[:,3],".",c="r",markersize=15)
legend(loc="upper left")
xlabel("Number of planets",fontsize=20)
ylabel("Integration time [sec]",fontsize=20)
PyPlot.savefig("rebound_vs_nbodygradient.pdf",bbox_inches="tight")
