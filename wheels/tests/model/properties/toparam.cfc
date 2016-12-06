component extends="wheels.tests.Test" {

  // TODO: oracle does NOT like this test Issue #631
  // Exception message: The SCALE parameter to the $getType function is required but was not passed in.
  function test_toParam_produces_same_result_as_key() {
    shop = model("Shop").findOne(select="shopid", where="id = 'shop1'");
    key = shop.key();
    param = shop.toParam();
    assert("key eq param");
  }

}
