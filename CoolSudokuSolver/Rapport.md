# Functioneel programmeren in Elixir – Sudoku Solver

**Naam:** Merlijn Cremers   
**Studentnummer:** 2119805   
**Vak:** APP  
**Docent:** Dennis Breuker  
**Datum:** 02/10/2026

---
## 1. Inleiding
Voor deze opdracht is gekozen voor de programmeertaal Elixir. Elixir is een functionele programmeertaal die draait op de Erlang Virtual Machine (BEAM). De taal is ontworpen voor het bouwen van betrouwbare, gelijktijdige en schaalbare applicaties.

In deze opdracht wordt onderzocht welke functionele concepten en kenmerken centraal staan binnen Elixir En welke concepten ga ik toepassen bij het maken van een Sudoku Solver.

## AI
Er is weinig gebruik gemaakt van AI,
Met name is AI gebruikt voor spelling controle, en apa bronvermelding, twee onderdelen die ik eerder niet goed heb ingeleverd.

Ik heb de bronvermelding direct overgenomen, en de verbetering deels overgenomen, met name omdat ik zag dat de ai (chatgpt) best wat te streng was volgens mij.

---

## 2. Functionele concepten in Elixir

Elixir is een functionele programmeertaal, dat heeft wat voor- en nadelen, nadelen zijn bijvoorbeeld geen klassen zoals in Java of geen for en while loops. Voordeel is wel dat er minder side effects zijn dankzij de immutability, en de for loop kun je omzeilen met recursie of pattern matching enums.

### 2.1 Pure functions
Een pure function is een functie die aan twee belangrijke voorwaarden voldoet:
* Dezelfde input geeft altijd dezelfde output.
* De functie heeft geen side effects.

Een side effect betekent dat een functie iets buiten zichzelf verandert, bijvoorbeeld een globale variabele aanpassen of informatie naar een database sturen.

Een eenvoudig voorbeeld van een pure function in Elixir:

```
def add(a, b) do
  a + b
end
```

Wanneer `add(2, 3)` wordt uitgevoerd, is het resultaat altijd `5`. De functie verandert daarnaast niets buiten zichzelf.
Pure functions zijn belangrijk binnen functioneel programmeren omdat functies hierdoor voorspelbaar en eenvoudig te testen zijn.

#### Pure functions in de Sudoku Solver
De Sudoku Solver kan grotendeels worden opgebouwd uit pure functions. Een functie kan bijvoorbeeld een Sudoku-bord ontvangen en de lege cellen teruggeven:

```
def empty_cells(board) do
  for row <- 0..(length(board) - 1),
      column <- 0..(length(board) - 1),
      get(board, row, column) == 0 do
    {row, column}
  end
end
```

Deze functie verandert het bord niet. Het bord wordt gebruikt als input en de functie produceert een nieuwe lijst met lege posities.
Andere functies binnen de Sudoku Solver kunnen op dezelfde manier worden opgebouwd. Bijvoorbeeld functies die controleren welke getallen geldig zijn op een bepaalde positie.



### 2.2 First-class functions
In Elixir zijn functies first-class values. Dit betekent dat functies op dezelfde manier behandeld kunnen worden als andere waarden.

Een functie kan bijvoorbeeld:
* In een variabele worden opgeslagen,
* Als argument aan een andere functie worden meegegeven,
* Als resultaat door een andere functie worden teruggegeven.

Bijvoorbeeld:

```
add = fn a, b -> a + b end

add.(2, 3)
```

Hier wordt een anonieme functie opgeslagen in de variabele `add`.

Een functie kan ook als argument worden meegegeven:

```
Enum.map([1, 2, 3], fn number -> number * 2 end)
```

`Enum.map/2` ontvangt hier een functie die op ieder element van de lijst wordt uitgevoerd.
Dit is belangrijk voor functioneel programmeren omdat functies hierdoor kunnen worden gecombineerd en hergebruikt.

#### Gebruik in de Sudoku Solver
Bij een Sudoku Solver kunnen first-class functions bijvoorbeeld worden gebruikt om een bewerking uit te voeren op meerdere kandidaten of cellen.

```
Enum.map(candidates, fn candidate ->
  place_number(board, row, column, candidate)
end)
```

De functie die als tweede argument aan `Enum.map` wordt gegeven, wordt toegepast op ieder element van `candidates`.


### 2.3 Higher-order functions
Een higher-order function is een functie die één of meerdere functies als argument ontvangt of een functie als resultaat teruggeeft.

Een bekend voorbeeld in Elixir is `Enum.map/2`.

```
Enum.map([1, 2, 3], fn number ->
  number * 2
end)
```

De functie `Enum.map/2` ontvangt:
* Een lijst;
* Een functie die op ieder element moet worden uitgevoerd.

Het resultaat is: `[2, 4, 6]`

Andere veelgebruikte higher-order functions in Elixir zijn:
* `Enum.filter/2`
* `Enum.reduce/3`
* `Enum.any?/2`
* `Enum.all?/2`

#### Voorbeeld in de Sudoku Solver
`Enum.filter/2` kan worden gebruikt om alleen geldige kandidaten over te houden:

```
Enum.filter(1..9, fn number ->
  valid_move?(board, row, column, number)
end)
```

Hier wordt de functie `valid_move?/3` voor iedere waarde van 1 tot en met 9 uitgevoerd.
Alleen de waarden waarvoor de functie `true` teruggeeft, blijven over.



### 2.4 Immutability
Elixir gebruikt immutable data. Dit betekent dat bestaande waarden niet worden aangepast.
Wanneer een waarde "veranderd" moet worden, wordt in plaats daarvan een nieuwe waarde gemaakt.

Bijvoorbeeld:

```
numbers = [1, 2, 3]

new_numbers = [0 | numbers]
```

`numbers` blijft: `[1, 2, 3]`  
Terwijl `new_numbers` is: `[0, 1, 2, 3]`

De oorspronkelijke lijst is dus niet veranderd.

#### Immutability in de Sudoku Solver
Dit is belangrijk bij het oplossen van Sudoku's.
Wanneer een getal in een lege cel wordt geplaatst, wordt niet een bestaande cel van het bord aangepast. In plaats daarvan wordt een nieuw bord gemaakt waarin het getal op die positie staat.

Bijvoorbeeld:

```
new_board = set(board, row, column, number)
```

Het oorspronkelijke `board` blijft bestaan.
Dit maakt het mogelijk om tijdens backtracking terug te gaan naar een eerdere toestand zonder het oorspronkelijke bord opnieuw te hoeven herstellen.



### 2.5 Recursion
Omdat Elixir geen traditionele `for`- of `while`-loops gebruikt zoals bijvoorbeeld Java, wordt recursie vaak gebruikt om herhaalde berekeningen uit te voeren.

Een eenvoudige recursieve functie:

```
def count(0) do
  0
end

def count(number) do
  1 + count(number - 1)
end
```

Wanneer `count(3)` wordt aangeroepen:
* `count(3)`
* `1 + count(2)`
* `1 + 1 + count(1)`
* `1 + 1 + 1 + count(0)`
* `1 + 1 + 1 + 0`
* `3`

#### Recursie in de Sudoku Solver
Recursie is bijzonder geschikt voor een Sudoku Solver omdat het oplossen van een Sudoku een vorm van backtracking gebruikt.

Het algemene principe is:
1. Zoek een lege cel.
2. Bepaal de mogelijke waarden.
3. Plaats een mogelijke waarde.
4. Probeer de Sudoku verder op te lossen.
5. Als dit niet lukt, probeer een andere waarde.
6. Ga door totdat het bord is opgelost.

Een vereenvoudigde structuur kan er bijvoorbeeld zo uitzien:

```
def solve(board) do
  case empty_cells(board) do
    [] ->
      board

    [{row, column} | _] ->
      candidates(board, row, column)
      |> try_candidates(board, row, column)
  end
end
```

De functie kan zichzelf opnieuw aanroepen met een nieuw bord.
Hierdoor ontstaat een zoekboom van mogelijke oplossingen.


### 2.6 Pattern matching
Pattern matching is een belangrijk onderdeel van Elixir. Hiermee kan een waarde worden vergeleken met een bepaald patroon.

Bijvoorbeeld:

```
case empty_cells(board) do
  [] ->
    board

  [{row, column} | _] ->
    solve_cell(board, row, column)
end
```

Hier wordt onderscheid gemaakt tussen twee situaties:
* `[]`: er zijn geen lege cellen meer,
* `[{row, column} | _]`: er is minimaal één lege cel.

De tweede vorm maakt gebruik van list pattern matching. Het eerste element wordt opgeslagen in `{row, column}` en de overige elementen worden genegeerd met `_`.

#### Pattern matching voor functies
Pattern matching kan ook worden gebruikt in function clauses:

```
def solve([]) do
  []
end

def solve([head | tail]) do
  [head | solve(tail)]
end
```

Elixir bepaalt op basis van de input welke functieclause overeenkomt.

#### Gebruik in de Sudoku Solver
Pattern matching kan worden gebruikt om verschillende situaties in het algoritme duidelijk van elkaar te onderscheiden.

Bijvoorbeeld:

```
case result do
  {:ok, board} ->
    board

  :error ->
    nil
end
```

Dit maakt de verschillende mogelijke resultaten expliciet.


### 2.7 Immutability en recursion samen
Immutability en recursion vullen elkaar goed aan in Elixir.
Omdat waarden niet worden aangepast, kan een recursieve functie steeds een nieuwe versie van de data ontvangen.

Bij een Sudoku Solver kan dit bijvoorbeeld betekenen:
```
Bord 1
  naar:
Bord 2 met kandidaat 4
  naar:
Bord 3 met kandidaat 7
  naar:
Oplossing gevonden
```

Als een kandidaat niet blijkt te werken, kan de functie terugkeren naar het vorige bord en een andere kandidaat proberen.
Dit is een belangrijk onderdeel van het backtracking-algoritme.



### 2.8 Declaratieve stijl
Elixir ondersteunt een declaratieve programmeerstijl.
Bij een imperatieve programmeerstijl beschrijf je voornamelijk hoe een probleem stap voor stap moet worden opgelost.
Bij een declaratieve stijl beschrijf je meer wat het gewenste resultaat is.

Bijvoorbeeld:

```
Enum.filter(numbers, fn number ->
  number > 5
end)
```

Hier wordt beschreven dat alleen de waarden groter dan 5 gewenst zijn. Er wordt niet expliciet beschreven hoe een teller door de lijst moet lopen.

Dit verschilt bijvoorbeeld van een traditionele Java-loop:

```
for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] > 5) {
        ...
    }
}
```

In Elixir wordt de iteratie vaak verborgen in functies zoals `Enum.map`, `Enum.filter` en `Enum.reduce`.

#### Declaratieve stijl in de Sudoku Solver
Een Sudoku Solver kan bijvoorbeeld declaratief beschrijven welke waarden geldig zijn:

```
Enum.filter(1..9, fn number ->
  valid_move?(board, row, column, number)
end)
```

De code zegt in feite: *Geef alle getallen van 1 tot en met 9 waarvoor `valid_move?` waar is.*
Er wordt niet een variabele bijgehouden die door alle getallen heen loopt.


### 2.9 Pipe operator
De pipe operator `|>` is een belangrijk onderdeel van de stijl van Elixir.
De pipe operator geeft het resultaat van een expressie door als eerste argument aan de volgende functie.

Zonder pipe:

```
Enum.filter(
  Enum.map(numbers, fn number -> number * 2 end),
  fn number -> number > 5 end
)
```

Met pipe:

```
numbers
|> Enum.map(fn number -> number * 2 end)
|> Enum.filter(fn number -> number > 5 end)
```

Dit maakt het mogelijk om meerdere transformaties achter elkaar te zetten.

#### Pipe operator in de Sudoku Solver
De pipe operator is handig wanneer meerdere bewerkingen achter elkaar uitgevoerd moeten worden.

Bijvoorbeeld:

```
board
|> get_row(row)
|> Enum.filter(fn number -> number != 0 end)
```

Hier wordt eerst de rij opgehaald en vervolgens worden de lege waarden verwijderd.
De pipe operator verandert niets aan het feit dat Elixir functioneel programmeert. Het is alleen een syntactische manier om functies duidelijk achter elkaar te kunnen zetten.


### 2.10 List processing
Lijsten zijn een belangrijk datatype in Elixir. Veel functionele bewerkingen worden uitgevoerd met behulp van functies uit de `Enum`-module.

Belangrijke functies zijn:

* **`Enum.map`**: Voert een functie uit op ieder element.
  ```
  Enum.map([1, 2, 3], fn x -> x * 2 end)
  # Resultaat: [2, 4, 6]
  ```

* **`Enum.filter`**: Houdt alleen elementen over waarvoor de functie `true` geeft.
  ```
  Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
  # Resultaat: [2, 4]
  ```

* **`Enum.reduce`**: Combineert alle elementen tot één resultaat.
  ```
  Enum.reduce([1, 2, 3], 0, fn x, total ->
    total + x
  end)
  # Resultaat: 6
  ```

Deze functies passen goed bij functioneel programmeren omdat de nadruk ligt op het transformeren van gegevens.


### 2.11 Comprehensions
Elixir ondersteunt comprehensions. Hiermee kan op een compacte manier over collecties worden geïtereerd en kunnen resultaten worden verzameld.

Bijvoorbeeld:

```
for number <- 1..9, rem(number, 2) == 0 do
  number
end
# Resultaat: [2, 4, 6, 8]
```

Een comprehension kan dus worden gebruikt om waarden te genereren op basis van een verzameling.

#### Comprehension in de Sudoku Solver
De functie `empty_cells` kan bijvoorbeeld worden geschreven als:

```
def empty_cells(board) do
  for row <- 0..(length(board) - 1),
      column <- 0..(length(board) - 1),
      get(board, row, column) == 0 do
    {row, column}
  end
end
```

Hier worden alle combinaties van `row` en `column` bekeken.
Alleen posities waarvoor `get(board, row, column) == 0` waar is, worden opgenomen in het resultaat.

De comprehension is dus een compacte manier om de gewenste lijst te produceren.
Een ding is wel dat dit geen objectgeoriënteerde for-loop is. Een Elixir comprehension geeft een nieuwe collectie op basis van bestaande waarden.

### 2.12 Lazy Evaluation
In Elixir worden bewerkingen via de Enum-module standaard direct (eagerly) uitgevoerd. Dit betekent dat bij elke stap in een keten een nieuwe lijst in het geheugen wordt opgebouwd. Elixir ondersteunt echter ook lazy evaluation via de Stream-module.

Eager evaluation directe verwerking per stap:
```
1..100_000
|> Enum.map(fn x -> x * 2 end)
|> Enum.filter(fn x -> rem(x, 3) == 0 end)
```

Lazy evaluation, stappen worden pas berekend bij de take:
```
1..100_000
|> Stream.map(fn x -> x * 2 end)
|> Stream.filter(fn x -> rem(x, 3) == 0 end)
|> Enum.take(5)
```

Bij lazy evaluation worden berekeningen pas daadwerkelijk uitgevoerd op het moment dat het eindresultaat opgevraagd wordt (bijvoorbeeld via een Enum-functie). Dit voorkomt het tussentijds aanmaken van grote verzamelingen in het geheugen.

## 3. Functionele aanpak van de Sudoku Solver

### 3.1 Representatie van het bord
Het Sudoku-bord kan worden weergegeven als een lijst van lijsten.

Bijvoorbeeld:

```
[
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
```

Een `0` betekent dat de cel leeg is.
Het bord is immutable. Wanneer een waarde wordt geplaatst, wordt een nieuw bord gemaakt.

---

### 3.2 Lege cellen vinden
De eerste stap van het algoritme is bepalen welke cellen nog leeg zijn.

```
def empty_cells(board) do
  for row <- 0..(length(board) - 1),
      column <- 0..(length(board) - 1),
      get(board, row, column) == 0 do
    {row, column}
  end
end
```

Het resultaat kan bijvoorbeeld zijn: `[{0, 2}, {0, 3}, {0, 5}, ...]`  
Elke tuple bevat de rij en kolom van een lege cel.


### 3.3 Geldige kandidaten bepalen
Voor iedere lege cel moeten de mogelijke waarden worden bepaald.
De mogelijke getallen zijn 1 tot en met 9 (`1..9`).

Daarna worden alleen de waarden behouden die volgens de Sudoku-regels geldig zijn:

```
Enum.filter(1..9, fn number ->
  valid_move?(board, row, column, number)
end)
```

Hier worden meerdere functionele concepten gecombineerd:
* `Enum.filter/2` is een higher-order function,
* De anonieme functie wordt als argument doorgegeven,
* Het resultaat is een nieuwe collectie,
* Het oorspronkelijke bord wordt niet gewijzigd.


### 3.4 Backtracking
Als er meerdere mogelijke waarden zijn, moet de solver verschillende mogelijkheden proberen.
Stel dat een cel de kandidaten `[2, 4, 7]` heeft.

De solver probeert dan bijvoorbeeld `2`. Als dit uiteindelijk tot een fout leidt, wordt geprobeerd `4`, en daarna `7`. Dit is backtracking.

Een vereenvoudigde versie kan bijvoorbeeld worden opgebouwd als:

```
def solve(board) do
  case empty_cells(board) do
    [] ->
      board

    [{row, column} | _] ->
      candidates(board, row, column)
      |> try_candidates(board, row, column)
  end
end
```

Het algoritme blijft nieuwe borden maken totdat een oplossing wordt gevonden of alle mogelijkheden zijn geprobeerd.


## 4. Reflectie

Ik heb in dit document al duidelijk aangegeven welke concepten ik heb gebruikt en waar. De koppeling was daar makkelijker te maken dan hier en dan terug te verwijzen. Als ik terug kijk naar de afgelopen paar weken zou ik zeggen dat ik het onderzoeks deel goed heb gedaan.

Alleen ging het bij het uitvoeren dus fout, ik ben door stomme fouten, ziggo en een windows update in de laatste week (omdat ik te laat begon met het echt programmeren) best veel kwijt. Hierdoor moest ik niet alleen alles herschrijven, maar kon ik niet de zelfde repo gebruiken.

Verder denk ik dat ik de functionele concepten goed gebruik van heb gemaakt, met name waren pattern matching en recursie echt de kern van mijn Sudoku Solver.

---

## 5. Conclusie

Elixir is sterk gericht op functioneel programmeren. De taal maakt gebruik van concepten zoals immutable data, pure functions, first-class functions, higher-order functions, pattern matching en recursion.

Deze eigenschappen zijn goed toete gebruiken bij het maken van een Sudoku Solver.

De Sudoku Solver kan worden opgebouwd als een verzameling functies die steeds nieuwe data produceren. Het bord wordt niet rechtstreeks aangepast. In plaats daarvan worden nieuwe versies van het bord gemaakt wanneer een kandidaat wordt geplaatst.

Voor het oplossen van de Sudoku is recursion meer dan goed geschikt, omdat het backtracking-algoritme steeds opnieuw een volgende mogelijkheid kan proberen. Wanneer een mogelijkheid niet tot een oplossing leidt, kan de functie terugkeren naar een eerdere toestand.

Ook functies zoals `Enum.map`, `Enum.filter` en `Enum.reduce`, samen met de pipe operator en comprehensions, maken het mogelijk om de code op een declaratieve manier te schrijven.

Hierdoor kan de Sudoku Solver volledig worden opgebouwd rond functionele programmeerconcepten, zonder gebruik te maken van klassieke objectgeoriënteerde concepten zoals classes, objects, inheritance en mutable object state.

## 6. Bronvermelding

Elixir. (2026). Introduction. Elixir Documentation. https://elixir.hexdocs.pm/introduction.html
Elixir School. (z.d.). Elixir School. https://elixirschool.com/en
HAN University of Applied Sciences. (2026). Opdracht Functioneel Paradigma. https://aim-cni.github.io/app/docs/Paradigma%20challenge/opdracht_functioneel_programmeren
OpenAI. (2026). ChatGPT [Generatieve AI].https://chatgpt.com/share/6abff3eb-9280-83ed-bce0-155727ec5bf2