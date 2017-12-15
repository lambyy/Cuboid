
class Cuboid
  def self.differential
    [
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
    @dimension = {
      length: l,
      width: w,
      height: h
    }
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
    vertices = [@origin]
    Cuboid.differential.each do |diff|
      vertex = []
      vertex << @origin[0] + diff[0] * @dimension[:length]
      vertex << @origin[1] + diff[1] * @dimension[:width]
      vertex << @origin[2] + diff[2] * @dimension[:height]
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
    within_x = (@origin[0]...(@origin[0] + @dimension[:length])).include?(vertex[0])
    within_y = (@origin[1]...@origin[1] + @dimension[:width]).include?(vertex[1])
    within_z = (@origin[2]...@origin[2] + @dimension[:height]).include?(vertex[2])

    within_x && within_y && within_z
  end

  #END public methods that should be your starting point
end
