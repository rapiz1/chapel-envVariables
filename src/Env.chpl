/* 
  The `Env` module provides procedures and an iterator
  which can help to manage environment variables.
*/
module Env {
  require "c-environ.h";
  private use SysCTypes;
  private use Map;
  private extern var environ: c_ptr(c_ptr(c_char)); // char **environ;

  private extern proc getenv(name : c_string) : c_string;
  private extern proc setenv(name : c_string, envval : c_string, overwrite : c_int) : c_int;
  private extern proc unsetenv(name : c_string) : c_int;

  /*
    Set an environment variable to value.

    :arg varName: The name of the environment variable to set.
    :type varName: `string`

    :arg varValue: The new value of the environment variable.
    :type varValue: `string`

    :return: Returns 0 on success, -1 on error.
    :rtype: `int`
  */
  proc locale.setEnv(varName:string , varValue:string):int {
    var ret:int;
    on this {
       ret = setenv(varName.c_str(), varValue.c_str(), 1);
    }
    return ret;
  }

  /* 
    Delete an environment variable.

    :arg varName: The name of the environment variable to delete.
    :type varName: `string`

    :return: Returns 0 on success, -1 on error.
    :rtype: `int`
  */
  proc locale.unsetEnv(varName:string):int {
    var ret:int;
    on this {
      ret = unsetenv(varName.c_str());
    }
    return ret;
  }

  /*
    Get the value of the environment variable, using default if not set.

    :arg varName: The name of the environment variable to retrieve.
    :type varName: `string`

    :arg defaultValue: The value to use if the variable does not exist.
    :type defaultValue: `string`

    :return: The value of the variable
    :rtype: `string`
  */
  proc locale.getEnv(varName:string, defaultValue=''):string {
    var ret:string;
    on this {
      var ptr:c_string = getenv(varName.c_str());
      if (is_c_nil(ptr)) then
        ret = defaultValue;
      else ret = ptr:string;
    }
    return ret;
  }

  /*
    Iterator to iterate over all defined environment variables

    :yields: A string containing a record of environment variable
    */
  iter locale.envs() {
    on this {
      var i = 0;
      while (environ[i] != nil) {
        var envVarPtr = environ[i];
        var envVarStr = envVarPtr:c_string:string;
        yield envVarStr;
        i += 1;
      }
    }
  }

  /*
    A map that stores state of envs

    .. note::

      The map is populated when the module is imported and does not reflect the realtime state.
      Also, this is not locale aware. Use methods if you need to run on multiple locales.

  */
  var envs: map(string, string);
  for env in here.envs() {
    var (varName, sep, varValue) = env.partition('=');
    envs.add(varName, varValue);
  }
}
