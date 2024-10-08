# frozen_string_literal: true

require_relative '../test_helper'

class ParseUnlessTest < Minitest::Test
  def test_parse_unless
    result = Kanayago.parse(<<~CODE)
      v = 117
      unless v
        p v
      end
    CODE

    expected = {
      NODE_SCOPE: {
        args: nil,
        body: {
          NODE_BLOCK: [
            {
              NODE_LASGN: {
                id: :v,
                value: {
                  NODE_INTEGER: 117
                }
              }
            },
            {
              NODE_UNLESS: {
                cond: {
                  NODE_LVAR: {
                    vid: :v
                  }
                },
                body: {
                  NODE_FCALL: {
                    mid: :p,
                    args: {
                      NODE_LIST: [
                        {
                          NODE_LVAR: {
                            vid: :v
                          }
                        }
                      ]
                    }
                  }
                },
                else: nil
              }
            }
          ]
        }
      }
    }

    assert_equal expected, result
  end
end
