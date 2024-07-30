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

    // Define the physical regions that will be used:
    int fluid = 399, solid = 400, outlet = 401, inlet = 402, top = 403, bottom = 404;
    int interior = 405, exterior = 406, walls = 407, symmetry = 408;    
    int all = selectunion({fluid,solid});
    
    // Dynamic viscosity of water [Pa.s] and density [kg/m3]:
    double mu = 8.9e-4, rho = 1000;
    
    // Field v is the flow velocity. It uses nodal shape functions "h1" with two components.
    // Field p is the relative pressure.
    field v("h1xyz"), p("h1");
    
    // Force the flow velocity to 0 at the solid interface (& at the solid):
    v.setconstraint(solid);
    v.setconstraint(walls);
    
    // Set pressures (pascals)
    p.setconstraint(inlet, 3.5e6);
    p.setconstraint(outlet, 3.45e6);
    
    // Use an order 1 interpolation for p and 2 for v on the fluid region:
    p.setorder(all, 1);
    v.setorder(all, 2);
    
    // Define the weak formulation of the Stokes flow problem.
    // The strong form can be found at https://en.wikipedia.org/wiki/Stokes_flow
    formulation viscousflow;

    viscousflow += integral(fluid, predefinedstokes(dof(v), tf(v), dof(p), tf(p), mu, rho, 0, 0) );	
    
    // Generate, solve and save:
    viscousflow.solve();
    
    // Write the p and v fields to file:
    p.write(all, "p.vtk", 1);
    v.write(all, "v.vtk", 2);
    
    // Output the flowrate for a unit width:
    // double flowrate = (-normal(fluid)*v).integrate(inlet, 4);
    // std::cout << std::endl << "Flowrate for a unit width: " << flowrate << " m^3/s" << std::endl;
    
}
