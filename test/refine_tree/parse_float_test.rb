# frozen_string_literal: true

require 'test_helper'

class ParseFloatTest < Minitest::Test
  def test_parse_float
    result = RefineTree.parse('1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_FLOAT => 1.17
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_plus_opcall
    result = RefineTree.parse('1.17 + 1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_OPCALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :+,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_FLOAT => 1.17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_minus_opcall
    result = RefineTree.parse('1.17 - 1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_OPCALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :-,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_FLOAT => 1.17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_times_opcall
    result = RefineTree.parse('1.17 * 1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_OPCALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :*,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_FLOAT => 1.17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_div_opcall
    result = RefineTree.parse('1.17 / 1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_OPCALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :/,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_FLOAT => 1.17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_remainder_opcall
    result = RefineTree.parse('1.17 % 1.17')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_OPCALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :%,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_FLOAT => 1.17
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_call
    result = RefineTree.parse('1.17.to_i')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_CALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :to_i,
            :args => nil
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_float_call_with_arg
    result = RefineTree.parse('1.17.to_i(10)')

    expected = {
      :NODE_SCOPE => {
        :args => nil,
        :body => {
          :NODE_CALL => {
            :recv => {
              :NODE_FLOAT => 1.17
            },
            :mid => :to_i,
            :args => {
              :NODE_LIST => [
                {
                  :NODE_INTEGER => 10
                }
              ]
            }
          }
        }
      }
    }

    assert_equal expected, result
  end
end
