using Documenter, DocumenterMarkdown, TupleTools

makedocs(modules=[TupleTools],
            sitename="TupleTools.jl",
            authors = "Jutho Haegeman",
            format = DocumenterMarkdown.Markdown(),
            pages = [
                "Home" => "index.md",
            ])
