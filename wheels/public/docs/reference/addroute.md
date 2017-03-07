```coldfusion
// Example 1: Adds a route which will invoke the `profile` action on the `user` controller with `params.userName` set when the URL matches the `pattern` argument
addRoute(name="userProfile", pattern="user/[username]", controller="user", action="profile");

// Example 2: Category/product URLs. Note the order of precedence is such that the more specific route should be defined first so Wheels will fall back to the less-specific version if it's not found
addRoute(name="product", pattern="products/[categorySlug]/[productSlug]", controller="products", action="product");
addRoute(name="productCategory", pattern="products/[categorySlug]", controller="products", action="category");
addRoute(name="products", pattern="products", controller="products", action="index");

// Example 3: Change the `home` route. This should be listed last because it is least specific
addRoute(name="home", pattern="", controller="main", action="index");
```
