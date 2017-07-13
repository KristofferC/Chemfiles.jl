@testset "Residue type" begin
    residue = Residue("ALA", 4)
    @test name(residue) == "ALA"
    @test id(residue) == 4

    residue = Residue("GUA")
    @test name(residue) == "GUA"
    @test id(residue) == typemax(UInt64)

    @test size(residue) == 0
    add_atom!(residue, 0);
    add_atom!(residue, 56);
    add_atom!(residue, 30);
    @test size(residue) == 3

    add_atom!(residue, 56)
    size(residue) == 3

    @test contains(residue, 56) == true

    topology = Topology()
    @test count_residues(topology) == 0
    @test_throws ChemfilesError Residue(topology, 3)
    add_residue!(topology, residue)
    residue = Residue(topology, 0)
    @test size(residue) == 3

    copy = deepcopy(residue)
    @test size(copy) == 3

    add_atom!(copy, 42)
    @test size(copy) == 4
    @test size(residue) == 3
end
