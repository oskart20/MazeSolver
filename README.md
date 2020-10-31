# MazeSolver

Utilizes a simple breadth-first search algorithmto solve mazes of almost any size, although running time might become an issue.
Takes mazes in form of PNG images in which the start is in the first row and the end is the last row respectively.
A white pixel acts as a path, a black pixel as wall.

Example images taken from https://github.com/mikepound/mazesolving/tree/master/examples.

## How to run the script:
To run the script you obvouisly need to have [julia](https://julialang.org/downloads/) already installed.
Use `julia mazeScript.jl "<path_to_png-maze>"` to run the script on a maze of your choice.
The solved maze will be stored under `"<path_to_png-maze>_solved.png"`.

## Rough benchmarks:
run on MacBook Pro 2020 with 2,3 GHz Quad-Core Intel Core i7 and 16 GB RAM
using Julia Version 1.5.2

small.png
Time to create maze: 0.235685 s
Time to solve maze: 0.094201 s

normal.png
Time to create maze: 0.233094 s
Time to solve maze: 0.093308 s

perfect2k.png
Time to create maze: 1.985041 s
Time to solve maze: 148.910746 s

perfect4k.png
Time to create maze: 7.673843 s
Time to solve maze: about 48 min
