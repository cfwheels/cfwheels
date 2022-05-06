---
description: Deleting records from your database tables.
---

# Deleting Records

Deleting records in Wheels is simple. If you have fetched an object, you can just call its [delete()](https://api.cfwheels.org/model.delete.html) method. If you don't have any callbacks specified for the class, all that will happen is that the record will be deleted from the table and `true`will be returned.

### Delete Callbacks

If you have callbacks however, this is what happens:

First, all methods registered to be run before a delete happens (these are registered using a [beforeDelete()](https://api.cfwheels.org/model.beforedelete.html) call from the `config` function) will be executed, if any exist.

If these return `true`, Wheels will proceed and delete the record from the table. If `false` is returned from the callback code, processing will return to your code without the record being deleted. (`false` is returned to you in this case.)

If the record was deleted, the [afterDelete()](https://api.cfwheels.org/model.afterdelete.html) callback code is executed, and whatever that code returns will be returned to you. (You should make all your callbacks return `true` or `false`.)

If you're unfamiliar with the concept of callbacks, you can read about them in the [Object Callbacks](https://guides.cfwheels.org/docs/object-callbacks) chapter.

### Example of Deleting a Record

Here's a simple example of fetching a record from the database and then deleting it.

```javascript
aPost = model("post").findByKey(33);
aPost.delete();
```

There are also 3 class-level delete methods available: [deleteByKey()](https://api.cfwheels.org/model.deletebykey.html), [deleteOne()](https://api.cfwheels.org/model.deleteone.html), and [deleteAll()](https://api.cfwheels.org/model.deleteall.html). These work similarly to the class level methods for updating, which you can read more about in [Updating Records](https://guides.cfwheels.org/docs/updating-records).
