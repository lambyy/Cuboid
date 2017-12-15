
class Cuboid
  def self.differential
    [
      [0, 0, 0],
      [1, 0, 0],
      [0, 1, 0],
      [0, 0, 1],
      [1, 1, 0],
      [1, 0, 1],
      [0, 1, 1],
      [1, 1, 1]
    ]
  end

  attr_reader :origin, :dimension

  def initialize(x, y, z, l, w, h)
    @origin = [x, y, z]
    @dimension = [l, w, h]
  end

  #BEGIN public methods that should be your starting point

  def move_to!(x, y, z)
    if x >= 0 && y >= 0 && z >= 0
      @origin = [x, y, z]
      true
    else
      false
    end
  end

  def vertices
    vertices = []
    Cuboid.differential.each do |diff|
      vertex = []
      3.times do |i|
        vertex << @origin[i] + diff[i] * @dimension[i]
      end
      vertices << vertex
    end

    vertices
  end

  #returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
    other.vertices.each do |vertex|
      return true if within_cube(vertex)
    end
    false
  end

  def within_cube(vertex)
    3.times do |i|
      return false unless within_dimension(vertex[i], i)
    end
    true
  end

  def within_dimension(point, dim)
    (@origin[dim]...(@origin[dim] + @dimension[dim])).include?(point)
  end

  #END public methods that should be your starting point
end
