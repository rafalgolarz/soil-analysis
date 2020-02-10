# SoilAnalysis

**Backend service**

## Installation
* Install dependencies with `mix deps.get`

## Scoring input

There are two ways of checking score for provided input:

```
$ mix run -e 'SoilAnalysis.top_scores("3 4 2 3 2 1 4 4 2 0 3 4 1 1 2 3 4 4")'
(2, 1, score: 27)
(1, 1, score: 25)
(2, 2, score: 23)
```

or directly from IEx:

```
iex -S mix
iex(1)> alias SoilAnalysis
iex(2)> SoilAnalysis.top_scores("3 4 2 3 2 1 4 4 2 0 3 4 1 1 2 3 4 4")

```

## Running tests

* `mix test`


