```coldfusion
// Get all the errors for the `user` object
errorInfo = user.allErrors();
```
```coldfusion
// Sample Return of Function
[
	{
  	message:'Username must not be blank',
    name:'usernameError',
    property:'username'
  },
  {
  	message:'Password must not be blank',
    name:'passwordError',
    property:'password'
  }
]
```
