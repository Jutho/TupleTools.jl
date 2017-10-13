# TupleTools.jl

[![Build Status](https://travis-ci.org/jutho/TupleTools.jl.svg?branch=master)](https://travis-ci.org/jutho/TupleTools.jl)

[![Coverage Status](https://coveralls.io/repos/jutho/TupleTools.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jutho/TupleTools.jl?branch=master)

[![codecov.io](http://codecov.io/github/jutho/TupleTools.jl/coverage.svg?branch=master)](http://codecov.io/github/jutho/TupleTools.jl?branch=master)

A bunch of tools for using tuples (mostly homogeneous tuples `NTuple{N}`) as a collection
and performing a number of operations with an inferrable result, typically also an `NTuple{M}`
with inferrable length `M`. Type inference breaks down if some of the final or intermediate tuples
exceed `MAX_TUPLETYPE_LEN`, meaning inference typically works up to output tuples of
length `13` or `14`. Inference also breaks down for most methods in case of inhomogeneous tuples.

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
TupleTools.vcat
```

```@docs
TupleTools.deleteat
TupleTools.insertat
```

```@docs
TupleTools.sort
TupleTools.sortperm
```

```@docs
TupleTools.invperm
TupleTools.permute
```
