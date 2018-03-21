# GoogleSpanner

Project is created with `mix new GoogleSpanner --app google_spanner`.

To use the GoogleSpanner client:
  * Add GCP credentials to environment variable: `export GCP_CREDENTIALS=$(cat ~/.gcloud/credentials.json)`.

## Example

```elixir
>> GoogleSpanner.start("test-project", "test-instance", "test-database")
{:ok, #PID<0.200.0>}

>> GoogleSpanner.upsert("products", ["upc", "name_en", "brand_en"], [["upc_test_1", "name_en_test_1", "brand_en_test_1"], ["upc_test_2", "name_en_test_2", "brand_en_test_2"]])
%{"commitTimestamp" => "2018-03-21T18:02:19.852399Z"}

>> GoogleSpanner.query("select * from products")
[   
  %{
    "brand_en" => "brand_en_test_1",
    "name_en" => "name_en_test_1",
    "upc" => "upc_test_1"
  },
  %{
    "brand_en" => "brand_en_test_2",
    "name_en" => "name_en_test_2",
    "upc" => "upc_test_2"
  }
]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `google_spanner` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:google_spanner, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/google_spanner](https://hexdocs.pm/google_spanner).

