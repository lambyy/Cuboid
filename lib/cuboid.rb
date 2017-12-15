
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
    @origin = in_bounds?(x, y, z) ? [x, y, z] : [0, 0, 0]
    @dimension = [l, w, h]
  end

  #BEGIN public methods that should be your starting point

  def move_to!(x, y, z)
    if in_bounds?(x, y, z)
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
      case within_cube(vertex)
      when "borders"
        return true if other.within_cube(self.center) || within_cube(other.center)
      when true
        return true
      end
    end

    false
  end

  #END public methods that should be your starting point

  def center
    center = []
    3.times do |i|
      center << @origin[i] + @dimension[i] / 2.0
    end
    center
  end

  def within_cube(vertex)
    borders_cube = false
    3.times do |i|
      case within_dimension(vertex[i], i)
      when false
        return false
      when "borders"
        borders_cube = true
      end
    end
    return "borders" if borders_cube
    true
  end

  private

  def within_dimension(point, dim)
    limits = [@origin[dim], @origin[dim] + @dimension[dim]]
    min, max = limits.min, limits.max

    return "borders" if point == min || point == max
    (min..max).include?(point)
  end

  def in_bounds?(x, y, z)
    x >= 0 && y >= 0 && z >= 0
  end
end
