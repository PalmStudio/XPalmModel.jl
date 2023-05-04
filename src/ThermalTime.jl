"""
    ThermalTime()

Thermal time model.


# Examples
    
```julia
``` 
"""
@process "DegreeDays" verbose = false

"""
    ThermalTime(TOpt1::Float64,TOpt2::Float64,TBase::Float64,TLim::Float64)


# Arguments

- `TOpt1`: starting optimal temperature for thermal time calculation (degree Celsius)
- `TOpt2`: ending optimal temperature for thermal time calculation (degree Celsius)
- `TBase`: Tbase temperature for thermal time calculation (degree Celsius)
- `TLim`: limit temperature for thermal time calculation (degree Celsius)
"""
struct ThermalTime <: AbstractDegreeDaysModel
    TOpt1::Float64
    TOpt2::Float64
    TBase::Float64
    TLim::Float64
end


PlantSimEngine.inputs_(::ThermalTime) = (
    Tmin=-Inf, #Daily minimal temperature
    Tmax=-Inf, #Daily maximal temperature
)

PlantSimEngine.outputs_(::ThermalTime) = (
    TEff = -Inf
)

### ici message d'erreur il manque un comma ou )...
# function ThermalTime(
#     TOpt1=25
#     TOpt2 = 30
#     TBase = 15
#     TLim = 40
# )
#     ThermalTime(TOpt1, TOpt2, TBase, TLim)
# end


"""
Compute degree days

# Arguments

- `m`: ThermalTime model

# Returns

- `TEff`: daily efficient temperature for plant growth (degree C days) 
"""

function PlantSimEngine.run!(m::ThermalTime, models, status, meteo, constants, extra=nothing)

    Tmin = meteo.Tmin
    Tmax = meteo.Tmax

    if (Tmin >= Tmax)
        if (Tmin > m.TOpt1)
            status.TEff = m.TOpt1 - m.TBase
        else
            status.TEff = Tmin - m.TBase
        end
    else
        if (Tmin < m.TOpt1)
            V = ((min(m.TOpt1, Tmax) + Tmin) / 2 - m.TBase) / (m.TOpt1 - m.TBase)
        else
            V = 0
        end
        if (Tmax > m.TOpt2)
            W = (m.TLim - (Tmax + max(m.TOpt2, Tmin)) / 2) / (m.TLim - m.TOpt2)
        else
            W = 0
        end
        if (Tmax < m.TOpt1)
            S2 = 0
        else
            if (Tmax < m.TOpt2)
                S2 = Tmax - max(m.TOpt1, Tmin)
            else
                if (Tmin > m.TOpt2)
                    S2 = 0
                else
                    S2 = m.TOpt2 - max(m.TOpt1, Tmin)
                end
            end
        end
        m1 = V * (min(m.TOpt1, Tmax) - Tmin)
        m2 = W * (Tmax - max(Tmin, m.TOpt2))
        if (Tmax <= m.TBase)
            status.TEff = 0
        else
            if (Tmin >= m.TLim)
                status.TEff = 0
            else
                status.TEff = ((m1 + m2 + S2) / (Tmax - Tmin)) * (m.TOpt1 - m.TBase)
            end
            if (status.TEff < 0)
                status.TEff = 0
            end
        end
    end

end
