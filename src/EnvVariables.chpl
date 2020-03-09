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
    var i = 0;
    var newVarStr = varName + '=' + val;
    while (environ[i] != nil) {
      var envVarPtr = environ[i];
      var envVarStr = envVarPtr:c_string:string;
      if (envVarStr.find('=') == 0) continue;
      if (envVarStr.split('=')[1] == varName) {
        environ[i] = newVarStr.c_str();
      }
      i += 1;
    }
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
      var envVarPtr = environ[i];
      var envVarStr = envVarPtr:c_string:string;
      yield envVarStr;
      i += 1;
    }
  }

  /* Associative array that stores state of envs */
  //var Envs: [string] string;
}
