# The Env Module for Chapel
This repo is for [Chapel#5939](https://github.com/chapel-lang/chapel/issues/5939)

[Documentation](https//rapiz1.github.io/chapel-envVariables) is available.

## TODO
- [x] Basic functions
- [x] Tests and examples
- [x] Documentations
- [x] Implementing the module routines as locale methods to make the locale-sensitivity more explicit to users.
- [ ] Caveats about environment variables propagating from laucher node -> compute node would need to be well documented, e.g. amudprun does not override env vars if already defined on compute node.
