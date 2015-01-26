### Constraining size

The original `transaction.csv` file is very huge for us to handle as beginners. So we'll first trim the file down to a much humbler size, experiment our recommender and then scale things up to work for the original 359mn+ lines.

`$ head -n 1000000 transaction.csv > million_transactions.csv` will fetch the first 1mn transactions and store it in a file for us.

You can get a taste of how the data looks like by running `$ head -n 10 million_transactions.csv`. Especially, pay attention to the header.


