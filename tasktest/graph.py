import collections
import queue

class Graph:
    def __init__(self):
        self.nodes = set() 
        self.edges = collections.defaultdict(list)
        self.distances = {}
        self.visited = {}
        self.queue = queue.PriorityQueue()
        self.total_memory = 0
        self.path = []

    def add_node(self, value):
        self.nodes.add(value)

    def add_edge(self, from_node, to_node, distance):
        self.edges[from_node].append(to_node)
        self.distances[(from_node, to_node)] = distance

    def remove_node(self, value):
        self.nodes.remove(value)
        self.edges.pop(value)
        for i in self.edges:
            if value in self.edges[i]:
                self.edges[i].remove(value)

    def remove_edge(self, from_node, to_node):
        self.edge[from_node].remove(to_node)

    def clear_visiteds(self):
        self.visited = {}

    def add_path(self, from_node, to_node):
        self.path.append((from_node, to_node))

    def __str__(self):
        ret = ' '.join(self.nodes) + '\n'
        for i in self.edges:
            ret += i + ': ' + str(self.edges[i]) + '\n'
        ret += '\n'
        for i in self.path:
            ret += str(i) + '\n' 
        return ret

def dfs(g, v):
    g.visited[v] = 1
    print('\ndfs de :', v)
    allNodes = set(g.nodes)
    neighbors = g.edges[v]
    print(neighbors)
    for i in neighbors:
        if i in g.visited:
            print(i, 'ja visitado')
        else:
            print('Visitando', i, 'de', v)
            dfs(g, i)
            print('')

def bfs(g, v):
    d = collections.deque()
    d.append(v)
    while len(d): 
        e = d.popleft()
        g.visited[e] = 1
        print('Visitando', e)
        for i in g.edges[e]:
            if ~(i in g.visited):
                d.append(i)
            else:
                print(i, 'ja visitado')

def bestfs(g, v):
    print('\nFila: ', g.queue.qsize())
    g.visited[v] = 1
    neighbors = g.edges[v]
    print('Neighbors:', neighbors)
    for i in neighbors:
        print('Inserindo:', i, '-', g.distances[(v, i)])
        g.queue.put((g.distances[(v, i)], v, i))
    
    if g.queue.qsize() > 0:
        e = g.queue.get()
    else:
        return
    if e[2] in g.visited:
        return
    else:
        print('Path:', e[1], e[2])
        g.add_path(e[1], e[2])
        print('Visitando:', e)
        g.total_memory += e[0]
        print('Memoria total:', g.total_memory)
        bestfs(g, e[2])
