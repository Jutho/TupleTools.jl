# TupleTools.jl

[![Build Status](https://travis-ci.org/Jutho/TupleTools.jl.svg?branch=master)](https://travis-ci.org/Jutho/TupleTools.jl) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) [![Coverage Status](https://coveralls.io/repos/Jutho/TupleTools.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Jutho/TupleTools.jl?branch=master) [![codecov.io](http://codecov.io/github/Jutho/TupleTools.jl/coverage.svg?branch=master)](http://codecov.io/github/Jutho/TupleTools.jl?branch=master)


A bunch of tools for using tuples (mostly homogeneous tuples `NTuple{N}`) as a collection and performing a number of operations with an inferrable result, typically also an `NTuple{M}` with inferable length `M`. Type inference breaks down if some of the final or intermediate tuples exceed `MAX_TUPLETYPE_LEN`, meaning inference typically works up to output tuples of length `13` or `14`. Chosen implementations are typically faster than the corresponding functions in base for those small tuple lengths, but can be slower for larger tuples. Inference also breaks down for most functions in case of inhomogeneous tuples. Some algorithms
also provide reasonable defaults assuming that they are used for tuples of `Int`s, i.e. `TupleTools.sum(()) = 0` or `TupleTools.prod(()) = 1` (whereas the corresponding Base functions would error). This originates from the assumption that these methods are used to
operate on tuples of e.g. sizes, indices or strides of multidimensional arrays.

Note that none of the following functions are exported, since their name often collides with the equivalent functions (with different implementations) in `Base`.

## Types

```@docs
TupleTools.StaticLength
```

## Functions

```@docs
TupleTools.tail2
TupleTools.unsafe_tail
TupleTools.unsafe_front
```

```@docs
TupleTools.getindices
```

```@docs
TupleTools.deleteat
TupleTools.insertat
TupleTools.insertafter
TupleTools.vcat
```

```@docs
TupleTools.sum
TupleTools.cumsum
TupleTools.prod
TupleTools.cumprod
```

```@docs
TupleTools.minimum
TupleTools.maximum
TupleTools.findmin
TupleTools.findmax
TupleTools.argmin
TupleTools.argmax
```

```@docs
TupleTools.sort
TupleTools.sortperm
TupleTools.isperm
TupleTools.invperm
TupleTools.permute
TupleTools.diff
```
