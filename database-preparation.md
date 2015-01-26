### Preparing tables to work with

Create a new database to work with on this project, and create a table.

```sql 
mysql> create table largecsvdump (
    -> id bigint, 
    -> chain bigint,
    -> dept bigint,
    -> category bigint,
    -> company bigint,
    -> brand bigint,
    -> date date,
    -> productsize int,
    -> productmeasure varchar(20),
    -> purchasequantity int,
    -> purchaseamount int
    -> );
Query OK, 0 rows affected (0.84 sec)

```

Notice how the table we've created has the same headers as that of our CSV file. To play safe, we'll go with the `bigint` datatype wherever applicable. 

```sql

mysql> describe largecsvdump;
+------------------+-------------+------+-----+---------+-------+
| Field            | Type        | Null | Key | Default | Extra |
+------------------+-------------+------+-----+---------+-------+
| id               | bigint(20)  | YES  |     | NULL    |       |
| chain            | bigint(20)  | YES  |     | NULL    |       |
| dept             | bigint(20)  | YES  |     | NULL    |       |
| category         | bigint(20)  | YES  |     | NULL    |       |
| company          | bigint(20)  | YES  |     | NULL    |       |
| brand            | bigint(20)  | YES  |     | NULL    |       |
| date             | date        | YES  |     | NULL    |       |
| productsize      | int(11)     | YES  |     | NULL    |       |
| productmeasure   | varchar(20) | YES  |     | NULL    |       |
| purchasequantity | int(11)     | YES  |     | NULL    |       |
| purchaseamount   | int(11)     | YES  |     | NULL    |       |
+------------------+-------------+------+-----+---------+-------+
11 rows in set (0.05 sec)

```

We're now ready to plug in data into the table. You'll have to figure out the path of your `million_transactions.csv` file, since that's the one we'll be loading from. Since our field values are separated by commas, we want to let MySQL know.

``` sql

mysql> load data local infile '/home/sarupbanskota/Documents/store_crunch/million_transactions.csv'
    -> into table largecsvdump
    -> fields terminated by ',';

Query OK, 1000001 rows affected, 10 warnings (26.77 sec)
Records: 1000001  Deleted: 0  Skipped: 0  Warnings: 10

```

Notice there are 10 warnings. You could inspect them, they arise because the first row in our CSV file was a header and didn't gel well with the table's expected datatype. We'll let go of the first row: 

```sql

mysql> delete from largecsvdump where id="id";
Query OK, 1 row affected, 1 warning (3.89 sec)

```

Woot, we're good now. Here's how a section of the dump looks like: 

```sql

mysql> select * from largecsvdump limit 10;
+-------+-------+------+----------+------------+-------+------------+-------------+----------------+------------------+----------------+
| id    | chain | dept | category | company    | brand | date       | productsize | productmeasure | purchasequantity | purchaseamount |
+-------+-------+------+----------+------------+-------+------------+-------------+----------------+------------------+----------------+
| 86246 |   205 |    7 |      707 | 1078778070 | 12564 | 2012-03-02 |          12 | OZ             |                1 |              8 |
| 86246 |   205 |   63 |     6319 |  107654575 | 17876 | 2012-03-02 |          64 | OZ             |                1 |              2 |
| 86246 |   205 |   97 |     9753 | 1022027929 |     0 | 2012-03-02 |           1 | CT             |                1 |              6 |
| 86246 |   205 |   25 |     2509 |  107996777 | 31373 | 2012-03-02 |          16 | OZ             |                1 |              2 |
| 86246 |   205 |   55 |     5555 |  107684070 | 32094 | 2012-03-02 |          16 | OZ             |                2 |             10 |
| 86246 |   205 |   97 |     9753 | 1021015020 |     0 | 2012-03-02 |           1 | CT             |                1 |              8 |
| 86246 |   205 |   99 |     9909 |  104538848 | 15343 | 2012-03-02 |          16 | OZ             |                1 |              2 |
| 86246 |   205 |   59 |     5907 |  102900020 |  2012 | 2012-03-02 |          16 | OZ             |                1 |              1 |
| 86246 |   205 |    9 |      921 |  101128414 |  9209 | 2012-03-02 |           4 | OZ             |                2 |              2 |
| 86246 |   205 |   73 |     7344 | 1068142161 | 20285 | 2012-03-02 |           8 | CT             |                1 |              6 |
+-------+-------+------+----------+------------+-------+------------+-------------+----------------+------------------+----------------+
10 rows in set (0.07 sec)

```

The department, category, company and brand fields uniquely identify a product. Since we're more in products, let's merge these into one column. Before that, create a column to store the products.

```sql

mysql> alter table largecsvdump add column item varchar(50);
Query OK, 0 rows affected (26.12 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> describe largecsvdump;
+------------------+-------------+------+-----+---------+-------+
| Field            | Type        | Null | Key | Default | Extra |
+------------------+-------------+------+-----+---------+-------+
| id               | bigint(20)  | YES  |     | NULL    |       |
| chain            | bigint(20)  | YES  |     | NULL    |       |
| dept             | bigint(20)  | YES  |     | NULL    |       |
| category         | bigint(20)  | YES  |     | NULL    |       |
| company          | bigint(20)  | YES  |     | NULL    |       |
| brand            | bigint(20)  | YES  |     | NULL    |       |
| date             | date        | YES  |     | NULL    |       |
| productsize      | int(11)     | YES  |     | NULL    |       |
| productmeasure   | varchar(20) | YES  |     | NULL    |       |
| purchasequantity | int(11)     | YES  |     | NULL    |       |
| purchaseamount   | int(11)     | YES  |     | NULL    |       |
| item             | varchar(50) | YES  |     | NULL    |       |
+------------------+-------------+------+-----+---------+-------+
12 rows in set (0.00 sec)

```

We're ready to concatenate the relevant columns into one item column.

```sql

mysql> update largecsvdump set item = concat(dept, '-', category, '-', company, '-', brand);
Query OK, 1000000 rows affected (56.22 sec)
Rows matched: 1000000  Changed: 1000000  Warnings: 0

```

Neat! Here's what happened: 

```sql

mysql> select dept,category,company,brand,item from largecsvdump limit 10;
+------+----------+------------+-------+--------------------------+
| dept | category | company    | brand | item                     |
+------+----------+------------+-------+--------------------------+
|    7 |      707 | 1078778070 | 12564 | 7-707-1078778070-12564   |
|   63 |     6319 |  107654575 | 17876 | 63-6319-107654575-17876  |
|   97 |     9753 | 1022027929 |     0 | 97-9753-1022027929-0     |
|   25 |     2509 |  107996777 | 31373 | 25-2509-107996777-31373  |
|   55 |     5555 |  107684070 | 32094 | 55-5555-107684070-32094  |
|   97 |     9753 | 1021015020 |     0 | 97-9753-1021015020-0     |
|   99 |     9909 |  104538848 | 15343 | 99-9909-104538848-15343  |
|   59 |     5907 |  102900020 |  2012 | 59-5907-102900020-2012   |
|    9 |      921 |  101128414 |  9209 | 9-921-101128414-9209     |
|   73 |     7344 | 1068142161 | 20285 | 73-7344-1068142161-20285 |
+------+----------+------------+-------+--------------------------+
10 rows in set (0.00 sec)

```

We're good to go, now we can start querying our table to suit our needs.

