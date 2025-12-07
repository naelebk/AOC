require "set"
require "pqueue"
require "net/http"
require "uri"
require "openssl"

COLOR = {
  red: "\033[1;31m",
  green: "\033[1;32m",
  yellow: "\033[1;33m",
  blue: "\033[1;34m",
  cyan: "\033[1;36m",
  purple: "\033[1;35m",
  nc: "\033[0m"
}

COOKIE_PATH='/home/nael/Documents/AOC/.cookie.txt'

module Utils
  #################################
  # Lecture & Parsing
  #################################

  # Lit toutes les lignes d’un fichier en supprimant le "\n".
  #
  # @param path [String] chemin du fichier
  # @return [Array<String>] tableau des lignes du fichier
  #
  # @example
  #   # fichier "input.txt" :
  #   #  A
  #   #  B
  #   Utils.read_lines("input.txt")
  #   # => ["A", "B"]
  def self.read_lines(path)
    File.readlines(path, chomp: true)
  end

  # Extrait tous les entiers d'une chaîne de caractères.
  #
  # @param line [String] La chaîne contenant un ou plusieurs entiers.
  # @return [Array<Integer>] Liste des entiers trouvés dans la chaîne (peut être vide).
  #
  # @example
  #   Utils.parse_ints("x=10, y=-5, z=3")
  #   # => [10, -5, 3]
  #
  # @example
  #   Utils.parse_ints("aucun nombre ici")
  #   # => []
  def self.parse_ints(line)
    line.scan(/-?\d+/).map(&:to_i)
  end


  # Lit un fichier et convertit en entiers.
  #
  # @param path [String] chemin du fichier
  # @param sep [String, nil] séparateur (nil = une valeur par ligne)
  # @return [Array<Integer>, Array<Array<Integer>>] tableau d’entiers ou tableau de tableaux
  #
  # @example
  #   # fichier "nums.txt" :
  #   #  1
  #   #  2
  #   Utils.read_numbers("nums.txt")
  #   # => [1, 2]
  #
  #   # fichier "pairs.txt" :
  #   #  1,2
  #   #  3,4
  #   Utils.read_numbers("pairs.txt", ",")
  #   # => [[1, 2], [3, 4]]
  def self.read_numbers(path, sep = nil)
    read_lines(path).map do |line|
      sep ? line.split(sep).map(&:to_i) : line.to_i
    end
  end

  # Lit un fichier avec 2 colonnes séparées par espaces.
  #
  # @param path [String] chemin du fichier
  # @parem sep [String] le délimiteur de colonnes (par défaut à un espace)
  # @return [Array<Array<Integer>>] [colonne_gauche, colonne_droite]
  #
  # @example
  #   # fichier :
  #   #  1 4
  #   #  2 5
  #   Utils.read_two_columns("pairs.txt")
  #   # => [[1, 2], [4, 5]]
  def self.read_two_columns(path, sep = ' ')
    left, right = read_lines(path).map { |line| line.split(sep).map(&:to_i) }.transpose
    [left, right]
  end

  # Lit un fichier avec plusieurs colonnes séparées par espaces.
  #
  # @param path [String] chemin du fichier
  # @parem sep [String] le délimiteur de colonnes (par défaut à un espace)
  # @return [Array<Array<Integer>>] [colonne_1, ..., colonne_n]
  #
  # @example
  #   # fichier :
  #   #  123 328  51 64 
  #   #   45 64  387 23 
  #   #    6 98  215 314
  #   Utils.read_columns("pairs.txt")
  #   # => [[[1, 2, 3], [4, 5], [6]], [[3, 2, 8], [6, 4], [9, 8]], [[5, 1], [3, 8, 7], [2, 1, 5]], [[6, 4], [2, 3], [3, 1, 4]]]
  def self.read_columns(path, sep = ' ')
    read_lines(path).map do |line|
      line.split(sep).map do |word|
        if word.length != 1 || word.chars.all? { |c| c.match?(/\d/) }
          digits(word)
        else
          word
        end
      end
    end.transpose
  end

  # Lit un fichier comme une matrice de caractères.
  #
  # @param path [String] chemin du fichier
  # @return [Array<Array<String>>] matrice de caractères
  #
  # @example
  #   # fichier :
  #   #  ABC
  #   #  DEF
  #   Utils.read_matrix("grid.txt")
  #   # => [["A","B","C"], ["D","E","F"]]
  def self.read_matrix(path)
    read_lines(path).map(&:chars)
  end

  # Cette fonction retourne la taille de la grille (hauteur, largeur)
  #
  # @param [Array<Array<String>>] matrice de caractères
  # @return [Array<Integer>] un tableau contenant la hauteur (height) et la largeur (width) de la grille

  # @example
  #   # grid = [["A","B","C"], ["D","E","F"]]
  #   # irb(main):003:0> height, width = Utils.get_size_of_grid(grid)
  #   # => [2, 3]
  #   # irb(main):004:0> height
  #   # => 2
  #   # irb(main):005:0> width
  #   # => 3
  def self.get_size_of_grid(grid)
    [
      grid.size, # height
      grid[0].size # width
    ]
  end

  # Lit un CSV simple.
  #
  # @param path [String] chemin du fichier
  # @param sep [String] séparateur (par défaut ",")
  # @return [Array<Array<String>>] tableau de lignes
  #
  # @example
  #   # fichier :
  #   #  a,b,c
  #   #  d,e,f
  #   Utils.read_csv("data.csv")
  #   # => [["a","b","c"], ["d","e","f"]]
  def self.read_csv(path, sep = ",")
    read_lines(path).map { |line| line.split(sep) }
  end

  # Découpe un fichier en blocs de lignes séparées par des lignes vides.
  #
  # @param path [String] chemin du fichier
  # @return [Array<Array<String>>] tableau de blocs
  #
  # @example
  #   # fichier :
  #   #  A
  #   #
  #   #  B
  #   #  C
  #   Utils.read_blocks("blocks.txt")
  #   # => [["A"], ["B", "C"]]
  def self.read_blocks(path)
    read_lines(path).slice_before("").map { |block| block.reject(&:empty?) }.to_a
  end

  #################################
  # Tableaux
  #################################

  # Transforme un fichier clé: valeur en hash.
  #
  # @param path [String] chemin du fichier
  # @param sep [String] séparateur (par défaut ":")
  # @return [Hash{String => String}]
  #
  # @example
  #   # fichier :
  #   #  a:1
  #   #  b:2
  #   Utils.read_key_values("map.txt")
  #   # => {"a"=>"1", "b"=>"2"}
  def self.read_key_values(path, sep = ":")
    read_lines(path).map { |line| line.split(sep, 2) }.to_h
  end

  # Lit une liste d’entiers séparés par sep sur une seule ligne.
  #
  # @param path [String]
  # @param sep [String] séparateur (par défaut ",")
  # @return [Array<Integer>]
  #
  # @example
  #   # fichier :
  #   #  1,2,3
  #   Utils.read_int_list("list.txt")
  #   # => [1,2,3]
  def self.read_int_list(path, sep = ",")
    read_lines(path).first.split(sep).map(&:to_i)
  end

  # Somme d’un tableau.
  #
  # @param array [Array<Numeric>]
  # @return [Numeric]
  #
  # @example
  #   Utils.sum([1,2,3])
  #   # => 6
  def self.sum(array)
    array.reduce(0, :+)
  end

  # Produit d’un tableau.
  #
  # @param array [Array<Numeric>]
  # @return [Numeric]
  #
  # @example
  #   Utils.product([2,3,4])
  #   # => 24
  def self.product(array)
    array.reduce(1, :*)
  end

  # Compte les occurrences de chaque élément.
  #
  # @param array [Array]
  # @return [Hash{Object => Integer}]
  #
  # @example
  #   Utils.count_occurrences(["a","b","a"])
  #   # => {"a"=>2,"b"=>1}
  def self.count_occurrences(array)
    array.tally
  end

  # Nombre d’éléments distincts.
  #
  # @param array [Array]
  # @return [Integer]
  #
  # @example
  #   Utils.uniq_count([1,2,2,3])
  #   # => 3
  def self.uniq_count(array)
    array.uniq.size
  end

  # Découpe un tableau en sous-tableaux de taille fixe.
  #
  # @param array [Array]
  # @param size [Integer]
  # @return [Array<Array>]
  #
  # @example
  #   Utils.chunks([1,2,3,4,5], 2)
  #   # => [[1,2],[3,4],[5]]
  def self.chunks(array, size)
    array.each_slice(size).to_a
  end

  # Fenêtre glissante.
  #
  # @param array [Array]
  # @param size [Integer]
  # @return [Array<Array>]
  #
  # @example
  #   Utils.sliding_window([1,2,3,4], 3)
  #   # => [[1,2,3],[2,3,4]]
  def self.sliding_window(array, size)
    array.each_cons(size).to_a
  end

  # Permutations du tableau.
  #
  # @param array [Array]
  # @return [Array<Array>]
  #
  # @example
  #   Utils.permutations([1,2])
  #   # => [[1,2],[2,1]]
  def self.permutations(array)
    array.permutation.to_a
  end

  # Combinaisons de `size` éléments.
  #
  # @param array [Array]
  # @param size [Integer]
  # @return [Array<Array>]
  #
  # @example
  #   Utils.combinations([1,2,3], 2)
  #   # => [[1,2],[1,3],[2,3]]
  def self.combinations(array, size)
    array.combination(size).to_a
  end

  #################################
  # Mathématiques
  #################################

  # Lecture de coordonnées x,y.
  #
  # @param path [String]
  # @param sep [String]
  # @return [Array<Array<Integer>>]
  #
  # @example
  #   # fichier :
  #   #  1,2
  #   #  3,4
  #   Utils.read_coordinates("coords.txt")
  #   # => [[1,2],[3,4]]
  def self.read_coordinates(path, sep = ",")
    read_lines(path).map { |line| line.split(sep).map(&:to_i) }
  end

  # PGCD.
  #
  # @param a [Integer]
  # @param b [Integer]
  # @return [Integer]
  #
  # @example
  #   Utils.gcd(48,18)
  #   # => 6
  def self.gcd(a, b)
    b == 0 ? a : gcd(b, a % b)
  end

  # PPCM.
  #
  # @param a [Integer]
  # @param b [Integer]
  # @return [Integer]
  #
  # @example
  #   Utils.lcm(6,8)
  #   # => 24
  def self.lcm(a, b)
    return 0 if a == 0 || b == 0
    (a * b) / gcd(a, b)
  end

  # Distance de Manhattan.
  #
  # @param p1 [Array<Integer>] [x,y]
  # @param p2 [Array<Integer>] [x,y]
  # @return [Integer]
  #
  # @example
  #   Utils.manhattan([1,2],[4,6])
  #   # => 7
  def self.manhattan(p1, p2)
    (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
  end

  # Distance euclidienne.
  #
  # @param p1 [Array<Integer>]
  # @param p2 [Array<Integer>]
  # @return [Float]
  #
  # @example
  #   Utils.euclidean([0,0],[3,4])
  #   # => 5.0
  def self.euclidean(p1, p2)
    Math.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)
  end

  #################################
  # Chaînes
  #################################

  # Chiffres d’une chaîne.
  #
  # @param string [String]
  # @return [Array<Integer>]
  #
  # @example
  #   Utils.digits("123")
  #   # => [1,2,3]
  def self.digits(string)
    string.chars.map(&:to_i)
  end

  # Compte les occurrences de caractères.
  #
  # @param string [String]
  # @return [Hash{String => Integer}]
  #
  # @example
  #   Utils.char_count("hello")
  #   # => {"h"=>1,"e"=>1,"l"=>2,"o"=>1}
  def self.char_count(string)
    string.chars.tally
  end

  # Rotation circulaire d’une chaîne.
  #
  # @param string [String]
  # @param n [Integer] décalage
  # @return [String]
  #
  # @example
  #   Utils.rotate("abc", 1)
  #   # => "bca"
  def self.rotate(string, n)
    n %= string.size
    string.chars.rotate(n).join
  end

  #################################
  # Grilles & Coordonnées
  #################################

  # Voisins 4 directions.
  #
  # @param x [Integer]
  # @param y [Integer]
  # @return [Array<Array<Integer>>]
  #
  # @example
  #   Utils.neighbors4(1,1)
  #   # => [[0,1],[2,1],[1,0],[1,2]]
  def self.neighbors4(x, y)
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
  end

  # Voisins 8 directions.
  #
  # @param x [Integer]
  # @param y [Integer]
  # @return [Array<Array<Integer>>]
  #
  # @example
  #   Utils.neighbors8(0,0)
  #   # => [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  def self.neighbors8(x, y)
    (-1..1).flat_map do |dx|
      (-1..1).map { |dy| [x + dx, y + dy] }
    end.reject { |nx, ny| nx == x && ny == y }
  end

  # Vérifie si une coordonnée est dans les bornes.
  #
  # @param x [Integer]
  # @param y [Integer]
  # @param width [Integer]
  # @param height [Integer]
  # @return [Boolean]
  #
  # @example
  #   Utils.in_bounds?(2,3,5,5)
  #   # => true
  def self.in_bounds?(x, y, width, height)
    x >= 0 && y >= 0 && x < width && y < height
  end

  # Affiche joliment une grille.
  #
  # @param grid [Array<Array<String>>]
  # @return [void]
  #
  # @example
  #   Utils.print_grid([["A","B"],["C","D"]])
  #   # affiche :
  #   # AB
  #   # CD
  def self.print_grid(grid)
    grid.each { |row| puts row.join }
  end

  # Recherche la première occurrence d'une valeur dans une grille 2D.
  #
  # @param value [Object] La valeur à rechercher dans la grille.
  # @param grid [Array<Array<Object>>] La grille 2D dans laquelle effectuer la recherche.
  # @return [Array<Integer>, nil] Les coordonnées `[x, y]` de la première occurrence trouvée, ou `nil` si la valeur n'est pas présente.
  #
  # @example
  #   grid = [
  #     [1, 2, 3],
  #     [4, 5, 6],
  #     [7, 8, 9]
  #   ]
  #   Utils.find_in_grid(5, grid)
  #   # => [1, 1]
  #
  #   Utils.find_in_grid(10, grid)
  #   # => nil
  def self.find_in_grid(value, grid)
    grid.each_with_index do |row, y|
      x = row.index(value)
      return [x, y] if x
    end
    nil
  end

  # Recherche un nombre à partir de coordonnées x y dans un grille (grid)
  #
  # @param grid [Array<Array<Object>>] La grille 2D dans laquelle effectuer la recherche
  # @param [Integer] x abscisse
  # @param [Integer] y l'ordonnée
  # @return [Integer] le nombre trouvée
  # @example
  #   grid = [
  #     [1, 2, 3],
  #     [4, 5, 6],
  #     [7, 8, 9]
  #   ]
  #   Utils.extract_number_from_coordinate_in_grid(grid, 1, 1)
  #   # => 456
  def self.extract_number_from_coordinate_in_grid(grid, x, y)
    width = grid[0].size
    start = x
    while start > 0 && is_digit?(grid[y][start - 1])
      start -= 1
    end
    number = ""
    i = start
    while i < width && is_digit?(grid[y][i])
      number << grid[y][i]
      i += 1
    end
    number.to_i
  end


  #################################
  # Divers
  #################################

  # Convertit une chaîne binaire en entier.
  #
  # @param string [String]
  # @return [Integer]
  #
  # @example
  #   Utils.binary_to_int("1011")
  #   # => 11
  def self.binary_to_int(string)
    string.to_i(2)
  end

  # Si c'est un chiffre ou non
  #
  # @param [String] le caractère à tester
  # @return [True] si ça l'est
  # @return [False] sinon
  #
  # @example
  #   Utils.is_digit("3")
  #   # => true
  def self.is_digit?(ch)
    ch.match?(/\A\d\z/)
  end

  # Convertit un entier en binaire (avec padding optionnel).
  #
  # @param n [Integer]
  # @param size [Integer, nil]
  # @return [String]
  #
  # @example
  #   Utils.int_to_binary(5)
  #   # => "101"
  #
  #   Utils.int_to_binary(5, 4)
  #   # => "0101"
  def self.int_to_binary(n, size = nil)
    bin = n.to_s(2)
    size ? bin.rjust(size, "0") : bin
  end

  # Helper debug.
  #
  # @param var [Object]
  # @param label [String, nil]
  # @return [void]
  #
  # @example
  #   Utils.debug([1,2,3], "Array")
  #   # => "Array: [1, 2, 3]"
  def self.debug(var, label = nil)
    puts "#{label || 'DEBUG'}: #{var.inspect}"
  end

  # Flood fill sur une grille 2D.
  #
  # @param grid [Array<Array<String>>]
  # @param start [Array<Integer>] coordonnée [x,y]
  # @param passable [Proc] condition de passage
  # @return [Array<Array<Integer>>] coordonnées visitées
  #
  # @example
  #   grid = [
  #     [".",".","#"],
  #     [".","#","."],
  #     [".",".","."]
  #   ]
  #   Utils.flood_fill(grid, [0,0])
  #   # => [[0,0],[1,0],[0,1],[0,2],[1,2],[2,2]]
  def self.flood_fill(grid, start, passable: ->(cell) { cell != "#" })
    visited = Set.new
    to_visit = [start]
    width  = grid[0].size
    height = grid.size

    until to_visit.empty?
      x, y = to_visit.pop
      next unless in_bounds?(x, y, width, height)
      next if visited.include?([x, y])
      next unless passable.call(grid[y][x])

      visited << [x, y]
      neighbors4(x, y).each do |nx, ny|
        to_visit << [nx, ny] unless visited.include?([nx, ny])
      end
    end

    visited
  end

  # Mesure le temps d’exécution d’un bloc.
  #
  # @param label [String]
  # @yield bloc de code à mesurer
  # @return [Object] résultat du bloc
  #
  # @example
  #   Utils.time("Computation") { (1..1_000_000).sum }
  #   # affiche "Computation: X.XXX sec"
  def self.time(label = "Execution")
    start = Time.now
    result = yield
    puts "#{COLOR[:yellow]}#{label}: #{COLOR[:green]}#{Time.now - start} secondes#{COLOR[:nc]}"
    result
  end


  #################################
  # Graphes
  #################################

  # Crée un graphe vide avec auto-initialisation.
  # Un graphe est représenté par un Hash où chaque clé (nœud) pointe vers un Set de nœuds voisins.
  # Les nœuds peuvent être n'importe quel objet hashable : Integer, String, Array [x,y], etc.
  #
  # @return [Hash{Object => Set<Object>}] graphe vide
  #
  # @example
  #   graph = Utils.empty_graph
  #   graph[1] << 2
  #   graph[1] << 3
  #   graph[2] << 4
  #   # => {1=>#<Set: {2, 3}>, 2=>#<Set: {4}>}
  def self.empty_graph
    Hash.new { |h, k| h[k] = Set.new }
  end

  # Crée un graphe pondéré vide.
  # Chaque nœud pointe vers un Hash {voisin => poids}.
  # Utilisé pour Dijkstra et algorithmes avec distances/coûts.
  #
  # @return [Hash{Object => Hash{Object => Numeric}}] graphe pondéré vide
  #
  # @example
  #   graph = Utils.empty_weighted_graph
  #   graph["A"]["B"] = 5
  #   graph["A"]["C"] = 3
  #   graph["B"]["D"] = 2
  #   # => {"A"=>{"B"=>5, "C"=>3}, "B"=>{"D"=>2}}
  def self.empty_weighted_graph
    Hash.new { |h, k| h[k] = {} }
  end

  # Convertit une grille 2D en graphe.
  # Chaque cellule passable devient un nœud [x,y] connecté à ses 4 voisins passables.
  # Par défaut, "#" représente un mur (non passable).
  #
  # @param grid [Array<Array<String>>] grille 2D
  # @param passable [Proc] condition pour qu'une cellule soit passable
  # @return [Hash{Array<Integer> => Set<Array<Integer>>}] graphe
  #
  # @example
  #   grid = [
  #     [".", ".", "#"],
  #     [".", "#", "."],
  #     [".", ".", "."]
  #   ]
  #   graph = Utils.grid_to_graph(grid)
  #   # => {[0,0]=>#<Set: {[1,0], [0,1]}>, [1,0]=>#<Set: {[0,0]}>, ...}
  #
  #   # Avec condition personnalisée
  #   graph = Utils.grid_to_graph(grid, passable: ->(cell) { cell != "X" })
  def self.grid_to_graph(grid, passable: ->(cell) { cell != "#" })
    graph = empty_graph
    height = grid.size
    width = grid[0].size
    
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next unless passable.call(cell)
        
        neighbors4(x, y).each do |nx, ny|
          next unless in_bounds?(nx, ny, width, height)
          next unless passable.call(grid[ny][nx])
          
          graph[[x, y]] << [nx, ny]
        end
      end
    end
    
    graph
  end

  # Parse une liste d'arêtes depuis un fichier.
  # Format attendu : "nœud1-nœud2" ou avec séparateur personnalisé.
  # Crée un graphe non-dirigé par défaut (arête bidirectionnelle).
  #
  # @param path [String] chemin du fichier
  # @param sep [String] séparateur entre nœuds
  # @param directed [Boolean] graphe dirigé ou non
  # @return [Hash{String => Set<String>}] graphe
  #
  # @example
  #   # fichier "edges.txt" :
  #   #  A-B
  #   #  B-C
  #   #  C-D
  #   graph = Utils.read_graph("edges.txt")
  #   # => {"A"=>#<Set: {"B"}>, "B"=>#<Set: {"A", "C"}>, "C"=>#<Set: {"B", "D"}>, "D"=>#<Set: {"C"}>}
  #
  #   # Graphe dirigé
  #   graph = Utils.read_graph("edges.txt", directed: true)
  #   # => {"A"=>#<Set: {"B"}>, "B"=>#<Set: {"C"}>, "C"=>#<Set: {"D"}>}
  def self.read_graph(path, sep: "-", directed: false)
    graph = empty_graph
    
    read_lines(path).each do |line|
      from, to = line.split(sep)
      graph[from] << to
      graph[to] << from unless directed
    end
    
    graph
  end

  # Dijkstra : trouve le plus court chemin dans un graphe pondéré ou non pondéré.
  # Retourne la distance minimale entre start et goal.
  #
  # @param graph [Hash{Object => Hash{Object => Numeric}}] graphe pondéré,
  #   ou [Hash{Object => Array<Object>}] graphe non pondéré (poids = 1)
  # @param start [Object] nœud de départ
  # @param goal [Object] nœud d'arrivée
  # @return [Numeric, nil] distance minimale ou nil si inaccessible
  #
  # @example
  #   graph = Utils.empty_weighted_graph
  #   graph["A"]["B"] = 4
  #   graph["A"]["C"] = 2
  #   graph["C"]["B"] = 1
  #   graph["B"]["D"] = 5
  #   graph["C"]["D"] = 8
  #   Utils.dijkstra(graph, "A", "D")
  #   # => 8 (chemin: A -> C -> B -> D = 2 + 1 + 5)
  def self.dijkstra(graph, start, goal)
    distances = Hash.new(Float::INFINITY)
    distances[start] = 0
    visited = Set.new

    queue = PQueue.new { |a, b| a[0] < b[0] } # [distance, node]
    queue.push([0, start])

    until queue.empty?
      dist, node = queue.pop
      next if visited.include?(node)
      visited << node

      return dist if node == goal

      neighbors = graph[node]
      next unless neighbors

      # Supporte les deux formats :
      # - pondéré : { node => { neighbor => weight } }
      # - non pondéré : { node => [neighbor_1, neighbor_2, ..., neighbor_n] }
      if neighbors.is_a?(Hash)
        neighbors.each do |neighbor, weight|
          new_dist = dist + weight
          if new_dist < distances[neighbor]
            distances[neighbor] = new_dist
            queue.push([new_dist, neighbor])
          end
        end
      else
        neighbors.each do |neighbor|
          new_dist = dist + 1
          if new_dist < distances[neighbor]
            distances[neighbor] = new_dist
            queue.push([new_dist, neighbor])
          end
        end
      end
    end

    nil
  end

  # Dijkstra avec reconstruction du chemin.
  # Retourne [distance, chemin] où chemin est un tableau de nœuds.
  #
  # @param graph [Hash{Object => Hash{Object => Numeric}}] graphe pondéré
  # @param start [Object] nœud de départ
  # @param goal [Object] nœud d'arrivée
  # @return [Array(Numeric, Array<Object>), nil] [distance, chemin] ou nil
  #
  # @example
  #   graph = Utils.empty_weighted_graph
  #   graph["A"]["B"] = 4
  #   graph["A"]["C"] = 2
  #   graph["C"]["B"] = 1
  #   graph["B"]["D"] = 5
  #   Utils.dijkstra_path(graph, "A", "D")
  #   # => [8, ["A", "C", "B", "D"]]
  def self.dijkstra_path(graph, start, goal)
    distances = Hash.new(Float::INFINITY)
    distances[start] = 0
    previous = {}
    visited = Set.new
    queue = [[0, start]]
    
    until queue.empty?
      dist, node = queue.min_by(&:first)
      queue.delete([dist, node])
      
      if node == goal
        path = []
        current = goal
        while current
          path.unshift(current)
          current = previous[current]
        end
        return [dist, path]
      end
      
      next if visited.include?(node)
      visited << node
      
      graph[node].each do |neighbor, weight|
        new_dist = dist + weight
        if new_dist < distances[neighbor]
          distances[neighbor] = new_dist
          previous[neighbor] = node
          queue << [new_dist, neighbor]
        end
      end
    end
    
    nil
  end

  # Trouve tous les chemins depuis un nœud de départ (BFS complet).
  # Retourne un Hash {nœud => distance}.
  #
  # @param graph [Hash{Object => Set<Object>}] graphe
  # @param start [Object] nœud de départ
  # @return [Hash{Object => Integer}] distances depuis start
  #
  # @example
  #   graph = Utils.empty_graph
  #   graph[1] << 2
  #   graph[2] << 3
  #   graph[1] << 4
  #   Utils.bfs_distances(graph, 1)
  #   # => {1=>0, 2=>1, 4=>1, 3=>2}
  def self.bfs_distances(graph, start)
    distances = { start => 0 }
    queue = [[start, 0]]
    
    until queue.empty?
      node, dist = queue.shift
      
      graph[node].each do |neighbor|
        next if distances.key?(neighbor)
        
        distances[neighbor] = dist + 1
        queue << [neighbor, dist + 1]
      end
    end
    
    distances
  end 

  # BFS (breadth-first search).
  #
  # @param graph [Hash{Object => Set<Object>}] graphe d’adjacence
  # @param start [Object] nœud de départ
  # @param goal [Object] nœud d’arrivée
  # @return [Integer, nil] distance minimale ou nil si inaccessible
  #
  # @example
  #   graph = Hash.new { |h,k| h[k] = Set.new }
  #   graph[1] << 2
  #   graph[2] << 3
  #   Utils.bfs(graph, 1, 3)
  #   # => 2
  def self.bfs(graph, start, goal)
    visited = Set.new
    queue = [[start, 0]]

    until queue.empty?
      node, dist = queue.shift
      return dist if node == goal

      next if visited.include?(node)
      visited << node

      graph[node].each do |neighbor|
        queue << [neighbor, dist + 1]
      end
    end
    nil
  end

  # FONCTIONS SPÉCIFIQUES À L'ADVENT OF CODE


  # Affiche dans la color souhaitée un texte
  # @param color la couleur souhaitée
  # @parem text le texte à afficher
  # @return nil
  # @example
  #   my_puts(:green, "Hello world !")
  #   => Hello world ! (mais en vert)
  def self.my_puts(color, text)
    puts "#{COLOR[color]}#{text}#{COLOR[:nc]}"
  end


  # Soumet une réponse à l'Advent of Code via l'API
  #
  # @param year [Integer] l'année de l'événement (ex: 2024)
  # @param day [Integer] le jour du calendrier (1-25)
  # @param level [Integer] le niveau de la partie (1 ou 2)
  # @param answer [Integer, String] la réponse calculée à soumettre
  # @param session_cookie [String] le cookie de session pour l'authentification
  # @return [void] affiche le résultat de la soumission
  def self.submit_answer(year, day, level, answer, session_cookie)
    uri = URI("https://adventofcode.com/#{year}/day/#{day}/answer")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri)
    request['Cookie'] = "session=#{session_cookie}"
    request['User-Agent'] = "ruby-script by Nael"
    request.set_form_data({
      'level' => level,
      'answer' => answer
    })
    response = http.request(request)
    my_puts(:green, "HTTP #{response.code}")
    parse_response(response.body)
  end

  # Analyse la réponse HTML de l'Advent of Code et affiche le résultat coloré
  #
  # @param html [String] le contenu HTML de la réponse du serveur
  # @return [void] affiche le message approprié selon le résultat
  def self.parse_response(html)
    #puts html
    if html.include?("That's the right answer")
      my_puts(:green, "OK !")
    elsif html.include?("That's not the right answer")
      my_puts(:red, "KO !")
      if html.include?("too high")
        my_puts(:yellow, "Trop haut !")
      elsif html.include?("too low")
        my_puts(:yellow, "Trop bas !")
      end
    elsif html.include?("You gave an answer too recently")
      my_puts(:yellow, "Réponse donnée trop récemment ! Il faut attendre un peu.")
    elsif html.include?("Did you already complete it")
      my_puts(:green, "Niveau déjà complété")
    else
      my_puts(:red, "Réponse inattendue...")
      puts html[0..500]
    end
  end

  # Récupère le cookie de session depuis le fichier .cookie.txt
  #
  # @return [String] le cookie de session (première ligne du fichier)
  def self.get_cookie
    File.readlines(COOKIE_PATH)[0].strip
  rescue Errno::ENOENT
    raise "Fichier .cookie.txt introuvable."
  rescue => e
    raise "Erreur lors de la lecture du cookie : #{e.message}"
  end

end