/* 
  EnvVariables is a module that can help with
  dealing environment variables.
*/
module EnvVariables {
  require "c-environ.h";
  private use SysCTypes;
  private extern var environ: c_ptr(c_ptr(c_char)); // char **environ;
  private use List;

  private extern proc getenv(name : c_string) : c_string;
  private extern proc setenv(name : c_string, envval : c_string, overwrite : c_int) : c_int;

  /* Set a environment variable to value */
  proc setEnv(varName:string , val:string) {
    setenv(varName.c_str(), val.c_str(), 1);
  }

  /* Get env var value, using default if not set */
  proc getEnv(varName:string, defaultValue='') {
    var ptr:c_string = getenv(varName.c_str());
    if (is_c_nil(ptr)) then
      return defaultValue;
    else return ptr:string;
  }

  /* Iterator to iterate over all defined envs */
  iter Envs() {
    var i = 0;
    while (environ[i] != nil) {
      var envVarPtr = environ[i];
      var envVarStr = envVarPtr:c_string:string;
      yield envVarStr;
      i += 1;
    }
  }

  /* Associative array that stores state of envs */
  //var Envs: [string] string;
}
