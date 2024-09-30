"""
Type stable methods for small tuples
"""
module TupleTools

# NOTE: do not remove unused imports, they are supposed to be available within the 
# TupleTools namespace so that they can be used alongside other tuple functions
using Base: tuple_type_head, tuple_type_tail, tuple_type_cons, setindex, tail, front

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
Base.@pure function Base.:+(::StaticLength{N₁}, ::StaticLength{N₂}) where {N₁,N₂}
    return StaticLength(N₁ + N₂)
end
Base.@pure function Base.:-(::StaticLength{N₁}, ::StaticLength{N₂}) where {N₁,N₂}
    return StaticLength(max(0, N₁ - N₂))
end

@inline Base.ntuple(f, ::StaticLength{N}) where {N} = ntuple(f, Val{N}())

mutable struct MutableNTuple{N,T}
    data::NTuple{N,T}
    function MutableNTuple(data::NTuple{N,T}) where {N,T}
        @assert isbitstype(T)
        return new{N,T}(data)
    end
end

Base.@propagate_inbounds function Base.getindex(t::MutableNTuple{N,T}, i::Int) where {N,T}
    @boundscheck checkbounds(Base.OneTo(N), i)
    GC.@preserve t unsafe_load(Base.unsafe_convert(Ptr{T}, pointer_from_objref(t)), i)
end

Base.@propagate_inbounds function Base.setindex!(t::MutableNTuple{N,T}, val,
                                                 i::Int) where {N,T}
    @boundscheck checkbounds(Base.OneTo(N), i)
    GC.@preserve t unsafe_store!(Base.unsafe_convert(Ptr{T}, pointer_from_objref(t)),
                                 convert(T, val), i)
    return t
end

@inline Base.Tuple(t::MutableNTuple) = t.data

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
unsafe_tail(t::Tuple{}) = t
unsafe_tail(t::Tuple) = tail(t)

"""
    unsafe_front(t::Tuple) -> ::Tuple

Returns a tuple with the last element stripped, similar to `front(t)`, but does
not error on an empty tuple (instead returning an empty tuple again). An empty tuple
is thus the fixed point of this function.
"""
unsafe_front(t::Tuple{}) = t
unsafe_front(t::Tuple) = front(t)

"""
    vcat(args...) -> ::Tuple

Like `vcat` for tuples, concatenates a combination of tuple arguments and non-tuple
arguments into a single tuple. Only works one level deep, i.e. tuples in tuples are
not expanded.
"""
vcat(t::Tuple) = t
vcat() = ()
vcat(t) = (t,)
vcat(a, args...) = (vcat(a)..., vcat(args...)...)

"""
    flatten(args...) -> ::Tuple

Flatten one or more tuples into a single tuple, such that every element of that tuple is itself not a tuple, otherwise it would also be expanded (i.e. flattened).
"""
flatten(x::Any) = (x,)
flatten(t::Tuple{}) = ()
flatten(t::Tuple) = (flatten(t[1])..., flatten(tail(t))...)
flatten(x, r...) = (flatten(x)..., flatten(r)...)

"""
    deleteat(t::Tuple, i::Int) -> ::Tuple
    deleteat(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple

Delete the element at location `i` in `t`; if a list `I` of indices is specified
(again as a tuple), the elements of these different positions are deleted.
"""
deleteat(t::Tuple, I::Tuple{Int}) = deleteat(t, I[1])
function deleteat(t::Tuple, I::Tuple{Int,Int,Vararg{Int}})
    any(i -> !(1 <= i <= length(t)), I) && throw(BoundsError(t, I))
    return _deleteat(t, sort(I; rev=true))
end
function deleteat(t::Tuple, i::Int)
    return 1 <= i <= length(t) ? _deleteat(t, i) : throw(BoundsError(t, i))
end
@inline function _deleteat(t::Tuple, i::Int)
    return i == 1 ? tail(t) : (t[1], _deleteat(tail(t), i - 1)...)
end

@inline _deleteat(t::Tuple, I::Tuple{Int}) = _deleteat(t, I[1])
@inline function _deleteat(t::Tuple, I::Tuple{Int,Int,Vararg{Int}})
    return _deleteat(_deleteat(t, I[1]), tail(I))
end # assumes sorted from big to small

"""
    insertat(t::Tuple, i::Int, t2::Tuple) -> ::Tuple

Insert the elements of tuple `t2` at location `i` in `t`, i.e. the output tuple will
look as (t[1:i-1]..., t2..., t[i+1:end]). Note that element `t[i]` is deleted. Use
`setindex` for setting a single value at position `i`, or `insertafter(t, i, t2)` to
insert the contents of `t2` in between element `i` and `i+1` in `t`.
"""
function insertat(t::Tuple, i::Int, t2::Tuple)
    return 1 <= i <= length(t) ? _insertat(t, i, t2) : throw(BoundsError(t, i))
end
@inline function _insertat(t::Tuple, i::Int, t2::Tuple)
    return i == 1 ? (t2..., tail(t)...) : (t[1], _insertat(tail(t), i - 1, t2)...)
end

"""
    insertafter(t::Tuple, i::Int, t2::Tuple) -> ::Tuple

Insert the elements of tuple `t2` after location `i` in `t`, i.e. the output tuple will
look as (t[1:i]..., t2..., t[i+1:end]). Use index `i=0` or just `(t2..., t...)` to insert
`t2` in front of `t`; also see `insertat` to overwrite the element at position `i`.
"""
function insertafter(t::Tuple, i::Int, t2::Tuple)
    return 0 <= i <= length(t) ? _insertafter(t, i, t2) : throw(BoundsError(t, i))
end
@inline function _insertafter(t::Tuple, i::Int, t2::Tuple)
    return i == 0 ? (t2..., t...) : (t[1], _insertafter(tail(t), i - 1, t2)...)
end

"""
    sum(t::Tuple)

Returns the sum of the element of a tuple, or `0` for an empty tuple.
"""
sum(t::Tuple{}) = 0
sum(t::Tuple{Any}) = t[1]
sum(t::Tuple) = t[1] + sum(tail(t))

"""
    cumsum(t::Tuple)

Returns the cumulative sum of the elements of a tuple, or `()` for an empty tuple.
"""
function cumsum(t::Tuple)
    t_1, t_tail = first(t), tail(t)
    return (t_1, cumsum((t_1 + first(t_tail), tail(t_tail)...))...)
end
cumsum(t::Tuple{Any}) = t
cumsum(t::Tuple{}) = t

"""
    prod(t::Tuple)

Returns the product of the elements of a tuple, or `1` for an empty tuple.
"""
prod(t::Tuple{}) = 1
prod(t::Tuple{Any}) = t[1]
prod(t::Tuple) = t[1] * prod(tail(t))

"""
    cumprod(t::Tuple)

Returns the cumulative product of the elements of a tuple, or `()` for an empty tuple.
"""
function cumprod(t::Tuple)
    t_1, t_tail = first(t), tail(t)
    return (t_1, cumprod((t_1 * first(t_tail), tail(t_tail)...))...)
end
cumprod(t::Tuple{Any}) = t
cumprod(t::Tuple{}) = t

"""
    minimum(t::Tuple)

Returns the smallest element of a tuple
"""
minimum(t::Tuple{Any}) = t[1]
minimum(t::Tuple) = min(t[1], minimum(tail(t)))

"""
    maximum(t::Tuple)

Returns the largest element of a tuple
"""
maximum(t::Tuple{Any}) = t[1]
maximum(t::Tuple) = max(t[1], maximum(tail(t)))

"""
    argmin(t::Tuple)

Returns the index of the minimum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
argmin(t::Tuple) = findmin(t)[2]

"""
    argmax(t::Tuple)

Returns the index of the maximum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
argmax(t::Tuple) = findmax(t)[2]

"""
    findmin(t::Tuple)

Returns the value and index of the minimum element in a tuple. If there are multiple
minimal elements, then the first one will be returned.
"""
findmin(t::Tuple) = Base.findmin(t)

"""
    findmax(t::Tuple)

Returns the value and index of the maximum element in a tuple. If there are multiple
maximal elements, then the first one will be returned.
"""
findmax(t::Tuple) = Base.findmax(t)

"""
    sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple

Sorts the tuple `t`.
"""
sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) = _sort(t, lt, by, rev)
@inline function _sort(t::Tuple, lt=isless, by=identity, rev::Bool=false)
    t1, t2 = _split(t)
    t1s = _sort(t1, lt, by, rev)
    t2s = _sort(t2, lt, by, rev)
    return _merge(t1s, t2s, lt, by, rev)
end
_sort(t::Tuple{Any}, lt=isless, by=identity, rev::Bool=false) = t
_sort(t::Tuple{}, lt=isless, by=identity, rev::Bool=false) = t

function _split(t::Tuple)
    N = length(t)
    M = N >> 1
    return ntuple(i -> t[i], M), ntuple(i -> t[i + M], N - M)
end

function _merge(t1::Tuple, t2::Tuple, lt, by, rev)
    if lt(by(first(t1)), by(first(t2))) != rev
        return (first(t1), _merge(tail(t1), t2, lt, by, rev)...)
    else
        return (first(t2), _merge(t1, tail(t2), lt, by, rev)...)
    end
end
_merge(::Tuple{}, t2::Tuple, lt, by, rev) = t2
_merge(t1::Tuple, ::Tuple{}, lt, by, rev) = t1
_merge(::Tuple{}, ::Tuple{}, lt, by, rev) = ()

"""
    sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple


Computes a tuple that contains the permutation required to sort `t`.
"""
sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) = _sortperm(t, lt, by, rev)
function _sortperm(t::Tuple, lt=isless, by=identity, rev::Bool=false)
    return map(first, _sort(ntuple(n -> (n, by(t[n])), length(t)), lt, last, rev))
end

"""
    getindices(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple

Get the indices `t[i] for i in I`, again as tuple.
"""
getindices(t::Tuple, ind::Tuple{Vararg{Int}}) = (t[ind[1]], getindices(t, tail(ind))...)
getindices(t::Tuple, ind::Tuple{}) = ()

"""
    permute(t::Tuple, p) -> ::Tuple

Permute the elements of tuple `t` according to the permutation in `p`.
"""
function permute(t::NTuple{N,Any}, p::NTuple{N,Int}) where {N}
    return isperm(p) ? _permute(t, p) : throw(ArgumentError("not a valid permutation: $p"))
end
function permute(t::NTuple{N,Any}, p) where {N}
    return isperm(p) && length(p) == N ? _permute(t, p) :
           throw(ArgumentError("not a valid permutation: $p"))
end

_permute(t::NTuple{N,Any}, p::NTuple{N,Int}) where {N} = getindices(t, p)
_permute(t::NTuple{N,Any}, p) where {N} = ntuple(n -> t[p[n]], StaticLength(N))

"""
    circshift(t::NTuple{N,Any}, i::Int) -> ::NTuple{N,Any}

Circularly shift the elements of tuple `t` by `i` positions.
"""
function circshift(t::NTuple{N,Any}, i::Int) where {N}
    return ntuple(n -> t[mod1(n - i, N)], StaticLength(N))
end

"""
    isperm(p) -> ::Bool

A non-allocating alternative to Base.isperm(p) that is much faster for small permutations.
"""
function isperm(p::NTuple{N,Integer}) where {N}
    used = MutableNTuple(ntuple(n -> false, Val(N)))
    @inbounds for i in p
        if 0 < i <= N && used[i] == false
            used[i] = true
        else
            return false
        end
    end
    return true
end
isperm(p::Tuple{}) = true
isperm(p::Tuple{Int}) = p[1] == 1
isperm(p::Tuple{Int,Int}) = ((p[1] == 1) & (p[2] == 2)) | ((p[1] == 2) & (p[2] == 1))
function isperm(p::Tuple{Int,Int,Int})
    return !(p[1] < 1 || p[1] > 3 || p[2] < 1 || p[2] > 3 || p[3] < 1 || p[3] > 3 ||
             p[1] == p[2] || p[1] == p[3] || p[2] == p[3])
end
function isperm(p::Tuple{Int,Int,Int,Int})
    return !(p[1] < 1 || p[1] > 4 || p[2] < 1 || p[2] > 4 ||
             p[3] < 1 || p[3] > 4 || p[4] < 1 || p[4] > 4 ||
             p[1] == p[2] || p[1] == p[3] || p[1] == p[4] ||
             p[2] == p[3] || p[2] == p[4] || p[3] == p[4])
end

# function isperm(p)
#     N = length(p)
#     @inbounds for i = 1:N
#         1 <= p[i] <= N || return false
#         for j = i+1:N
#             p[i] == p[j] && return false
#         end
#     end
#     return true
# end

"""
    invperm(p::NTuple{N,Int}) -> ::NTuple{N,Int}

Inverse permutation of a permutation `p`.
"""
invperm(p::Tuple{Vararg{Int}}) = _sortperm(p)

"""
    diff(v::Tuple) -> Tuple

Finite difference operator of tuple `v`.
"""
diff(v::Tuple{}) = () # similar to diff([])
diff(v::Tuple{Any}) = ()
diff(v::Tuple) = (v[2] - v[1], diff(Base.tail(v))...)

"""
    indexin(a::Tuple, b::Tuple)

Return a tuple containing the first indices in `b` of the elements of `a`. If an element
of `a` is not in `b`, then the corresponding index will be `nothing`.
"""
function indexin(a::Tuple, b::Tuple)
    return ntuple(i -> findfirst(==(a[i]), b), length(a))
end

end # module
