### Input preparation for apriori

Now that we have our data in a suitable form, we want to query it the way our algorithms demand input. The apriori algorithm wants a comma separated list of item data, distinct items per id (which represents customer) per line. 

I've written a Ruby snippet that will do that for us. It has a dependency on `mysql2` gem, so you must have that installed.

``` ruby
require 'mysql2'

client = Mysql2::Client.new(
                            username: ENV["MYSQL_USERNAME"],
                            password: ENV["MYSQL_PASSWORD"],
                            database: ENV["MYSQL_DATABASE"]
                           )
```

The client object takes in the environment variables for your MySQL Username & Pasword and the Database name. To set them, you can export them from your shell. Run `$ export MYSQL_USERNAME=root MYSQL_PASSWORD=sqxKAm MYSQL_DATABASE=crunchy`. Needless to say, fill it in with your environment values.

``` ruby
id_list = client.query("select distinct id from csvdump")
id_list.each { |row| system "echo #{row["id"]} >> idlisting" }
``` 
The above section queries our table for distinct ids and puts them onto a text file called `idlisting`. 

```ruby
File.open("idlisting") do |file|
  file.each_line do |line|
    item_list = print "Querying (#{index}/#{total_ids}). ID #{line}"
    item_list = client.query("select item from csvdump where id=#{line}")
    item_list.each { |entry| system "echo -ne ',#{entry["item"]}' >> input_list" }
    system "echo -n '\n' >> input_list"
    index+=1
  end
end
```
Finally, each id is looked up on the table, its distinct items are returned, and the snippet formats them into comma separated items that go into the `input_list` file. You may now use `input_list` to do the apriori.

If you don't want to bother understanding this source, and just want to see the result, run `$ ruby code/queryscript.rb` from the project root. 

