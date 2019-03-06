# TupleTools.jl

TupleTools contains a bunch of tools for using tuples (mostly homogeneous tuples `NTuple{N}`) as a collection and performing a number of operations with an inferrable result, typically also an `NTuple{M}` with inferable length `M`. Chosen implementations are typically faster than the corresponding functions in base for those small tuple lengths, but can be slower for larger tuples. Inference breaks down for most functions in case of inhomogeneous tuples.

Note that none of the following functions are exported, since their name often collides with the equivalent functions (with different implementations) in `Base`. Some functions here provided just have an equivalent in `Base` that doesn't work for tuples at all, like `sort` or `cumsum` and `cumprod`. Some functions also provide reasonable defaults assuming that they are used for tuples of `Int`s, i.e. `TupleTools.sum(()) = 0` or `TupleTools.prod(()) = 1` (whereas the corresponding `Base` functions would error). This originates from the assumption that these methods are used to operate on tuples of e.g. sizes, indices or strides of multidimensional arrays.

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
TupleTools.flatten
```

```@docs
TupleTools.sum
TupleTools.cumsum
TupleTools.diff
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
```
