defmodule ValidationTest do
  use ExUnit.Case

  import Chronos.Validation

  test :valid_date? do
    assert valid_date?({ 2012, 12, 21 })
    assert valid_date?({ 2008, 2, 29 })
    refute valid_date?({ 2009, 2, 29 })
    refute valid_date?({ 0000, -2, 29 })
  end

  test :validate do
    assert validate({ 2012, 12, 21 }) == { 2012, 12, 21 }

    assert_raise ArgumentError, "Invalid date argument {2013, 13, 41}", fn ->
      validate({2013, 13, 41})
    end
  end
end
