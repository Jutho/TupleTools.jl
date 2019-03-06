using Random, Test
using TupleTools

using Base: tail, front

n = 10

p = randperm(n)
ip = invperm(p)

t = (p...,)

@test @inferred(TupleTools.argtail2(1, 2, 3, 4)) == (3, 4)
@test @inferred(TupleTools.tail2(t)) == t[3:n]
@test @inferred(TupleTools.unsafe_tail(t)) == t[2:n]
@test @inferred(TupleTools.unsafe_front(t)) == t[1:n-1]
@test @inferred(TupleTools.unsafe_tail(())) == ()
@test @inferred(TupleTools.unsafe_front(())) == ()
@test @inferred(TupleTools.vcat()) == ()
@test @inferred(TupleTools.vcat((1, 2))) == (1, 2)
@test @inferred(TupleTools.getindices(t, ())) == ()
@test @inferred(TupleTools.getindices(t, (1,2,3))) == t[1:3]

@test @inferred(TupleTools.deleteat((1, 2), (1, ))) == (2, )
for i = 1:n
    @test @inferred(TupleTools.deleteat(t, i)) == (deleteat!(copy(p), i)...,)
    @test @inferred(TupleTools.insertat(t, i, (1,2,3))) == (vcat(p[1:i-1], [1,2,3], p[i+1:n])...,)
end
@test @inferred(TupleTools.deleteat((1,2,3,4,5,6), (3,1,5))) == (2,4,6)
@test_throws BoundsError TupleTools.deleteat(t, 0)
@test_throws BoundsError TupleTools.deleteat(t, n+1)
@test_throws BoundsError TupleTools.insertat(t, 0, (1,2,3))
@test_throws BoundsError TupleTools.insertat(t, n+1, (1,2,3))
for i = 0:n
    @test @inferred(TupleTools.insertafter(t, i, (1,2,3))) == (vcat(p[1:i], [1,2,3], p[i+1:n])...,)
end
@test_throws BoundsError TupleTools.insertafter(t, -1, (1,2,3))
@test_throws BoundsError TupleTools.insertafter(t, n+1, (1,2,3))
@test @inferred(TupleTools.vcat((1,2,3),4,(5,),(),(6,7,8))) == (1,2,3,4,5,6,7,8)
@test @inferred(TupleTools.flatten((1,2,3),4,(5,),(),(6,7,8))) == (1,2,3,4,5,6,7,8)
@test @inferred(TupleTools.flatten((1,(2,3)),4,(5,),(),((6,),(7,(8,))))) == (1,2,3,4,5,6,7,8)

@test @inferred(TupleTools.sum(())) == 0
@test @inferred(TupleTools.sum((1, ))) == 1
@test @inferred(TupleTools.sum(t)) == sum(t)
@test @inferred(TupleTools.cumsum(())) == ()
@test @inferred(TupleTools.cumsum((1, ))) == (1, )
@test @inferred(TupleTools.cumsum(t)) == (cumsum(p)...,)
@test @inferred(TupleTools.prod(())) == 1
@test @inferred(TupleTools.prod((2, ))) == 2
@test @inferred(TupleTools.prod(t)) == prod(t)
@test @inferred(TupleTools.cumprod(())) == ()
@test @inferred(TupleTools.cumprod((1, ))) == (1, )
@test @inferred(TupleTools.cumprod(t)) == (cumprod(p)...,)

for a in (t, (1, ))
    @test @inferred(TupleTools.findmin(a)) == findmin(a)
    @test @inferred(TupleTools.findmax(a)) == findmax(a)
    @test @inferred(TupleTools.minimum(a)) == minimum(a)
    @test @inferred(TupleTools.maximum(a)) == maximum(a)
    @test @inferred(TupleTools.argmin(a)) == argmin(a)
    @test @inferred(TupleTools.argmax(a)) == argmax(a)
end

@test @inferred(TupleTools.sort((1, ))) == (1, )
@test @inferred(TupleTools.sort(())) == ()
@test @inferred(TupleTools.sort(t; rev = true)) == (sort(p; rev = true)...,)
@test @inferred(TupleTools.sort(t; rev = false)) == (sort(p; rev = false)..., )
@test @inferred(TupleTools.sortperm(t)) == (sortperm(p)...,)
@test @inferred(TupleTools.sortperm(t; rev=true)) == (sortperm(p; rev=true)..., )
@test @inferred(TupleTools.invperm(t)) == (ip...,)
@test @inferred(TupleTools.isperm(t)) == true
@test @inferred(TupleTools.isperm((1,2,1))) == false
@test @inferred(TupleTools.permute(t, t)) == (p[p]...,)

@test @inferred(TupleTools.vcat()) == ()
@test @inferred(TupleTools.diff(())) == ()
@test @inferred(TupleTools.diff((1, ))) == ()
@test @inferred(TupleTools.diff((1, 2, 3))) == (1, 1)
