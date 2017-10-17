
<a id='TupleTools.jl-1'></a>

# TupleTools.jl


[![Build Status](https://travis-ci.org/Jutho/TupleTools.jl.svg?branch=master)](https://travis-ci.org/Jutho/TupleTools.jl) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) [![Coverage Status](https://coveralls.io/repos/Jutho/TupleTools.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Jutho/TupleTools.jl?branch=master) [![codecov.io](http://codecov.io/github/Jutho/TupleTools.jl/coverage.svg?branch=master)](http://codecov.io/github/Jutho/TupleTools.jl?branch=master)


A bunch of tools for using tuples (mostly homogeneous tuples `NTuple{N}`) as a collection and performing a number of operations with an inferrable result, typically also an `NTuple{M}` with inferrable length `M`. Type inference breaks down if some of the final or intermediate tuples exceed `MAX_TUPLETYPE_LEN`, meaning inference typically works up to output tuples of length `13` or `14`. Chosen implementations are typically faster than the corresponding functions in base for those small tuple lengths, but can be slower for larger tuples. Inference also breaks down for most functions in case of inhomogeneous tuples.


Note that none of the following functions are exported, since their name often collides with the equivalent from `Base`.


<a id='Types-1'></a>

## Types

<a id='TupleTools.StaticLength' href='#TupleTools.StaticLength'>#</a>
**`TupleTools.StaticLength`** &mdash; *Type*.



```
struct StaticLength{N} end
```

Like `Val{N}`, `StaticLength` can be used to construct a tuple of inferrable length using `ntuple(f, StaticLength(N))`. Here, `StaticLength(N)` creates `StaticLength{N}()` using a `Base.@pure` constructor. Furthermore, one can add and subtract `StaticLength` objects, such that

```
StaticLength(N₁) + StaticLength(N₂) == StaticLength(N₁+N₂)
```

and

```
StaticLength(N₁) - StaticLength(N₂) == StaticLength(max(0, N₁-N₂))
```


<a id='Functions-1'></a>

## Functions

<a id='TupleTools.tail2' href='#TupleTools.tail2'>#</a>
**`TupleTools.tail2`** &mdash; *Function*.



```
tail2(t::Tuple) -> ::Tuple
```

Returns a tuple with the first two elements stripped, equivalent to `tail(tail(t))`

<a id='TupleTools.unsafe_tail' href='#TupleTools.unsafe_tail'>#</a>
**`TupleTools.unsafe_tail`** &mdash; *Function*.



```
unsafe_tail(t::Tuple) -> ::Tuple
```

Returns a tuple with the first element stripped, similar to `tail(t)`, but does not error on an empty tuple (instead returning an empty tuple again). An empty tuple is thus the fixed point of this function.

<a id='TupleTools.unsafe_front' href='#TupleTools.unsafe_front'>#</a>
**`TupleTools.unsafe_front`** &mdash; *Function*.



```
unsafe_front(t::Tuple) -> ::Tuple
```

Returns a tuple with the last element stripped, similar to `front(t)`, but does not error on an empty tuple (instead returning an empty tuple again). An empty tuple is thus the fixed point of this function.

<a id='TupleTools.getindices' href='#TupleTools.getindices'>#</a>
**`TupleTools.getindices`** &mdash; *Function*.



```
getindices(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple
```

Get the indices `t[i] for i in I`, again as tuple.

<a id='TupleTools.deleteat' href='#TupleTools.deleteat'>#</a>
**`TupleTools.deleteat`** &mdash; *Function*.



```
deleteat(t::Tuple, i::Int) -> ::Tuple
deleteat(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple
```

Delete the element at location `i` in `t`; if a list `I` of indices is specified (again as a tuple), the elements of these different positions are deleted.

<a id='TupleTools.insertat' href='#TupleTools.insertat'>#</a>
**`TupleTools.insertat`** &mdash; *Function*.



```
insertat(t::Tuple, i::Int, t2::Tuple) -> ::Tuple
```

Insert the elements of tuple t2 at location `i` in `t`, i.e. the output tuple will look as (t[1:i-1]..., t2..., t[i+1:end]). Note that element `t[i]` is deleted. Use `setindex` for setting a single value at position `i`.

<a id='TupleTools.vcat' href='#TupleTools.vcat'>#</a>
**`TupleTools.vcat`** &mdash; *Function*.



```
vcat(args...) -> ::Tuple
```

Like `vcat` for tuples, concatenates a combination of tuple arguments and non-tuple arguments into a single tuple. Only works one level deep, i.e. tuples in tuples are not expanded.

<a id='TupleTools.sum' href='#TupleTools.sum'>#</a>
**`TupleTools.sum`** &mdash; *Function*.



```
sum(t::Tuple)
```

Returns the sum of the element of a tuple, or `0` for an empty tuple.

<a id='TupleTools.prod' href='#TupleTools.prod'>#</a>
**`TupleTools.prod`** &mdash; *Function*.



```
prod(t::Tuple)
```

Returns the product of the elements of a tuple, or `1` for an empty tuple.

<a id='TupleTools.minimum' href='#TupleTools.minimum'>#</a>
**`TupleTools.minimum`** &mdash; *Function*.



```
minimum(t::Tuple)
```

Returns the smallest element of a tuple

<a id='TupleTools.maximum' href='#TupleTools.maximum'>#</a>
**`TupleTools.maximum`** &mdash; *Function*.



```
maximum(t::Tuple)
```

Returns the largest element of a tuple

<a id='TupleTools.findmin' href='#TupleTools.findmin'>#</a>
**`TupleTools.findmin`** &mdash; *Function*.



```
findmin(t::Tuple)
```

Returns the value and index of the minimum element in a tuple. If there are multiple minimal elements, then the first one will be returned.

<a id='TupleTools.findmax' href='#TupleTools.findmax'>#</a>
**`TupleTools.findmax`** &mdash; *Function*.



```
findmax(t::Tuple)
```

Returns the value and index of the maximum element in a tuple. If there are multiple maximal elements, then the first one will be returned.

<a id='TupleTools.indmin' href='#TupleTools.indmin'>#</a>
**`TupleTools.indmin`** &mdash; *Function*.



```
indmin(t::Tuple)
```

Returns the index of the minimum element in a tuple. If there are multiple minimal elements, then the first one will be returned.

<a id='TupleTools.indmax' href='#TupleTools.indmax'>#</a>
**`TupleTools.indmax`** &mdash; *Function*.



```
indmax(t::Tuple)
```

Returns the index of the maximum element in a tuple. If there are multiple minimal elements, then the first one will be returned.

<a id='TupleTools.sort' href='#TupleTools.sort'>#</a>
**`TupleTools.sort`** &mdash; *Function*.



```
sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple
```

Sorts the tuple `t`.

<a id='TupleTools.sortperm' href='#TupleTools.sortperm'>#</a>
**`TupleTools.sortperm`** &mdash; *Function*.



```
sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple
```

Computes a tuple that contains the permutation required to sort `t`.

<a id='TupleTools.invperm' href='#TupleTools.invperm'>#</a>
**`TupleTools.invperm`** &mdash; *Function*.



```
invperm(p::NTuple{N,Int}) -> ::NTuple{N,Int}
```

Inverse permutation of a permutation `p`.

<a id='TupleTools.permute' href='#TupleTools.permute'>#</a>
**`TupleTools.permute`** &mdash; *Function*.



```
permute(t::Tuple, p) -> ::Tuple
```

Permute the elements of tuple `t` according to the permutation in `p`.
