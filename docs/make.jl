using Documenter, TupleTools

makedocs(modules=[TupleTools],
            sitename="TupleTools.jl",
            authors = "Jutho Haegeman",
            format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
            pages = [
                "Home" => "index.md",
            ])

deploydocs(repo = "github.com/Jutho/TupleTools.jl.git")
