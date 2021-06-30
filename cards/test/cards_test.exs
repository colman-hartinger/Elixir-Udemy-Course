defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "test file load error" do
    # {:error, response} = Cards.load("fail")
    assert "Could not read file" == Cards.load("fail")
  end

  test "test file load success" do
    deck = Cards.create_deck
    Cards.save(deck, "/test")

    assert Cards.load("test") == deck
  end
end
