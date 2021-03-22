# MazeSolver
![Maze](https://github.com/oskart20/MazeSolver/blob/main/Examples/solved_example.png?raw=true "Solved maze")

Utilizes the simple breadth-first search algorithm or the a-star search algorithm (for the optimal path) to solve mazes of almost any size, although running time might become an issue.
Takes mazes in form of PNG images in which the start is in the first row and the end is the last row respectively.
A white pixel symbolises a path, a black pixel a wall.

Example images taken from https://github.com/mikepound/mazesolving/tree/master/examples.

## How to run the script:
To run the script you obvouisly need to have [julia](https://julialang.org/downloads/) already installed.
The required packages are [DataStructures](https://github.com/JuliaCollections/DataStructures.jl) and [Images](https://github.com/JuliaImages/Images.jl).
Use `julia MazeSolver.jl "<path_to_png-maze>"` to run the script using breadth-first search.
Use `julia MazeSolver.jl "<path_to_png-maze>" true` to run the script using a-star search.
The solved maze will be stored under `"<path_to_png-maze>_solved.png"`.

## Rough benchmarks:
breadth-first search run on MacBook Pro 2020 with 2,3 GHz Quad-Core Intel Core i7 and 16 GB RAM
using Julia Version 1.5.2

#### small.png - 15x15

number of nodes: 37

length of the solution: 45

Time to create and analyse maze: 0.154597 s

Time to solve maze: 0.214058 s

#### normal.png - 41x41

number of nodes: 325

length of the solution: 309

Time to create and analyse maze: 0.155865 s

Time to solve maze: 0.220333 s

#### perfect2k.png - 2001x2001

number of nodes: 716516

length of the solution: 24669

Time to create and analyse maze: 0.786624 s

Time to solve maze: 0.556505 s

#### perfect4k.png - 4001x4001

number of nodes: 2865504

length of the solution: 62545

Time to create and analyse maze: 2.788537 s

Time to solve maze: 1.598567 s

#### perfect15k.png - 15001x15001

number of nodes: 40309838

length of the solution: 380467

Time to create and analyse maze: 82.092302 s

Time to solve maze: 108.000770 s
