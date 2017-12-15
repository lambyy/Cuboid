class Cuboid
  attr_reader :origin, :dimension

  def initialize(x, y, z, l, w, h)
    @origin = in_bounds?(x, y, z) ? [x, y, z] : [0, 0, 0]
    @dimension = [l, w, h]
  end

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
    Cuboid.vertex_differential.each do |diff|
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
      when "on cube surface"
        return true if other.within_cube(center) || within_cube(other.center)
      when true
        return true
      end
    end

    false
  end

  def rotate(axis)
    case axis
    when "x"
      rotate_by!(1, 2)
    when "y"
      rotate_by!(2, 0)
    when "z"
      rotate_by!(0, 1)
    end
  end

  def center
    center = []
    3.times do |i|
      center << @origin[i] + @dimension[i] / 2.0
    end
    center
  end

  def within_cube(vertex)
    on_surface_plane = false
    3.times do |i|
      case within_dimension(vertex[i], i)
      when false
        return false
      when "on surface plane"
        on_surface_plane = true
      end
    end
    return "on cube surface" if on_surface_plane
    true
  end

  private

  def within_dimension(point, dim)
    limits = [@origin[dim], @origin[dim] + @dimension[dim]]
    min, max = limits.min, limits.max

    return "on surface plane" if point == min || point == max
    (min..max).include?(point)
  end

  def rotate_by!(dim1, dim2)
    @dimension[dim1], @dimension[dim2] = @dimension[dim2], -1 * @dimension[dim1]
    shift_origin(dim1)
    shift_origin(dim2)
  end

  def shift_origin(dim)
    min = 0
    vertices.each do |vertex|
      min = vertex[dim] if min > vertex[dim]
    end
    @origin[dim] = @origin[dim] - min
  end

  def in_bounds?(x, y, z)
    x >= 0 && y >= 0 && z >= 0
  end

  def self.vertex_differential
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
end
