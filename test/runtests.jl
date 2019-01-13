using Random, Test
using TupleTools

using Base: tail, front

n = 10

p = randperm(n)
ip = invperm(p)

t = (p...,)

@test @inferred(TupleTools.tail2(t)) == t[3:n]
@test @inferred(TupleTools.unsafe_tail(t)) == t[2:n]
@test @inferred(TupleTools.unsafe_front(t)) == t[1:n-1]
@test @inferred(TupleTools.unsafe_tail(())) == ()
@test @inferred(TupleTools.unsafe_front(())) == ()

@test @inferred(TupleTools.getindices(t, (1,2,3))) == t[1:3]

for i = 1:n
    @test @inferred(TupleTools.deleteat(t, i)) == (deleteat!(copy(p), i)...,)
    @test @inferred(TupleTools.insertat(t, i, (1,2,3))) == (vcat(p[1:i-1], [1,2,3], p[i+1:n])...,)
end
@test @inferred(TupleTools.deleteat((1,2,3,4,5,6), (3,1,5))) == (2,4,6)
for i = 0:n
    @test @inferred(TupleTools.insertafter(t, i, (1,2,3))) == (vcat(p[1:i], [1,2,3], p[i+1:n])...,)
end
@test @inferred(TupleTools.vcat((1,2,3),4,(5,),(),(6,7,8))) == (1,2,3,4,5,6,7,8)

@test @inferred(TupleTools.sum(t)) == sum(t)
@test @inferred(TupleTools.cumsum(t)) == (cumsum(p)...,)
@test @inferred(TupleTools.prod(t)) == prod(t)
@test @inferred(TupleTools.cumprod(t)) == (cumprod(p)...,)

@test @inferred(TupleTools.findmin(t)) == findmin(t)
@test @inferred(TupleTools.findmax(t)) == findmax(t)
@test @inferred(TupleTools.minimum(t)) == minimum(t)
@test @inferred(TupleTools.maximum(t)) == maximum(t)
@test @inferred(TupleTools.argmin(t)) == argmin(t)
@test @inferred(TupleTools.argmax(t)) == argmax(t)

@test @inferred(TupleTools.sort(t; rev = true)) == (sort(p; rev = true)...,)
@test @inferred(TupleTools.sortperm(t)) == (sortperm(p)...,)
@test @inferred(TupleTools.invperm(t)) == (ip...,)
@test @inferred(TupleTools.isperm(t)) == true
@test @inferred(TupleTools.isperm((1,2,1))) == false
@test @inferred(TupleTools.permute(t, t)) == (p[p]...,)

@test @inferred(TupleTools.diff((1, 2, 3))) == (-1, -1)
