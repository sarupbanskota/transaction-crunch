# transaction-crunch

This repository is a Junkyard for experiments I'm doing with a large collection of transaction data. While you could use it to learn, there isn't much to see and you're better off ignoring it ;) I've put up the repository here for helping few friends pick up the exercise.

# Environment
* Ruby 2.2.0 with mysql2 gem
* MySQL 5.6 stable edition
* transaction.csv file

# Flow

We're trying to build a recommender out of a HUGE collection of transaction data. We'll go over some steps sequentially. Since the original data we have is an ~30GB csv, we'll first plug our content into a MySQL database so the computation takes place in reasonable time.

1. We'll start with preparing our data so it's easy to deal with. Follow steps on the data-preparation file.
2. Assuming you have the environment correctly set up, we now want to dump all the data into a database. Follow instructions on the database-preparation file.
3. We're now ready to exploit our database to query it as we want, so we have our recommender's input the way it asks for. Look up input-preparation.
4. With the input format in place, we'll work on the recommender.

# Contribute: 

I'm primarily interested in algorithms for the recommender, so please don't send in trivial queries fixing spelling mistakes, this is just a junkyard :)

