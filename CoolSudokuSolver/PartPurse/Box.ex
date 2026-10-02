defmodule Sudoku.Box do
  #dit is om de verschillende boxen binnen het board te vinden.
  def get_box_start(row, column) do
    box_row = div(row, 3) * 3
    box_column = div(column, 3) * 3

    {box_row, box_column}
  end

  def get_box(board, row, column) do
    {start_row, start_column} = get_box_start(row, column)

    for r <- start_row..(start_row + 2),
        c <- start_column..(start_column + 2) do
      Sudoku.Grid.get(board, r, c)
    end
  end
end