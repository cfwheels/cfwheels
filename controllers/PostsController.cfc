component extends="Controller" {
  function index() {
    writedump(var=blogsPath(), abort=true);
  }
}
