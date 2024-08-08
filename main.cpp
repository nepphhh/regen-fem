// This code simulates the Stokes flow of a viscous fluid (water) in a microvalve.
// Reynold's number rho*v*L/mu is very low so that the inertia terms can be neglected.
// The fluid is considered incompressible.
//
// This code can be validated with analytical solutions of a flow between two
// infinite parallel plates with a thin gap. Only the geometry has to be adapted.


#include "sparselizard.h"


using namespace sl;

int main(void)
{
    // Load mesh:    
    mesh mymesh("chamber.msh");
    mymesh.scale(0.0254, 0.0254, 0.0254); // convert from inches to meters

    // Define the physical regions that will be used:
    int fluid = 399, solid = 400, inlet = 401, outlet = 402, top = 403, bottom = 404;
    int interior = 405, exterior = 406, walls = 407, symmetry1 = 408, symmetry2 = 409; 
    int cyl = 410, conv = 411, throat = 412, nozzle = 413;   
    int all = selectunion({fluid,solid});
    
    // Dynamic viscosity of water [Pa.s]
    parameter mu;
    mu|fluid = 8.9e-4;

    // Density [kg/m3] (water, aluminum)
    parameter rho;
    rho|fluid = 1000;
    rho|solid = 2700; 

    // Thermal conductivity [W.m/K]
    parameter k;
    k|fluid = 0.6;
    k|solid = 240;

    // Thermal capacities [J.kg/K]
    parameter Cp;
    Cp|fluid = 2e3;
    Cp|solid = 0.89e3;

    // Thermal diffusivity [m2/s]
    parameter alpha;
    alpha|all = k/Cp/rho;
    
    // Field v is the flow velocity [in/s].
    // Field p is the relative pressure [Pa].
    // Field T is the temperature [K].
    field v("h1xyz"), p("h1"), T("h1");
    v.setorder(all, 2);
    p.setorder(all, 1);
    T.setorder(all, 2);
    
    // Force the flow velocity to 0 at the solid interface (& within the solid):
    v.setconstraint(solid);
    v.setconstraint(walls);
    
    // Set pressures [Pa]
    p.setconstraint(inlet, 0.03e6); // 5 psi
    p.setconstraint(outlet, 0);    
    
    // Define the weak formulation of the Stokes flow problem.
    // The strong form can be found at https://en.wikipedia.org/wiki/Stokes_flow
    formulation viscousflow;
    viscousflow += integral(fluid, predefinedstokes(dof(v), tf(v), dof(p), tf(p), mu, rho, 0, 0) );	
    viscousflow.solve();
    
    // Write the p and v fields to file:
    p.write(all, "p.vtk", 1);
    v.write(all, "v.vtk", 2);
    
    // Output the flowrate for a unit width:
    // double flowrate = (-normal(fluid)*v).integrate(inlet, 4);
    // std::cout << std::endl << "Flowrate for a unit width: " << flowrate << " m^3/s" << std::endl;
    
    // Temperature in
    T.setconstraint(inlet, 270);

    // Warm everything initally
    T.setvalue(all, 270);

    // Timestep and end time for the simulation:
    double ts = 0.1, tend = 49.99;
    // Tuning factor for the stabilization:
    double delta = 0.1;

    // Define the weak formulation of thermal advection diffusion
    formulation thermoad;

    thermoad += integral(all, predefinedadvectiondiffusion(dof(T), tf(T), v, alpha, 1.0, 1.0, true));
    thermoad += integral(cyl, -1e2*tf(T));
    thermoad += integral(conv, -3e2*tf(T));
    thermoad += integral(throat, -1e3*tf(T));
    thermoad += integral(nozzle, -5e1*tf(T));
    thermoad += integral(selectunion({exterior,top,bottom,symmetry1,symmetry2}), 0*tf(T)); // radiation surfaces
    thermoad += integral(all, predefinedstabilization("iso", delta, T, v, 0.0, 0.0));
    // thermoad += periodicitycondition(symmetry2, symmetry1, T, {0,0,0}, {0,360/20,0}, 1.0, 1);
    // thermoad += periodicitycondition(symmetry2, symmetry1, v, {0,0,0}, {0,360/20,0}, 1.0, 1);

    genalpha genaiso(thermoad, vec(thermoad), vec(thermoad), 1, {true,true,true,true});
    genaiso.setparameter(0.75);
    settime(0);
    while (gettime() < tend) {
        genaiso.next(ts);
        std::cout<<gettime()<<std::endl;
    }

    // Write the T and alpha fields to file;
    T.write(all, "T.vtk", 2);
    alpha.write(all, "alpha.vtk", 1);
}
