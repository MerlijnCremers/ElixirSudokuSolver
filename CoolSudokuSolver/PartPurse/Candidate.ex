defmodule PartPurse.Candidates do

  alias PartPurse.Grid
  alias PartPurse.Box

  def get_for_cell(board, row, column) do
    used_in_row = Grid.get_row(board, row)
    used_in_column = Grid.get_column(board, column)
    used_in_box = Box.get_box(board, row, column)

    #filter nul en dubbele waarden eruit
    used =
      (used_in_row ++ used_in_column ++ used_in_box)
      |> Enum.filter(fn number -> number != 0 end)
      |> Enum.uniq()

#kijkt wat nog niet gebruikt is dit worden de candidates dus.
    Enum.filter(1..9, fn number ->
      number not in used
    end)
  end

  #gaat door de enum empty_cells en probeert de zet candidates op die plek
  def build(board) do
    empty_cells = Grid.empty_cells(board)

    Enum.reduce(empty_cells, %{}, fn {row, column}, candidates ->
      values = get_for_cell(board, row, column)

      Map.put(candidates, {row, column}, values)
    end)
  end

  #hier zoek ik de cel met de minste mogelijkheden
  def find_most_constrained(candidates) do
    Enum.min_by(candidates, fn {_position, values} ->
      length(values)
    end)
  end
end