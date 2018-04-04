![Chronos](http://f.cl.ly/items/3W2Q0v2E3d0D0p412e1Z/7471443430_f127b84f8a_b.jpg)

# Chronos [![Build Status](https://travis-ci.org/nurugger07/chronos.png?branch=master)](https://travis-ci.org/nurugger07/chronos)

An Elixir library for handling dates. Chronos can be used in both production and testing to quickly
determine a date.

## Using

You can add Chronos as a dependency in your `mix.exs` file. Since it only requires Elixir and Erlang there are no other dependencies.

```elixir
def deps do
  [ { :chronos, "~> 1.8.0" } ]
end
```

If you aren't using hex, add the a reference to the github repo.

``` elixir
def deps do
  [ { :chronos, github: "nurugger07/chronos" } ]
end
```

Then run `mix deps.get` in the shell to fetch and compile the dependencies

To use the Chronos date features in your project you can import the Chronos module or call the functions directly.

```elixir
defmodule YourModule do

  import Chronos

  def get_today do
    today
  end
end
```

or you can call functions without the import

```elixir
defmodule YourModule do
  def get_today do
    Chronos.today
  end
end
```

There are a number of functions to help with dates including below are some of the current APIs:

```iex

# yesterday without a date assumes you want the day before the current date
# current date is {2012, 12, 21}
iex> Chronos.yesterday
{2012, 12, 20}

iex> Chronos.tomorrow
{2012, 12, 22}

# epoch time can be return. If a time is not specified then midnight is assumed
iex> Chronos.epoch_time {2012, 12, 21}
1356048000

iex> Chronos.epoch_time {{2012, 12, 21}, {11, 11, 0}}
1356088260

```

You can find the date for days or weeks in the past or future:

```iex
iex> Chronos.days_ago(3)
{2012, 12, 18}

iex> Chronos.weeks_ago(5)
{2012, 11, 16}
```

## Use in Testing

Chronos is helpful in testing date based assertions because you can assign a default date or pass in a date to base the calculations on.

```elixir
defmodule TestingModule do
  use Chronos, date: {2012, 12, 21}
end

```
If the date option is set the default date for all functions will be that date.

## Formatting Dates & Times

With the addition of Chronos.Formatter, you can begin to format date tuples to something more readable.

```iex

iex> Chronos.Formatter.strftime({2012, 12, 21}, "%Y-%m-%d")
"2012-12-21"

iex> Chronos.Formatter.strftime({2012, 12, 21}, "Presented on %m/%d/%Y")
"Presented on 12/21/2012"

```

Date/Times can also be formatted with the `strftime` function.

```iex

iex> Chronos.Formatter.strftime({{2012, 12, 21}, {13, 35, 44}}, "%Y-%m-%d %H:%M:%S")
"2012-12-21 13:35:44"

```

Chronos will also build valid http dates.

The default format is for RFC 1123:

``` iex
iex> Chronos.Formatter.http_date({{2012, 12, 21}, {13, 35, 44}})
"Fri, 21 Dec 2012 18:31:45 GMT"
```

However, there is also support for RFC 850 & ANSI C's asctime() format

``` iex
iex> Chronos.Formatter.http_date({{2012, 12, 21}, { 13, 31, 45 }}, :rfc850)
"Friday, 21-Dec-2012 18:31:45 GMT"

iex> Chronos.Formatter.http_date({{2012, 12, 21}, { 13, 31, 45 }}, :asctime)
"Fri Dec 21 18:31:45 2012"
```
