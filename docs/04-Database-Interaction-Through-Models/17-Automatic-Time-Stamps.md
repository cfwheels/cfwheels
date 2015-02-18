# Automatic Time Stamps

## Let Wheels handle time stamping of records.

When working with database tables, it is very common to have a column
that holds the time that the record was added or last modified. If you
have an e-commerce website with an orders table, you want to store the
date and time the order was made; if you run a blog, you want to know
when someone left a comment; and so on.

As with anything that is a common task performed by many developers, it
makes a good candidate for abstracting to the framework level. So that's
what we did.

## Columns Used for Timestamps

If you have either of the following columns in your database table,
Wheels will see them and treat them a little differently than others.

### `createdAt`

Wheels will use a `createdAt` column automatically to store the current
date and time when an `INSERT` operation is made (which could happen
through a [`save()`](/docs/1-3/function/save) or
[`create()`](/docs/1-3/function/create) operation, for example).

### `updatedAt`

If Wheels sees an `updatedAt` column, it will use it to store the
current date and time automatically when an `UPDATE` operation is made
(which could happen through a [`save()`](/docs/1-3/function/save) or
[`update()`](/docs/1-3/function/update) operation, for example).

## Data Type of Columns

If you add any of these columns to your table, make sure they can accept
date/time values (like `datetime` or `timestamp`, for example) and that
they can be set to `null`.
