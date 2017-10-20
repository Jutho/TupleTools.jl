module TupleTools

using Base: tuple_type_head, tuple_type_tail, tuple_type_cons, tail, front, setindex
import Base: permute # TODO: this can disappear when Sparse moves out of Base

"""
    struct StaticLength{N} end

Like `Val{N}`, `StaticLength` can be used to construct a tuple of inferrable length
using `ntuple(f, StaticLength(N))`. Here, `StaticLength(N)` creates `StaticLength{N}()`
using a `Base.@pure` constructor. Furthermore, one can add and subtract `StaticLength`
objects, such that
```
StaticLength(N₁) + StaticLength(N₂) == StaticLength(N₁+N₂)
```
and
```
StaticLength(N₁) - StaticLength(N₂) == StaticLength(max(0, N₁-N₂))
```
"""
struct StaticLength{N}
end
Base.@pure StaticLength(N::Int) = StaticLength{N}()
Base.@pure Base.:+(::StaticLength{N₁}, ::StaticLength{N₂}) where {N₁,N₂} = StaticLength(N₁+N₂)
Base.@pure Base.:-(::StaticLength{N₁}, ::StaticLength{N₂}) where {N₁,N₂} = StaticLength(max(0,N₁-N₂))

if VERSION < v"0.7.0-DEV.843"
    @inline Base.ntuple(f, ::StaticLength{N}) where {N} = ntuple(f, Val{N})
else
    @inline Base.ntuple(f, ::StaticLength{N}) where {N} = ntuple(f, Val{N}())
end

@inline argtail2(a, b, c...) = c

"""
    tail2(t::Tuple) -> ::Tuple

Returns a tuple with the first two elements stripped, equivalent to `tail(tail(t))`
"""
@inline tail2(t::Tuple{Any,Any,Vararg{Any}}) = argtail2(t...)

"""
    unsafe_tail(t::Tuple) -> ::Tuple

Returns a tuple with the first element stripped, similar to `tail(t)`, but does
not error on an empty tuple (instead returning an empty tuple again). An empty tuple
is thus the fixed point of this function.
"""
@inline unsafe_tail(t::Tuple{}) = t
@inline unsafe_tail(t::Tuple) = tail(t)

"""
    unsafe_front(t::Tuple) -> ::Tuple

Returns a tuple with the last element stripped, similar to `front(t)`, but does
not error on an empty tuple (instead returning an empty tuple again). An empty tuple
is thus the fixed point of this function.
"""
@inline unsafe_front(t::Tuple{}) = t
@inline unsafe_front(t::Tuple) = front(t)

"""
    vcat(args...) -> ::Tuple

Like `vcat` for tuples, concatenates a combination of tuple arguments and non-tuple
arguments into a single tuple. Only works one level deep, i.e. tuples in tuples are
not expanded.
"""
@inline vcat(t::Tuple) = t
@inline vcat() = ()
@inline vcat(t) = (t,)
@inline vcat(a, args...) = (vcat(a)..., vcat(args...)...)

"""
    deleteat(t::Tuple, i::Int) -> ::Tuple
    deleteat(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple

Delete the element at location `i` in `t`; if a list `I` of indices is specified
(again as a tuple), the elements of these different positions are deleted.
"""
deleteat(t::Tuple, I::Tuple{Int}) = deleteat(t, I[1])
function deleteat(t::Tuple, I::Tuple{Int, Int, Vararg{Int}})
    any(i->(1 <= i <= length(t)), I) && throw(BoundsError(t, I))
    _deleteat(_deleteat(t, I[1]), ishift(tail(I), I[1], -1))
end
deleteat(t::Tuple, i::Int) = 1 <= i <= length(t) ? _deleteat(t, i) : throw(BoundsError(t, i))
@inline _deleteat(t::Tuple, i::Int) = i == 1 ? tail(t) : (t[1], _deleteat(tail(t), i-1)...)
@inline _deleteat(t::Tuple{}, i::Int) = throw(BoundsError(t, i))

@inline _deleteat(t::Tuple, I::Tuple{Int}) = _deleteat(t, I[1])
@inline _deleteat(t::Tuple, I::Tuple{Int,Int,Vararg{Int}}) = _deleteat(_deleteat(t, I[1]), tail(I)) # assumes sorted from big to small

ishift(t::Tuple{Vararg{Int}}, i::Int, s::Int) = map(n->(n < i ? n : n+s), t)

"""
    insertat(t::Tuple, i::Int, t2::Tuple) -> ::Tuple


Insert the elements of tuple t2 at location `i` in `t`, i.e. the output tuple will
look as (t[1:i-1]..., t2..., t[i+1:end]). Note that element `t[i]` is deleted. Use
`setindex` for setting a single value at position `i`.
"""
@inline insertat(t::Tuple, i::Int, t2::Tuple) = 1 <= i <= length(t) ? _insertat(t, i, t2) : throw(BoundsError(t, i))
@inline _insertat(t::Tuple, i::Int, t2::Tuple) = i == 1 ? (t2..., tail(t)...) : (t[1], _insertat(tail(t), i-1, t2)...)
@inline _insertat(t::Tuple{}, i::Int, t2::Tuple) = throw(BoundsError(t, i))

"""
    sum(t::Tuple)

Returns the sum of the element of a tuple, or `0` for an empty tuple.
"""
@inline sum(t::Tuple{}) = 0
@inline sum(t::Tuple{Any}) = t[1]
@inline sum(t::Tuple) = t[1]+sum(tail(t))

"""
    prod(t::Tuple)

Returns the product of the elements of a tuple, or `1` for an empty tuple.
"""
@inline prod(t::Tuple{}) = 1
@inline prod(t::Tuple{Any}) = t[1]
@inline prod(t::Tuple) = t[1]*prod(tail(t))

"""
    minimum(t::Tuple)

Returns the smallest element of a tuple
"""
@inline minimum(t::Tuple{Any}) = t[1]
@inline minimum(t::Tuple) = min(t[1], minimum(tail(t)))

"""
    maximum(t::Tuple)

Returns the largest element of a tuple
"""
@inline maximum(t::Tuple{Any}) = t[1]
@inline maximum(t::Tuple) = max(t[1], maximum(tail(t)))


"""
    indmin(t::Tuple)

Returns the index of the minimum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
indmin(t::Tuple) = findmin(t)[2]


"""
    indmax(t::Tuple)

Returns the index of the maximum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
indmax(t::Tuple) = findmax(t)[2]

"""
    findmin(t::Tuple)

Returns the value and index of the minimum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
findmin(t::Tuple{Any}) = (t[1], 1)
findmin(t::Tuple) = _findmin(tail(t),2,t[1],1)
@inline _findmin(t::Tuple{}, s, v, i) = (v, i)
@inline function _findmin(t::Tuple, s, v, i)
    if t[1] < v
        _findmin(tail(t), s+1, t[1], s)
    else
        _findmin(tail(t), s+1, v, i)
    end
end

"""
    findmax(t::Tuple)

Returns the value and index of the maximum element in a tuple. If there are multiple
maximal elements, then the first one will be returned.
"""
findmax(::Tuple{Any}) = 1
findmax(t::Tuple) = _findmax(tail(t),2,t[1],1)
@inline _findmax(t::Tuple{}, s, v, i) = (v, i)
@inline function _findmax(t::Tuple, s, v, i)
    if t[1] > v
        _findmax(tail(t), s+1, t[1], s)
    else
        _findmax(tail(t), s+1, v, i)
    end
end



"""
    sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple

Sorts the tuple `t`.
"""
sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) = _sort(t, lt, by, rev)
@inline function _sort(t::Tuple, lt=isless, by=identity, rev::Bool=false)
    i = 1
    if rev
        for k = 2:length(t)
            if lt(by(t[i]), by(t[k]))
                i = k
            end
        end
    else
        for k = 2:length(t)
            if lt(by(t[k]), by(t[i]))
                i = k
            end
        end
    end
    return (t[i], _sort(_deleteat(t, i), lt, by, rev)...)
end
@inline _sort(t::Tuple{Any}, lt=isless, by=identity, rev::Bool=false) = t

"""
    sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple


Computes a tuple that contains the permutation required to sort `t`.
"""
sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) = _sortperm(t, lt, by, rev)
@inline function _sortperm(t::Tuple, lt=isless, by=identity, rev::Bool=false)
    i::Int = 1
    if rev
        for k = 2:length(t)
            if lt(by(t[i]), by(t[k]))
                i = k
            end
        end
    else
        for k = 2:length(t)
            if lt(by(t[k]), by(t[i]))
                i = k
            end
        end
    end
    r = _sortperm(_deleteat(t, i), lt, by, rev)
    return (i, ishift(r, i, +1)...)
end
@inline _sortperm(t::Tuple{Any}, lt=isless, by=identity, rev::Bool=false) = (1,)

"""
    getindices(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple

Get the indices `t[i] for i in I`, again as tuple.
"""
@inline getindices(t::Tuple, ind::Tuple{Vararg{Int}}) = (t[ind[1]], getindices(t, tail(ind))...)
@inline getindices(t::Tuple, ind::Tuple{}) = ()

"""
    permute(t::Tuple, p) -> ::Tuple

Permute the elements of tuple `t` according to the permutation in `p`.
"""
@inline permute(t::NTuple{N}, p::NTuple{N,Int}) where {N} = isperm(p) ? getindices(t, p) : throw(ArgumentError("not a valid permutation: $p"))
@inline permute(t::NTuple{N}, p) where {N} = isperm(p) && length(p) == N ? ntuple(n->t[p[n]], StaticLength(N)) : throw(ArgumentError("not a valid permutation: $p"))

"""
    invperm(p::NTuple{N,Int}) -> ::NTuple{N,Int}

Inverse permutation of a permutation `p`.
"""
invperm(p::Tuple{Vararg{Int}}) = sortperm(p)

end # module
