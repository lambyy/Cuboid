require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  subject { Cuboid.new(0, 0, 0, 1, 2, 3) }

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
      expect(subject.move_to!(-1, 0, 0)).to be false
      expect(subject.origin).to eq [0, 0, 0]
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
    let(:other_cube) { Cuboid.new(0, 1, 1, 1, 1, 1) }

    it "returns true if the cubes overlap" do
      expect(subject.intersects?(other_cube)).to be true
    end

    it "returns true if the origins are the same" do
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
  end

end
