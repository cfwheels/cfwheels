component extends="wheels.tests.Test" {

  // TODO: oracle does NOT like this test Issue #631
  // Exception message: The SCALE parameter to the $getType function is required but was not passed in.
  function _test_pk_calculated_property_selecting_pk() {
    loc.shop = model("Shop").findOne(select="shopid", where="id = 'shop1'");
    loc.actual = loc.shop.key();
    assert("Len(loc.actual) gt 0");
  }

  // TODO: fix this failing test. Issue #631
  function _test_pk_calculated_property_selecting_alias() {
    loc.shop = model("Shop").findOne(select="id", where="id = 'shop1'");
    loc.actual = loc.shop.key();
    debug("loc.shop.properties()", false);
    assert("Len(loc.actual) gt 0", "loc.actual");
  }

}
