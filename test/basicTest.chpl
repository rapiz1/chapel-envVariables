use UnitTest;
use Env;

proc basicTest(test: borrowed Test) throws{
  here.setEnv("CHPL_ABCDEF_ENV_TEST", "ATESTA");
  test.assertEqual(here.getEnv("CHPL_ABCDEF_ENV_TEST"), "ATESTA");

  var found:bool = false;
  for env in here.envs() {
    if (env == "CHPL_ABCDEF_ENV_TEST=ATESTA") then
      found = true;
  }
  test.assertTrue(found);

  here.unsetEnv("CHPL_ABCDEF_ENV_TEST");
  test.assertEqual(here.getEnv("CHPL_ABCDEF_ENV_TEST"), "");
}

UnitTest.main();