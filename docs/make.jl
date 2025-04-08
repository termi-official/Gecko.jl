using Gecko
using Documenter

DocMeta.setdocmeta!(Gecko, :DocTestSetup, :(using Gecko); recursive=true)

makedocs(;
    modules=[Gecko],
    authors="termi-official <termi-official@users.noreply.github.com> and contributors",
    sitename="Gecko.jl",
    format=Documenter.HTML(;
        canonical="https://termi-official.github.io/Gecko.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/termi-official/Gecko.jl",
    devbranch="main",
)
