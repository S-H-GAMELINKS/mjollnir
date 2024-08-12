# frozen_string_literal: true

require 'test_helper'

class ParseIntegerTest < Minitest::Test
  def test_parse_integer
    result = Mjollnir.parse('1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_INTEGER' => 1
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_plus_opcall
    result = Mjollnir.parse('1 + 1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :+,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 1
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_minus_opcall
    result = Mjollnir.parse('1 - 1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :-,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 1
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_times_opcall
    result = Mjollnir.parse('1 * 1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :*,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 1
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_div_opcall
    result = Mjollnir.parse('1 / 1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :/,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 1
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_remainder_opcall
    result = Mjollnir.parse('1 % 1')

    expected = {
      'NODE_SCOPE' => {
        'NODE_OPCALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :%,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 1
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_call
    result = Mjollnir.parse('1.to_i')

    expected = {
      'NODE_SCOPE' => {
        'NODE_CALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :to_i,
          'args' => nil
        }
      }
    }

    assert_equal expected, result
  end

  def test_parse_integer_call_with_arg
    result = Mjollnir.parse('1.to_i(10)')

    expected = {
      'NODE_SCOPE' => {
        'NODE_CALL' => {
          'recv' => {
            'NODE_INTEGER' => 1
          },
          'mid' => :to_i,
          'args' => {
            'NODE_LIST' => [
              {
                'NODE_INTEGER' => 10
              }
            ]
          }
        }
      }
    }

    assert_equal expected, result
  end
end
