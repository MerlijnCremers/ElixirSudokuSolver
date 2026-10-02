defmodule Sudoku.Grid do
  # wat simpele gets, plus een put.
  def get(board, row, column) do
    board
    |> Enum.at(row)
    |> Enum.at(column)
  end

  #de for dacht ik eerst is sketchy tot ik las wat het was, pattern matching, de naamgeving was alleen wel eng.
  def empty_cells(board) do
    for row <- 0..(length(board) - 1),
        column <- 0..(length(board) - 1),
        get(board, row, column) == 0 do
      {row, column}
    end
  end

  def put(board, row, column, value) do
    row_list = Enum.at(board, row)

    new_row = List.replace_at(row_list, column, value)

    List.replace_at(board, row, new_row)
  end

  def get_row(board, row) do
    Enum.at(board, row)
  end

  def get_colum(board, column) do
    Enum.map(board, fn row ->
      Enum.at(row, column)
    end)
  end
end