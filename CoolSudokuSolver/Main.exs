#zorg dat de juiste bestanden ingeladen zijn.
Code.require_file("PartPurse/Grid.ex")
Code.require_file("PartPurse/Box.ex")
Code.require_file("PartPurse/Candidate.ex")
Code.require_file("PartPurse/Solver.ex")

#alias voor stel je wil meer solven, scheelt typwerk.
alias PartPurse.Solver, as: SudokuSolver

# ons lieftallige sudoku board.
board = [
  [5, 3, 0, 0, 7, 0, 0, 0, 0],
  [6, 0, 0, 1, 9, 5, 0, 0, 0],
  [0, 9, 8, 0, 0, 0, 0, 6, 0],
  [8, 0, 0, 0, 6, 0, 0, 0, 3],
  [4, 0, 0, 8, 0, 3, 0, 0, 1],
  [7, 0, 0, 0, 2, 0, 0, 0, 6],
  [0, 6, 0, 0, 0, 0, 2, 8, 0],
  [0, 0, 0, 4, 1, 9, 0, 0, 5],
  [0, 0, 0, 0, 8, 0, 0, 7, 9]
]

# 4. Roep de solver-functie aan
solution = SudokuSolver.solve(board)

#de printer
IO.puts("Opgeloste Sudoku:")
IO.inspect(solution)