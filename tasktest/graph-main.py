import graph

g = graph.Graph()

g.add_node('a')
g.add_node('b')
g.add_node('c')
g.add_node('d')
g.add_node('e')
g.add_node('f')
g.add_node('g')
g.add_node('h')
g.add_node('i')
g.add_node('j')
g.add_node('k')
g.add_node('l')
g.add_node('m')
g.add_node('n')
g.add_node('o')
g.add_node('p')
g.add_node('q')
g.add_node('r1')
g.add_node('r2')
g.add_node('r3')
g.add_node('r4')
g.add_node('r5')
g.add_node('r6')
g.add_node('r7')

g.add_edge('a', 'b', 1)
g.add_edge('a', 'c', 3)
g.add_edge('a', 'd', 3)
g.add_edge('a', 'e', 4)
g.add_edge('b', 'f', 4)
g.add_edge('b', 'g', 3)
g.add_edge('c', 'h', 1)
g.add_edge('d', 'i', 2)
g.add_edge('e', 'j', 7)
g.add_edge('f', 'k', 6)
g.add_edge('g', 'l', 8)
g.add_edge('h', 'm', 6)
g.add_edge('h', 'n', 8)
g.add_edge('i', 'o', 7)
g.add_edge('j', 'p', 5)
g.add_edge('j', 'q', 5)
g.add_edge('k', 'r1', 1)
g.add_edge('l', 'r2', 1)
g.add_edge('m', 'r3', 1)
g.add_edge('n', 'r4', 1)
g.add_edge('o', 'r5', 1)
g.add_edge('p', 'r6', 1)
g.add_edge('q', 'r7', 1)

print('')
# g.remove_node('n')

print(g)

graph.bestfs(g, 'a')

print(g)
