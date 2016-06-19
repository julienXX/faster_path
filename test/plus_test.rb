require 'test_helper'

class PlusTest < Minitest::Test
  def test_empty_path_plus_something
    assert_equal FasterPath.+('', ''), Pathname.new('')
    assert_equal FasterPath.+('', '/'), Pathname.new('/')
    assert_equal FasterPath.+('', '/usr'), Pathname.new('/usr')
    # assert_equal FasterPath.+('', 'foo/bar'), Pathname.new('foo/bar')
  end

  def test_path_plus_empty
    assert_equal FasterPath.+('/foo', ''), Pathname.new('/foo')
  end

  def test_path_plus_other
    assert_equal FasterPath.+('/foo', '/'), Pathname.new('/')
    assert_equal FasterPath.+('/foo', '/bar'), Pathname.new('/bar')
    assert_equal FasterPath.+('/foo', '/bar/baz'), Pathname.new('/bar/baz')
  end

  def test_plus_against_pathname_implementation
    result_pair = -> (other) {
      [
        Pathname.new('/foo') + Pathname.new(other),
        FasterPath.+('/foo', other)
      ]
    }

    assert_equal(*result_pair.(''))
    assert_equal(*result_pair.('.'))
    assert_equal(*result_pair.('/'))
    assert_equal(*result_pair.('hello'))
    assert_equal(*result_pair.('hello/world'))
    assert_equal(*result_pair.('123'))
    assert_equal(*result_pair.('a//b/d//e'))
    assert_equal(*result_pair.('../../c'))
  end
end
