var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#TupleTools.jl-1",
    "page": "Home",
    "title": "TupleTools.jl",
    "category": "section",
    "text": "TupleTools contains a bunch of tools for using tuples (mostly homogeneous tuples NTuple{N}) as a collection and performing a number of operations with an inferrable result, typically also an NTuple{M} with inferable length M. ~~Type inference breaks down if some of the final or intermediate tuples exceed MAX_TUPLETYPE_LEN, meaning inference typically works up to output tuples of length 13 or 14.~~ Chosen implementations are typically faster than the corresponding functions in base for those small tuple lengths, but can be slower for larger tuples. Inference breaks down for most functions in case of inhomogeneous tuples.Note that none of the following functions are exported, since their name often collides with the equivalent functions (with different implementations) in Base. Some functions here provided just have an equivalent in Base that doesn\'t work for tuples at all, like sort. Some functions also provide reasonable defaults assuming that they are used for tuples of Ints, i.e. TupleTools.sum(()) = 0 or TupleTools.prod(()) = 1 (whereas the corresponding Base functions would error). This originates from the assumption that these methods are used to operate on tuples of e.g. sizes, indices or strides of multidimensional arrays."
},

{
    "location": "#TupleTools.StaticLength",
    "page": "Home",
    "title": "TupleTools.StaticLength",
    "category": "type",
    "text": "struct StaticLength{N} end\n\nLike Val{N}, StaticLength can be used to construct a tuple of inferrable length using ntuple(f, StaticLength(N)). Here, StaticLength(N) creates StaticLength{N}() using a Base.@pure constructor. Furthermore, one can add and subtract StaticLength objects, such that\n\nStaticLength(N₁) + StaticLength(N₂) == StaticLength(N₁+N₂)\n\nand\n\nStaticLength(N₁) - StaticLength(N₂) == StaticLength(max(0, N₁-N₂))\n\n\n\n\n\n"
},

{
    "location": "#Types-1",
    "page": "Home",
    "title": "Types",
    "category": "section",
    "text": "TupleTools.StaticLength"
},

{
    "location": "#TupleTools.tail2",
    "page": "Home",
    "title": "TupleTools.tail2",
    "category": "function",
    "text": "tail2(t::Tuple) -> ::Tuple\n\nReturns a tuple with the first two elements stripped, equivalent to tail(tail(t))\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.unsafe_tail",
    "page": "Home",
    "title": "TupleTools.unsafe_tail",
    "category": "function",
    "text": "unsafe_tail(t::Tuple) -> ::Tuple\n\nReturns a tuple with the first element stripped, similar to tail(t), but does not error on an empty tuple (instead returning an empty tuple again). An empty tuple is thus the fixed point of this function.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.unsafe_front",
    "page": "Home",
    "title": "TupleTools.unsafe_front",
    "category": "function",
    "text": "unsafe_front(t::Tuple) -> ::Tuple\n\nReturns a tuple with the last element stripped, similar to front(t), but does not error on an empty tuple (instead returning an empty tuple again). An empty tuple is thus the fixed point of this function.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.getindices",
    "page": "Home",
    "title": "TupleTools.getindices",
    "category": "function",
    "text": "getindices(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple\n\nGet the indices t[i] for i in I, again as tuple.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.deleteat",
    "page": "Home",
    "title": "TupleTools.deleteat",
    "category": "function",
    "text": "deleteat(t::Tuple, i::Int) -> ::Tuple\ndeleteat(t::Tuple, I::Tuple{Vararg{Int}}) -> ::Tuple\n\nDelete the element at location i in t; if a list I of indices is specified (again as a tuple), the elements of these different positions are deleted.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.insertat",
    "page": "Home",
    "title": "TupleTools.insertat",
    "category": "function",
    "text": "insertat(t::Tuple, i::Int, t2::Tuple) -> ::Tuple\n\nInsert the elements of tuple t2 at location i in t, i.e. the output tuple will look as (t[1:i-1]..., t2..., t[i+1:end]). Note that element t[i] is deleted. Use setindex for setting a single value at position i, or insertafter(t, i, t2) to insert the contents of t2 in between element i and i+1 in t.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.insertafter",
    "page": "Home",
    "title": "TupleTools.insertafter",
    "category": "function",
    "text": "insertafter(t::Tuple, i::Int, t2::Tuple) -> ::Tuple\n\nInsert the elements of tuple t2 after location i in t, i.e. the output tuple will look as (t[1:i]..., t2..., t[i+1:end]). Use index i=0 or just (t2..., t...) to insert t2 in front of t; also see insertat to overwrite the element at position i.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.vcat",
    "page": "Home",
    "title": "TupleTools.vcat",
    "category": "function",
    "text": "vcat(args...) -> ::Tuple\n\nLike vcat for tuples, concatenates a combination of tuple arguments and non-tuple arguments into a single tuple. Only works one level deep, i.e. tuples in tuples are not expanded.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.flatten",
    "page": "Home",
    "title": "TupleTools.flatten",
    "category": "function",
    "text": "flatten(args...) -> ::Tuple\n\nFlatten one or more tuples into a single tuple, such that every element of that tuple is itself not a tuple, otherwise it would also be expanded (i.e. flattened).\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.sum",
    "page": "Home",
    "title": "TupleTools.sum",
    "category": "function",
    "text": "sum(t::Tuple)\n\nReturns the sum of the element of a tuple, or 0 for an empty tuple.\n\n\n\n\n\n"
},

{
    "location": "#Base.cumsum",
    "page": "Home",
    "title": "Base.cumsum",
    "category": "function",
    "text": "cumsum(t::Tuple)\n\nReturns the cumulative sum of the elements of a tuple, or () for an empty tuple.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.diff",
    "page": "Home",
    "title": "TupleTools.diff",
    "category": "function",
    "text": "diff(v::Tuple) -> Tuple\n\nFinite difference operator of tuple v.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.prod",
    "page": "Home",
    "title": "TupleTools.prod",
    "category": "function",
    "text": "prod(t::Tuple)\n\nReturns the product of the elements of a tuple, or 1 for an empty tuple.\n\n\n\n\n\n"
},

{
    "location": "#Base.cumprod",
    "page": "Home",
    "title": "Base.cumprod",
    "category": "function",
    "text": "cumprod(t::Tuple)\n\nReturns the cumulative product of the elements of a tuple, or () for an empty tuple.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.minimum",
    "page": "Home",
    "title": "TupleTools.minimum",
    "category": "function",
    "text": "minimum(t::Tuple)\n\nReturns the smallest element of a tuple\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.maximum",
    "page": "Home",
    "title": "TupleTools.maximum",
    "category": "function",
    "text": "maximum(t::Tuple)\n\nReturns the largest element of a tuple\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.findmin",
    "page": "Home",
    "title": "TupleTools.findmin",
    "category": "function",
    "text": "findmin(t::Tuple)\n\nReturns the value and index of the minimum element in a tuple. If there are multiple minimal elements, then the first one will be returned.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.findmax",
    "page": "Home",
    "title": "TupleTools.findmax",
    "category": "function",
    "text": "findmax(t::Tuple)\n\nReturns the value and index of the maximum element in a tuple. If there are multiple maximal elements, then the first one will be returned.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.argmin",
    "page": "Home",
    "title": "TupleTools.argmin",
    "category": "function",
    "text": "argmin(t::Tuple)\n\nReturns the index of the minimum element in a tuple. If there are multiple minimal elements, then the first one will be returned.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.argmax",
    "page": "Home",
    "title": "TupleTools.argmax",
    "category": "function",
    "text": "argmax(t::Tuple)\n\nReturns the index of the maximum element in a tuple. If there are multiple minimal elements, then the first one will be returned.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.sort",
    "page": "Home",
    "title": "TupleTools.sort",
    "category": "function",
    "text": "sort(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple\n\nSorts the tuple t.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.sortperm",
    "page": "Home",
    "title": "TupleTools.sortperm",
    "category": "function",
    "text": "sortperm(t::Tuple; lt=isless, by=identity, rev::Bool=false) -> ::Tuple\n\nComputes a tuple that contains the permutation required to sort t.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.isperm",
    "page": "Home",
    "title": "TupleTools.isperm",
    "category": "function",
    "text": "isperm(p) -> ::Bool\n\nA non-allocating alternative to Base.isperm(p) that is much faster for small permutations.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.invperm",
    "page": "Home",
    "title": "TupleTools.invperm",
    "category": "function",
    "text": "invperm(p::NTuple{N,Int}) -> ::NTuple{N,Int}\n\nInverse permutation of a permutation p.\n\n\n\n\n\n"
},

{
    "location": "#TupleTools.permute",
    "page": "Home",
    "title": "TupleTools.permute",
    "category": "function",
    "text": "permute(t::Tuple, p) -> ::Tuple\n\nPermute the elements of tuple t according to the permutation in p.\n\n\n\n\n\n"
},

{
    "location": "#Functions-1",
    "page": "Home",
    "title": "Functions",
    "category": "section",
    "text": "TupleTools.tail2\nTupleTools.unsafe_tail\nTupleTools.unsafe_frontTupleTools.getindicesTupleTools.deleteat\nTupleTools.insertat\nTupleTools.insertafter\nTupleTools.vcat\nTupleTools.flattenTupleTools.sum\nTupleTools.cumsum\nTupleTools.diff\nTupleTools.prod\nTupleTools.cumprodTupleTools.minimum\nTupleTools.maximum\nTupleTools.findmin\nTupleTools.findmax\nTupleTools.argmin\nTupleTools.argmaxTupleTools.sort\nTupleTools.sortperm\nTupleTools.isperm\nTupleTools.invperm\nTupleTools.permute"
},

]}
