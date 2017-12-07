if VERSION < v"0.7.0-DEV.2005"
    const Test = Base.Test
end

using Test
using TupleTools

using Base: tail, front

n = 10

p = randperm(n)
ip = invperm(p)

t = (p...,)

i = rand(1:n)

@test @inferred(TupleTools.tail2(t)) == t[3:n]
@test @inferred(TupleTools.unsafe_tail(t)) == t[2:n]
@test @inferred(TupleTools.unsafe_front(t)) == t[1:n-1]
@test @inferred(TupleTools.unsafe_tail(())) == ()
@test @inferred(TupleTools.unsafe_front(())) == ()

@test @inferred(TupleTools.getindices(t, (1,2,3))) == t[1:3]

@test @inferred(TupleTools.deleteat(t, i)) == (deleteat!(copy(p), i)...,)
@test @inferred(TupleTools.insertat(t, i, (1,2,3))) == (vcat(p[1:i-1], [1,2,3], p[i+1:n])...,)
@test @inferred(TupleTools.vcat((1,2,3),4,(5,),(),(6,7,8))) == (1,2,3,4,5,6,7,8)

@test @inferred(TupleTools.sum(t)) == sum(t)
@test @inferred(TupleTools.prod(t)) == prod(t)

@test @inferred(TupleTools.findmin(t)) == findmin(t)
@test @inferred(TupleTools.findmax(t)) == findmax(t)
@test @inferred(TupleTools.minimum(t)) == minimum(t)
@test @inferred(TupleTools.maximum(t)) == maximum(t)
@test @inferred(TupleTools.indmin(t)) == indmin(t)
@test @inferred(TupleTools.indmax(t)) == indmax(t)

@test @inferred(TupleTools.sort(t; rev = true)) == (sort(p; rev = true)...,)
@test @inferred(TupleTools.sortperm(t)) == (sortperm(p)...,)
@test @inferred(TupleTools.invperm(t)) == (ip...,)
@test @inferred(TupleTools.permute(t, t)) == (p[p]...,)
