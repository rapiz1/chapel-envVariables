/* 
  EnvVariables is a module that can help with
  dealing environment variables.
*/
module EnvVariables {
  require "c-environ.h";
  private use SysCTypes;
  private extern var environ: c_ptr(c_ptr(c_char)); // char **environ;
  private use List;

  /* Set a environment variable to value */
  proc setEnv(varName:string , val:string) {
  }

  /* Get env var value, using default if not set */
  proc getEnv(varName, defaultValue='') {
    for env in Envs() {
      var nowName:string = '';
      var nowVal:string = '';
      // Only first '=' will be considered as sep
      for val in env.split('=') {
        if (nowName == '') {
          nowName = val;
        }
        else nowVal = nowVal + val;
      }
      if (nowName == varName) {
        return nowVal;
      }
    }
    return defaultValue;
  }

  /* Iterator to iterate over all defined envs */
  iter Envs() {
    var i = 0;
    while (environ[i] != nil) {
      var envvarptr = environ[i];
      var envvarstr = envvarptr:c_string:string;
      yield envvarstr;
      i += 1;
    }
  }

  /* Associative array that stores state of envs */
  //var Envs: [string] string;
}
