defmodule ValidationTest do
  use ExUnit.Case

  import Chronos.Validation

  test :valid_date? do
    assert valid_date?({ 2012, 12, 21 })
    assert valid_date?({ 2008, 2, 29 })
    refute valid_date?({ 2009, 2, 29 })
    refute valid_date?({ 0000, -2, 29 })
  end

  test :valid_time? do
    assert valid_time?({ 0, 2, 29 })
    assert valid_time?({ 0, 0, 0 })
    assert valid_time?({ 23, 59, 59 })
    refute valid_time?({ 24, 2, 29 })
    refute valid_time?({ -1, 2, 29 })
    refute valid_time?({ 0, -1, 29 })
    refute valid_time?({ 0, 60, 29 })
    refute valid_time?({ 0, 2, -1 })
    refute valid_time?({ 0, 2, 60 })
    refute valid_time?({ -1, 60, 60 })
  end

  test :validate do
    assert validate({ 2012, 12, 21 }) == { 2012, 12, 21 }
    assert validate({{ 2012, 12, 21 }, { 13, 54, 12 }}) == {{2012, 12, 21},
                                                            {13, 54, 12}}

    assert_raise ArgumentError, "Invalid date argument {2013, 13, 41}", fn ->
      validate({2013, 13, 41})
    end
    assert_raise ArgumentError,
                 "Invalid date argument {{2013, 13, 41}, {24, 0, 0}}", fn ->
      validate({{2013, 13, 41}, {24, 0, 0}})
    end
  end
end
