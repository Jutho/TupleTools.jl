module TupleTools

using Base: tuple_type_head, tuple_type_tail, tuple_type_cons, tail, front, setindex

# don't export anything, import whatever you need

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

if VERSION >= v"0.7-" # to fix type instability in (f)indmin / (f)indmax
    Base.Pair(p::Tuple{Any,Any}) = p[1] => p[2]
    Base.pairs(collection) = Base.Generator(=>, zip(keys(collection), values(collection)))
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
@inline deleteat(t::Tuple, I::Tuple{Int}) = deleteat(t, I[1])
@inline deleteat(t::Tuple, I::Tuple{Int, Int, Vararg{Int}}) = deleteat(deleteat(t, I[1]), map(i->(i<I[1] ? i : i-1), tail(I)))
@inline deleteat(t::Tuple, i::Int) = 1 <= i <= length(t) ? _deleteat(t, i) : throw(BoundsError(t, i))
@inline _deleteat(t::Tuple, i::Int) = i == 1 ? tail(t) : (t[1], _deleteat(tail(t), i-1)...)
@inline _deleteat(t::Tuple{}, i::Int) = throw(BoundsError(t, i))

"""
    insertat(t::Tuple, i::Int, t2::Tuple) -> ::Tuple


Insert the elements of tuple t2 at location `i` in `t`, i.e. the output tuple will
look as (t[1:i-1]..., t2..., t[i+1:end]). Note that element `t[i]` is deleted. See
`splice` if you would also like to return `t[i]`
"""
@inline insertat(t::Tuple, i::Int, t2::Tuple) = 1 <= i <= length(t) ? _insertat(t, i, t2) : throw(BoundsError(t, i))
@inline _insertat(t::Tuple, i::Int, t2::Tuple) = i == 1 ? (t2..., tail(t)...) : (t[1], _insertat(tail(t), i-1, t2)...)
@inline _insertat(t::Tuple{}, i::Int, t2::Tuple) = throw(BoundsError(t, i))

@inline function sortperm(t::Tuple)
    i = indmin(t)
    r = map(n->(n < i ? n : n+1), sortperm(deleteat(t, i)))
    return (i, r...)
end
@inline sortperm(t::Tuple{Any}) = (1,)

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
permute(t::NTuple{N}, p::NTuple{N,Int}) where {N} = isperm(p) ? getindices(t, p) : throw(ArgumentError("not a valid permutation: $p"))
permute(t::NTuple{N}, p) where {N} = isperm(p) && length(p) == N ? ntuple(n->t[p[n]], StaticLength(N)) : throw(ArgumentError("not a valid permutation: $p"))

invperm(p::Tuple{Vararg{Int}}) = sortperm(p)

end # module
