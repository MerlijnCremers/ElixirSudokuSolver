defmodule PartPurse.Solver do
  #bevat recursie en logica van de sudoku oplossen.
  #het gaat als volgt: kijk naar candidates en als er dan geen lege cellen meer zijn, en kijkt dan naar de cel met de minste opties, en vult die in een voor een.
  alias PartPurse.Candidates
  alias partPurse.Grid
  def solve(board) do
    candidates = Candidates.build(board)

    solve(board, candidates)
  end

  #de stop conditie
  def solve(board, candidates) when map_size(candidates) == 0 do
    board
  end

  def solve(board, candidates) do
    {{row, column}, values} =
      Candidates.find_most_constrained(candidates)

    try_values(board, candidates, row, column, values)
  end

  #ook de stop conditie maar dan van try values
  def try_values(_board, _candidates, _row, _column, []) do
    nil
  end

  def try_values(board, candidates, row, column, [value | rest]) do
    new_board = Grid.put(board, row, column, value)

    new_candidates = Candidates.build(new_board)

    result = solve(new_board, new_candidates)

    if result != nil do
      result
    else
      try_values(board, candidates, row, column, rest)
    end
  end
end