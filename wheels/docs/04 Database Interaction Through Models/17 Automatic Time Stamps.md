# Automatic Time Stamps

*Let Wheels handle time stamping of records.*

When working with database tables, it is very common to have a column that holds the time that the 
record was added or last modified. If you have an e-commerce website with an `orders` table, you want to 
store the date and time the order was made; if you run a blog, you want to know when someone left a 
comment; and so on.

As with anything that is a common task performed by many developers, it makes a good candidate for 
abstracting to the framework level. So that's what we did.

## Columns Used for Timestamps

If you have either of the following columns in your database table, Wheels will see them and treat them 
a little differently than others.

### `createdat`

Wheels will use a `createdat` column automatically to store the current date and time when an `INSERT` 
operation is made (which could happen through a `save()` or `create()` operation, for example).

### `updatedat`

If Wheels sees an `updatedat` column, it will use it to store the current date and time automatically 
when an `UPDATE` operation is made (which could happen through a `save()` or `update()` operation, for 
example).

`updatedat` will also be populated automatically on creates as well.

## Data Type of Columns

If you add any of these columns to your table, make sure they can accept date/time values (like 
`DATETIME` or `TIMESTAMP`) and that they can be set to `NULL`.