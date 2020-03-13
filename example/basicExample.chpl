use Env;

// Iterator
for (idx, env) in zip(1..,Envs()) {
  if (idx > 3) then
    break;
  writeln(env);
}

// getEnv
writeln('Here is your env: ', getEnv('PATH'));
