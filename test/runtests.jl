using GlyphTools
using Base.Test

if VERSION.minor < 5
  macro testset(name, block)
    eval(block)
  end
end

@testset "GlyphTools" begin
  @testset "FreeType" begin
    include("freetype.jl")
  end
end
