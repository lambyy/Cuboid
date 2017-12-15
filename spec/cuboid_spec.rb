require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  subject { Cuboid.new(0, 0, 0, 1, 2, 3) }

  describe "initialize" do
    it "creates a cuboid at the specified origin" do
      expect(subject.origin).to eq [0, 0, 0]
    end

    it "creates a cuboid with the specified dimensions" do
      expect(subject.dimension).to eq [1, 2, 3]
    end

    let (:out_of_bounds) { Cuboid.new(-1, -1, -1, 1, 2, 3) }

    it "creates a cuboid at [0, 0, 0] if the specified origin is out of bounds" do
      expect(out_of_bounds.origin).to eq [0, 0, 0]
      expect(out_of_bounds.dimension).to eq [1, 2, 3]
    end
  end

  describe "move_to" do
    it "changes the origin in the simple happy case" do
      expect(subject.move_to!(1,2,3)).to be true
    end

    it "can change the origin multiple times" do
      subject.move_to!(1, 1, 1)
      expect(subject.origin).to eq [1, 1, 1]
      subject.move_to!(3, 4, 5)
      expect(subject.origin).to eq [3, 4, 5]
    end

    it "doesn't move the origin out of bounds" do
      expect(subject.move_to!(-1, -2, -3)).to be false
      expect(subject.origin).to eq [0, 0, 0]
      subject.move_to!(1, 1, 1)
      expect(subject.move_to!(-1, 0, 0)).to be false
      expect(subject.origin).to eq [1, 1, 1]
    end
  end

  describe "vertices" do
    vertices1 = [[0, 0, 0], [1, 0, 0], [0, 2, 0], [0, 0, 3], [1, 2, 0], [1, 0, 3], [0, 2, 3], [1, 2, 3]]
    vertices2 = [[1, 1, 1], [2, 1, 1], [1, 3, 1], [1, 1, 4], [2, 3, 1], [2, 1, 4], [1, 3, 4], [2, 3, 4]]

    it "calculates the vertices of the cuboid" do
      expect(subject.vertices).to match_array(vertices1)
    end

    it "calculates the vertices of the cuboid for any origin" do
      subject.move_to!(1, 1, 1)
      expect(subject.vertices). to match_array(vertices2)
    end
  end

  describe "intersects?" do
    subject { Cuboid.new(0, 0, 0, 3, 3, 3) }
    let(:other_cube) { Cuboid.new(1, 1, 1, 1, 1, 1) }

    it "returns true if the cubes overlap" do
      expect(subject.intersects?(other_cube)).to be true
      other_cube.move_to!(0, 0, 0)
      expect(subject.intersects?(other_cube)).to be true
    end

    it "returns false if the cubes do not overlap" do
      other_cube.move_to!(4, 4, 4)
      expect(subject.intersects?(other_cube)).to be false
    end

    it "returns false if the cubes lie side by side without overlapping" do
      other_cube.move_to!(0, 0, 3)
      expect(subject.intersects?(other_cube)).to be false
    end

    it "correctly determines intersection for both cuboids" do
      other_cube.move_to!(0, 0, 0)
      expect(subject.intersects?(other_cube)).to be true
      expect(other_cube.intersects?(subject)).to be true

      other_cube.move_to!(2, 2, 2)
      expect(subject.intersects?(other_cube)).to be true
      expect(other_cube.intersects?(subject)).to be true

      other_cube.move_to!(4, 4, 4)
      expect(subject.intersects?(other_cube)).to be false
      expect(other_cube.intersects?(subject)).to be false
    end
  end

  describe "rotate" do

    describe "when the cuboid does not rotate out of bounds" do
      subject { Cuboid.new(3, 3, 3, 1, 2, 3) }

      vertices = [[3, 3, 3], [4, 3, 3], [3, 5, 3], [3, 3, 6], [4, 5, 3], [4, 3, 6], [3, 5, 6], [4, 5, 6]]
      vertices_x = [[3, 3, 3], [4, 3, 3], [3, 0, 3], [3, 3, 5], [4, 0, 3], [4, 3, 5], [3, 0, 5], [4, 0, 5]]
      vertices_2x = [[3, 3, 3], [4, 3, 3], [3, 1, 3], [3, 3, 0], [4, 1, 3], [4, 3, 0], [3, 1, 0], [4, 1, 0]]
      vertices_y = [[3, 3, 3], [6, 3, 3], [3, 5, 3], [3, 3, 2], [6, 5, 3], [6, 3, 2], [3, 5, 2], [6, 5, 2]]
      vertices_z = [[3, 3, 3], [5, 3, 3], [3, 2, 3], [3, 3, 6], [5, 2, 3], [5, 3, 6], [3, 2, 6], [5, 2, 6]]
      vertices_2xy = [[3, 3, 3], [0, 3, 3], [3, 1, 3], [3, 3, 2], [0, 1, 3], [0, 3, 2], [3, 1, 2], [0, 1, 2]]

      it "rotates cuboid around the x axis" do
        expect(subject.vertices).to match_array(vertices)
        subject.rotate("x")
        expect(subject.vertices).to match_array(vertices_x)
      end

      it "rotates cuboid around the y axis" do
        expect(subject.vertices).to match_array(vertices)
        subject.rotate("y")
        expect(subject.vertices).to match_array(vertices_y)
      end

      it "rotates cuboid around the z axis" do
        expect(subject.vertices).to match_array(vertices)
        subject.rotate("z")
        expect(subject.vertices).to match_array(vertices_z)
      end

      it "can rotate cuboid multiple times" do
        expect(subject.vertices).to match_array(vertices)
        subject.rotate("x")
        subject.rotate("x")
        expect(subject.vertices).to match_array(vertices_2x)
        subject.rotate("y")
        expect(subject.vertices).to match_array(vertices_2xy)
      end

      let(:other_cube) { Cuboid.new(2, 0, 2, 2, 2, 2) }
      it "correctly determines intersection of rotated cuboids" do
        expect(subject.intersects?(other_cube)).to be false
        subject.rotate("x")
        expect(subject.intersects?(other_cube)).to be true
      end
    end

    describe "when the cuboid rotates out of bounds" do
      subject { Cuboid.new(0, 0, 0, 1, 2, 3) }
      vertices3 = [[0, 3, 0], [0, 0, 0], [1, 3, 0], [0, 3, 2], [1, 0, 0], [1, 3, 2], [0, 0, 2], [1, 0, 2]]
      vertices4 = [[0, 3, 1], [2, 3, 1], [0, 0, 1], [0, 3, 0], [2, 0, 1], [2, 3, 0], [0, 0, 0], [2, 0, 0]]

      it "shifts the cuboid origin" do
        subject.rotate("x")
        expect(subject.origin).to eq [0, 3, 0]
        expect(subject.vertices).to match_array(vertices3)
      end

      it "can rotate and shift cuboid multiple times" do
        subject.rotate("x")
        subject.rotate("y")
        expect(subject.origin).to eq [0, 3, 1]
        expect(subject.vertices).to match_array(vertices4)
      end

      let(:other_cube) { Cuboid.new(0, 1, 0, 2, 2, 2) }
      it "correctly determines intersection of rotated cuboids" do
        expect(subject.intersects?(other_cube)).to be true
        subject.rotate("z")
        expect(subject.intersects?(other_cube)).to be false
      end
    end
  end

end
