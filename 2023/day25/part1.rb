#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def bfs_graph_path(graph, start, goal)
  return [start] if start == goal
  visited = { start => true }
  previous = {}
  queue = [start]

  until queue.empty?
    curr = queue.shift
    graph[curr].each do |neighbor|
      next if visited[neighbor]
      visited[neighbor] = true
      previous[neighbor] = curr
      queue << neighbor
      if neighbor == goal
        path = []
        node = goal
        while node
          path.unshift(node)
          node = previous[node]
        end
        return path
      end
    end
  end

  nil
end

Utils.time {
  YEAR = 2023
  DAY = 25
  LEVEL = 1

  graph = Hash.new { |h, k| h[k] = [] }
  Utils.read_lines('day25-sample-input.txt').each do |line|
    from, targets = line.split(':')
    targets.split.each do |to|
      graph[from] << to
      graph[to] << from
    end
  end

  nodes = graph.keys
  edge_counts = Hash.new(0)

  nodes.shuffle.first(150).zip(nodes.shuffle.first(150)).each do |from, to|
    next if from == to
    path = bfs_graph_path(graph, from, to)
    next unless path
    path.each_cons(2) { |pair| edge_counts[pair.sort] += 1 }
  end

  edge_counts.sort_by { |_pair, count| count }.last(3).each do |(from, to), _count|
    graph[from].delete(to)
    graph[to].delete(from)
  end

  start_node = nodes.first
  visited = { start_node => true }
  queue = [start_node]  
  until queue.empty?
    curr = queue.shift
    graph[curr].each do |neighbor|
      unless visited[neighbor]
        visited[neighbor] = true
        queue << neighbor
      end
    end
  end
  seen = visited.size
  sum = (graph.keys.size - seen) * seen

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.151239675 secondes
