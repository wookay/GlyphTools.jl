using FreeType
using Base.Test

const ok = 0

library = Array(FT_Library, 1)
@test ok == FT_Init_FreeType(library)

aface = Array(FT_Face, 1)
@unix_only begin
  @test ok == FT_New_Face(library[1], "/Library/Fonts/Verdana.ttf", 0, aface)
end

pface = aface[1]
@test ok == FT_Select_Charmap(pface, FreeType.FT_ENCODING_UNICODE)

units_per_EM = 0x0800
@test ok == FT_Set_Char_Size(pface, 0, units_per_EM, 72, 72)

glyph_index = FT_Get_Char_Index(pface, 'A')
@test ok == FT_Load_Glyph(pface, glyph_index, FT_LOAD_DEFAULT)

face = unsafe_load(pface)

@test 0x0800 == face.units_per_EM
@test 2059 == face.ascender
@test -430 == face.descender
@test 2489 == face.height
@test FreeType.FT_BBox(-1013,-621,2963,2049) == face.bbox
@test 913 == face.num_glyphs
@test "Verdana" == bytestring(face.family_name)
@test "Regular" == bytestring(face.style_name)
@test 2 == face.num_charmaps

glyph = unsafe_load(face.glyph)
@test FreeType.FT_GLYPH_FORMAT_OUTLINE == glyph.format
@test FreeType.FT_Glyph_Metrics(1408,1536,0,1536,1408,-704,192,1984) == glyph.metrics

outline = glyph.outline
@test 2 == outline.n_contours
@test 11 == outline.n_points

@test [
 FreeType.FT_Vector(1408,0)
 FreeType.FT_Vector(1203,0)
 FreeType.FT_Vector(1067,384)
 FreeType.FT_Vector(341,384)
 FreeType.FT_Vector(205,0)
 FreeType.FT_Vector(0,0)
 FreeType.FT_Vector(566,1536)
 FreeType.FT_Vector(842,1536)
 FreeType.FT_Vector(997,576)
 FreeType.FT_Vector(704,1383)
 FreeType.FT_Vector(409,576)
] == map(n->unsafe_load(outline.points, n), 1:outline.n_points)
