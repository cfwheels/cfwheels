component extends="wheels.tests.Test" {

  function test_pk_calculated_property_selecting_pk() {
    loc.shop = model("Shop").findOne(select="shopid", where="id = 'shop1'");
    loc.actual = loc.shop.key();
    assert("Len(loc.actual) gt 0");
  }

  function test_pk_calculated_property_selecting_alias() {
    loc.shop = model("Shop").findOne(select="id", where="id = 'shop1'");
    loc.actual = loc.shop.key();
    debug("loc.shop.properties()", false);
    // TODO: fix this failing test. Issue #631
    // assert("Len(loc.actual) gt 0", "loc.actual");
  }

}
