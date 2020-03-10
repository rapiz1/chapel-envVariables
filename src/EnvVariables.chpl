/* 
  The `EnvVariables` module provides procedures and an iterator
  which can help to manage environment variables.
*/
module EnvVariables {
  require "c-environ.h";
  private use SysCTypes;
  private extern var environ: c_ptr(c_ptr(c_char)); // char **environ;

  private extern proc getenv(name : c_string) : c_string;
  private extern proc setenv(name : c_string, envval : c_string, overwrite : c_int) : c_int;
  private extern proc unsetenv(name : c_string) : c_int;

  /*
    Set a environment variable to value.

    :arg varName: The name of the environment variable to set.
    :type varName: `string`

    :arg varValue: The new value of the environment variable.
    :type varValue: `string`

    :return: Returns 0 on success, -1 on error.
    :rtype: `int`
  */
  proc setEnv(varName:string , varValue:string) {
    return setenv(varName.c_str(), varValue.c_str(), 1);
  }

  /* 
    Delete a environment variable.

    :arg varName: The name of the environment variable to delete.
    :type varName: `string`

    :return: Returns 0 on success, -1 on error.
    :rtype: `int`
  */
  proc unsetEnv(varName:string) {
    return unsetenv(varName.c_str());
  }

  /*
    Get env var value, using default if not set.

    :arg varName: The name of the environment variable to retrieve.
    :type varName: `string`

    :arg defaultValue: The value to use if the variable does not exist.
    :type defaultValue: `string`

    :return: The value of the variable
    :rtype: `string`
  */
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
