"""
    Palm(;
        nsteps=1,
        initiation_age=0,
        parameters=default_parameters(),
        model_list=model_mapping(parameters, nsteps)
    )

Create a new scene with one Palm plant.

# Arguments

- `nsteps`: number of time steps to run the simulation for (default: 1, should match the number of rows in the meteo data)
- `initiation_age`: date of the first phytomer initiation (default: 0)
- `parameters`: a dictionary of parameters (default: `default_parameters()`)
- `model_list`: a dictionary of models (default: `model_mapping(parameters, nsteps)`)
"""
mutable struct Palm{T}
    mtg::MultiScaleTreeGraph.Node
    initiation_age::Int
    parameters::T
end

function default_parameters()
    p = Dict(
        :scene_area => 10000 / 136.0, # scene area in m-2 
        :k => 0.5, # light extinction coefficient
        :RUE => 4.8, # Radiation use efficiency (gC MJ[PAR]-1)
        :SRL => 0.4, # Specific Root Length (m g-1)
        :lma_min => 80.0, # min leaf mass area (g m-2)
        :lma_max => 200.0, # max  leaf mass area (g m-2)
        :leaflets_biomass_contribution => 0.35,
        :seed_reserve => 100, # seed reserve (from which the plant grows)
        :nsc_max => 0.3, # Maximum non-structural carbohydrates content in the stem.
        :RL0 => 5.0, # Root length at emergence (m)
        :respiration => Dict(
            :Internode => Dict(
                :Q10 => 1.7,  # Dufrene et al. (2005)
                :Rm_base => 0.005, # Dufrene et al. (1990), Oleagineux.
                :T_ref => 25.0,
                :P_alive => 0.21, # Dufrene et al. (2005)
            ),
            :Leaf => Dict(
                :Q10 => 2.1,
                #! :Rm_base => 0.083, # Dufrene et al. (1990), Oleagineux.
                :Rm_base => 0.0083,
                :T_ref => 25.0,
                :P_alive => 0.90,
            ),
            :Female => Dict(
                :Q10 => 2.1,
                :Rm_base => 0.0022, # Kraalingen et al. 1989, AFM
                :T_ref => 25.0,
                :P_alive => 0.50,
            ),
            :Male => Dict( ## to check 
                :Q10 => 2.1,
                :Rm_base => 0.0022, # Kraalingen et al. 1989, AFM
                :T_ref => 25.0,
                :P_alive => 0.50,
            ),
            :RootSystem => Dict(
                :Q10 => 2.1,
                :Rm_base => 0.0022, # Dufrene et al. (1990), Oleagineux.
                :T_ref => 25.0,
                :P_alive => 0.80,
            ),
        ),
        :nitrogen_content => Dict(
            :Stem => 0.004,
            :Internode => 0.004,
            :Leaf => 0.025,
            :Female => 0.01,
            :Male => 0.01,
            :RootSystem => 0.008,
        ),
        :ini_root_depth => 100.0,
        :potential_area => Dict(
            :leaf_area_first_leaf => 0.02, # leaf potential area for the first leaf (m2)
            :leaf_area_mature_leaf => 12.0, # leaf potential area for a mature leaf (m2)
            :age_first_mature_leaf => 8 * 365, # age of the first mature leaf (days)
            :inflexion_index => 560.0,
            :slope => 100.0,
        ),
        :potential_dimensions => Dict(
            :age_max_height => 8 * 365,
            :age_max_radius => 8 * 365,
            :min_height => 2e-3,
            :min_radius => 2e-3,
            :max_height => 0.03,
            :max_radius => 0.30,
            :inflexion_point_height => 900.0,
            :slope_height => 150.0,
            :inflexion_point_radius => 900.0,
            :slope_radius => 150.0,
        ),
        :phyllochron => Dict(
            :age_palm_maturity => 8 * 365, # age of the palm maturity (days)
            :threshold_ftsw_stress => 0.3, # threshold of FTSW for stress, SMART-RI considers this value to be at 0.5
            :production_speed_initial => 0.0111, # initial production speed (leaf.day-1.degreeC-1)
            :production_speed_mature => 0.0074, # production speed at maturity (leaf.day-1.degreeC-1)
        ),
        :rank_leaf_pruning => 50,
        :carbon_demand => Dict(
            :leaf => Dict(
                :respiration_cost => 1.44,
            ),
            :internode => Dict(
                :stem_apparent_density => 300000.0, # g m-3
                :respiration_cost => 1.44, # g g-1
            ),
            :male => Dict(
                :respiration_cost => 1.44, # g g-1
            ),
            :female => Dict(
                :respiration_cost => 1.44, # g g-1
                :respiration_cost_oleosynthesis => 3.2, # g g-1
            ),
            :reserves => Dict(
                :cost_reserve_mobilization => 1.667
            )
        ),
        :inflo => Dict(
            :TT_flowering => 6300.0,
            :duration_sex_determination => 1350.0,
            :duration_abortion => 540.0,
            :sex_ratio_min => 0.2,
            :sex_ratio_ref => 0.6,
            :abortion_rate_max => 0.8,
            :abortion_rate_ref => 0.2,
            :random_seed => 1,
        ),
        :male => Dict(
            :duration_flowering_male => 1800.0,
            :male_max_biomass => 1200.0,
            :age_mature_male => 8.0 * 365,
            :fraction_biomass_first_male => 0.3,
        ),
        :female => Dict(
            :age_mature_female => 8.0 * 365,
            :fraction_first_female => 0.30,
            :potential_fruit_number_at_maturity => 2000,
            :potential_fruit_weight_at_maturity => 6.5, # g
            :duration_fruit_setting => 405.0,
            :duration_dev_spikelets => 675.0,
            :oil_content => 0.25,
            :TT_harvest => 12150.0,
            :fraction_period_oleosynthesis => 0.8,
            :stalk_max_biomass => 2100.0,
            :fraction_period_stalk => 0.2,
        ),
    )
    push!(p,
        :biomass_dry => Dict(
            :Stem => 0.1,
            :Internode => 2.0,
            :Leaf => 2.0,
            :RootSystem => p[:RL0] / p[:SRL]
        )
    )
    return p
end

"""
    Palm(; initiation_age=0, parameters=default_parameters())


Create a new scene with one Palm plant. The scene contains a soil, a plant, a root system, a stem, a phytomer, an internode, and a leaf.

# Arguments

- `initiation_age`: days elapsed since the first phytomer initiation (default: 0)
- `parameters`: a dictionary of parameters (default: `default_parameters()`)

# Returns

- a `Palm` object
"""
function Palm(;
    initiation_age=0,
    parameters=default_parameters(),
)

    scene = MultiScaleTreeGraph.Node(
        1,
        NodeMTG("/", "Scene", 1, 0),
        Dict{Symbol,Any}(
        # :area => 10000 / 136.0, # scene area, m2
        ),
    )

    soil = MultiScaleTreeGraph.Node(scene, NodeMTG("+", "Soil", 1, 1),)

    plant = MultiScaleTreeGraph.Node(
        scene,
        NodeMTG("+", "Plant", 1, 1),
        Dict{Symbol,Any}(
            :parameters => parameters,
        ),
    )

    roots = MultiScaleTreeGraph.Node(
        plant,
        NodeMTG("+", "RootSystem", 1, 2),
        Dict{Symbol,Any}(
            :initiation_age => initiation_age,
            :depth => parameters[:RL0], # total exploration depth m
        ),
    )

    stem = MultiScaleTreeGraph.Node(
        plant,
        NodeMTG("+", "Stem", 1, 2),
        Dict{Symbol,Any}(
            :initiation_age => initiation_age, # date of initiation / creation
        ),
    )

    phyto = MultiScaleTreeGraph.Node(stem, NodeMTG("/", "Phytomer", 1, 3),
        Dict{Symbol,Any}(
            :initiation_age => initiation_age, # date of initiation / creation
        ),
    )

    internode = MultiScaleTreeGraph.Node(phyto, NodeMTG("/", "Internode", 1, 4),
        Dict{Symbol,Any}(
            :initiation_age => initiation_age, # date of initiation / creation
        ),
    )

    leaf = MultiScaleTreeGraph.Node(internode, NodeMTG("+", "Leaf", 1, 4),
        Dict{Symbol,Any}(
            :initiation_age => initiation_age, # date of initiation / creation
        ),
    )
    return Palm(scene, initiation_age, parameters)
end

# Print the Palm structure nicely:
function Base.show(io::IO, p::Palm)
    println(io, "Scene with a palm density of $(1 / p.parameters[:scene_area] * 10000) palms ha⁻¹. \nGraph:")
    println(io, p.mtg)
end