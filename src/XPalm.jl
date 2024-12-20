module XPalm

import MultiScaleTreeGraph: NodeMTG, index, symbol#, addchild!, get_root
import PlantSimEngine

# Palm structure:
include("plant/mtg/structs.jl")

include("age_modulation/age_modulation_linear.jl")
include("age_modulation/age_modulation_logistic.jl")

# Load all models from the Models module:
include("XPalmModels.jl")
using .Models

include("model_definition.jl")

include("run.jl")
include("notebook.jl")

export xpalm
end