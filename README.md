# ExploringMars

Elixir library to simulate a rover exploring a plateau in Mars.
Make sure you read the documentation in the modules and funcitons along with the tests they specify exactly how this code behaves.

## Usage

### Install the dependencies

`mix deps.get`

### Running using iex

`iex -S mix`

You can run passing your custom set of instructions like this:

```elixir
 iex> ExploringMars.process_rovers([["4", "4"], ["1", "3", "E"], ["MR"]])
 ["2 3 S"]
```

or you can add the instructions to a file called `./instructions.txt` using this format:

```
5 5
1 3 E
MRL
2 5 S
MMML
```

then run in the iex like this:

```elixir
iex> ExploringMars.main([])
["2 3 E", "2 2 E"]
```

### Runing the tests

`mix test`
