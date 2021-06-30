defmodule Cards do
  @moduledoc """
  Documentation for `Cards`.
    Provides methods for creating and handling decksmi
  """

  @doc """
  Returns a list of strings reptesenting a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four"] # ,"Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Hearts", "Spades", "Clubs", "Diamonds"]

    for value <- values, suit <- suits do
      "#{value} of #{suit}"
    end
  end

  @doc """
  Takes `deck` and returns shuffled contents
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    the `hand_size` argument indicates how many cards should
    be in the hand

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term binary
      {:error, _} -> "Could not read file"
    end
  end

  def create_hand do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(5)
  end
end
