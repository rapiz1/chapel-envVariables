use UnitTest;
use EnvVariables;

proc basicTest(test: borrowed Test) throws{
  setEnv("CHPL_ABCDEF_ENV_TEST", "ATESTA");
  test.assertEqual(getEnv("CHPL_ABCDEF_ENV_TEST"), "ATESTA");

  var found:bool = false;
  for env in envs() {
    if (env == "CHPL_ABCDEF_ENV_TEST=ATESTA") then
      found = true;
  }
  test.assertTrue(found);

  unsetEnv("CHPL_ABCDEF_ENV_TEST");
  test.assertEqual(getEnv("CHPL_ABCDEF_ENV_TEST"), "");
}

UnitTest.main();