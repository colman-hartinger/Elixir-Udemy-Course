defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> get_rgb
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create 500, 500
    fill = :egd.color color

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid , fn({_code, index}) ->
      horizontal = rem(index, 10)* 50
      vertical = div(index, 10)* 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Build 5 x 5 grid from hash and return indexed list

  ## Examples

      iex> image = Identicon.hash_input "test"
      iex> grid = Identicon.build_grid image
      iex> [first | _tail] = grid.grid
      iex> first
      {9, 0}

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk_every(3)
    |> Identicon.mirror_row
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(image) do
    for [first, second, third] = row <- image do
      [third, second, first, third, second, second, third, first, second, third]
    end
  end

  @doc """
  get rgb value from hash

  ## Examples

      iex> image = Identicon.hash_input "test"
      iex> image = Identicon.get_rgb image
      iex> image.color
      {9, 143, 107}

  """
  def get_rgb(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{ image | color: {r, g, b}}
  end

  @doc """
  Hash string using md5 algorithm

  ## Examples

      iex> image = Identicon.hash_input "test"
      iex> image.hex
      [9, 143, 107, 205, 70, 33, 211, 115, 202, 222, 78, 131, 38, 39, 180, 246]

  """
  def hash_input(input) do
    hash = :crypto.hash(:sha256, input)
    |> :binary.bin_to_list

    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    hex
    %Identicon.Image{hex: hash}
  end
end
