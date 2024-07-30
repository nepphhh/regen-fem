mkdir -p build
g++ -O3 -fopenmp -std=c++11 -Wno-return-type -fPIC -no-pie main.cpp -L sparselizard_linux64_staticlib/ -l sparselizard -pthread -l dl -I sparselizard_linux64_staticlib/headers -o build/slexe
build/slexe
paraview output.vtk