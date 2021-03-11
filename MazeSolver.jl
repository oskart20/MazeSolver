#!/bin/dev/env julia
module MazeSolver
#Pkg.add("DataStructures")
#Pkg.add("Images")
using Images
using DataStructures

function getstart(img, h, w)
	for j = 1:w
		if img[1, j].r > 0.5
			return (1, j)
		end
	end
	throw(DomainError(img, "maze must have a white pixel in first row"))
end

function getend(img, h, w)
	for j = 1:w
		if img[h, j].r > 0.5
			return (h, j)
		end
	end
	throw(DomainError(img, "maze must have a white pixel in last row"))
end

function checkNeighbors(maze_map, index, h, w)
	neighbors = Char[]
	if index[1] > 1 && maze_map[index[1]-1, index[2]] != false
		push!(neighbors, 'N')
	end
	if index[2] < w && maze_map[index[1], index[2]+1] != false
		push!(neighbors, 'E')
	end
	if index[1] < h && maze_map[index[1]+1, index[2]] != false
		push!(neighbors, 'S')
	end
	if index[2] > 1 && maze_map[index[1], index[2]-1] != false
		push!(neighbors, 'W')
	end
	num = length(neighbors)
	return num, neighbors
end

function checkChar(char, array)
	length(filter(x -> x == char, array)) >= 1
end

function getNeighbors(links, maze_map, index, h, w)
	neighbors::Array{Tuple{Int64,Int64},1} = []
	if checkChar('N', links)
		offset = 0
		while index[1] - (1 * (offset + 1)) > 0
			if maze_map[index[1]-(1*(offset+1)), index[2]] isa Bool &&
					maze_map[index[1]-(1*(offset+1)), index[2]]
				offset += 1
			elseif !(maze_map[index[1]-(1*(offset+1)), index[2]] isa Bool)
				push!(neighbors, (index[1] - (1 * (offset + 1)), index[2]))
				break
			end
		end
	end
	if checkChar('E', links)
		offset = 0
		while index[2] + (1 * (offset + 1)) <= w
			if maze_map[index[1], index[2]+(1*(offset+1))] isa Bool &&
					maze_map[index[1], index[2]+(1*(offset+1))]
				offset += 1
			elseif !(maze_map[index[1], index[2]+(1*(offset+1))] isa Bool)
				push!(neighbors, (index[1], index[2] + (1 * (offset + 1))))
				break
			end
		end
	end
	if checkChar('S', links)
		offset = 0
		while index[1] + (1 * (offset + 1)) <= h
			if maze_map[index[1]+(1*(offset+1)), index[2]] isa Bool &&
					maze_map[index[1]+(1*(offset+1)), index[2]]
				offset += 1
			elseif !(maze_map[index[1]+(1*(offset+1)), index[2]] isa Bool)
				push!(neighbors, (index[1] + (1 * (offset + 1)), index[2]))
				break
			end
		end
	end
	if checkChar('W', links)
		offset = 0
		while index[2] - (1 * (offset + 1)) > 0
			if maze_map[index[1], index[2]-(1*(offset+1))] isa Bool &&
					maze_map[index[1], index[2]-(1*(offset+1))]
				offset += 1
			elseif !(maze_map[index[1], index[2]-(1*(offset+1))] isa Bool)
				push!(neighbors, (index[1], index[2] - (1 * (offset + 1))))
				break
			end
		end
	end
	return neighbors
end

function analyse_maze(img)
	maze_map = Any[]
	h, w = size(img)
	Startnode = getstart(img, h, w)
	Endnode = getend(img, h, w)
	counter = 0
	for j in CartesianIndices(img)
		if img[j].r <= 0.5
			push!(maze_map, false)
		elseif img[j].r > 0.5
			push!(maze_map, true)
			counter += 1
		end
	end
	maze_map = reshape(maze_map, (h, w))
	maze_map[Startnode[1], Startnode[2]] = 5
	maze_map[Endnode[1], Endnode[2]] = 6
	for i in CartesianIndices((2:h-1, 2:w-1))
		if maze_map[i[1], i[2]] != false
			num, neighbors = checkNeighbors(maze_map, (i[1], i[2]), h, w)
			if neighbors == ['N', 'S'] || neighbors == ['E', 'W']
				maze_map[i[1], i[2]] = true
			elseif num >= 1
				maze_map[i[1], i[2]] = num + 1
			elseif num == 0
				maze_map[i[1], i[2]] = false
			end
		end
	end
	println("	number of path tiles: " * string(counter))
	nodes = []
	for k in CartesianIndices(maze_map)
		if maze_map[k[1], k[2]] >= 2
			push!(nodes, (k[1], k[2]))
		end
	end
	println("	number of nodes :" * string(length(nodes)))
	dict = Dict{String,Array{Tuple{Int64,Int64},1}}()
	for a in nodes
		neighbors = getNeighbors(checkNeighbors(maze_map, a, h, w)[2],
			maze_map, a, h, w)
		maze_map[a[1], a[2]] = neighbors
	end
	print("took ")
	return maze_map, nodes, Startnode, Endnode
end

function unfoldpath(lastnode, startnode, maze)
	path = Array{Tuple{Int64,Int64},1}()
	current = lastnode
	while current != startnode
		if ((current[1] - maze[current][1]) == 0)
			if current[2] - maze[current][2] > 0
				# due west
				offset = (0, -1)
			else
				# due east
				offset = (0, 1)
			end
		else
			if current[1] - maze[current][1] > 0
				# due north
				offset = (-1, 0)
			else
				# due south
				offset = (1, 0)
			end
		end
		factor = 0
		while (current[1] + (offset[1] * factor),
			current[2] + (offset[2] * factor)) != maze[current]
			push!(path, (current[1] + (offset[1] * factor),
				current[2] + (offset[2] * factor)))
			factor += 1
		end
		current = maze[current]
	end
	push!(path, current)
	return path
end

function solve(maze_map, startnode::Tuple{Int64,Int64},
			endnode::Tuple{Int64,Int64})
	dict = Dict{Tuple{Int64,Int64},Tuple{Int64,Int64}}()
	visited = Set{Tuple{Int64,Int64}}()
	push!(visited, startnode)
	q = Queue{Tuple{Int64,Int64}}()
	dict[startnode] = startnode
	enqueue!(q, startnode)
	while !isempty(q)
		vertex = dequeue!(q)
		if vertex == endnode
			return unfoldpath(endnode, startnode, dict)
		end
		for edge in maze_map[vertex[1], vertex[2]]
			if !(edge in visited)
				dict[edge] = vertex
				push!(visited, edge)
				enqueue!(q, edge)
			end
		end
	end
end

function colourpath(path, painted)
	number = 1
	for l in result
		painted[l[1], l[2]] = RGB(1.0 * (number / length(result)),
			1.0 - 1.0 * (number / length(result)),
			0.75 - 0.5 * (number / length(result)))
		number += 1
	end
	return painted
end

if (isfile(ARGS[1]))
	filepath = ARGS[1]
	println(filepath)
else
	println("couldn't load " * string(ARGS[1]))
	exit()
end

img = RGB.(load(filepath))

println("analysing maze ... ")
@time maze_map, nodes, startnode, endnode = analyse_maze(img)
reshape(maze_map, size(img))
print("solved maze in ")
@time result = solve(maze_map, startnode, endnode)
println("length of the solution: " * string(length(result)))

save(string(split(filepath, ".")[1] * "_solved.png"), colourpath(result, copy(img)))
println("stored maze at: " * string(split(filepath, ".")[1] * "_solved.png"))
end
