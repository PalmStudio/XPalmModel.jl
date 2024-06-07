"""
    
    AbortionRate(TT_flowering, duration_abortion, abortion_rate_max=1.0, abortion_rate_ref=0.2; random_seed::Int=0)
    AbortionRate(TT_flowering, duration_abortion, abortion_rate_max, abortion_rate_ref, random_generator<:AbstractRNG)

Determines if the inflorescence will abort based on the trophic state of the plant during a given period in thermal time.

# Arguments 

- `TT_flowering`: thermal time for flowering since phytomer appearence (degree days).
- `duration_abortion`: duration used for computing abortion rate before flowering (degree days).

# Note

The abortion is determined at `TT_flowering` based on the `trophic_status` of the plant during a period of time before this date. The hypothesis is that a trophic stress can trigger more abortion in the plant.
"""
struct AbortionRate{T,R} where {T,R<:AbstractRNG} <: AbstractAbortionModel
    TT_flowering::T
    duration_abortion::T
    abortion_rate_max::T
    abortion_rate_ref::T
    random_generator::R
end

function AbortionRate(TT_flowering, duration_abortion, abortion_rate_max=1.0, abortion_rate_ref=0.2; random_seed::Int=0)
    AbortionRate(TT_flowering, duration_abortion, abortion_rate_max, abortion_rate_ref, MersenneTwister(random_seed))
end

PlantSimEngine.inputs_(::AbortionRate) = (carbon_offer_after_rm=-Inf, carbon_demand_organs=-Inf)
PlantSimEngine.outputs_(::AbortionRate) = (state="undetermined", carbon_demand_plant=-Inf, carbon_offer_plant=-Inf,)

function PlantSimEngine.run!(m::AbortionRate, models, status, meteo, constants, extra=nothing)

    status.state == "Aborted" && return # if abortion is determined, no need to compute it again

    # We only look into the period of abortion :
    if status.TT_since_init > (m.TT_flowering - m.duration_abortion)
        if status.carbon_offer_plant == -Inf
            status.carbon_offer_plant = 0.0
        end

        if status.carbon_demand_plant == -Inf
            status.carbon_demand_plant = 0.0
        end

        status.carbon_offer_plant += status.carbon_offer_after_rm
        status.carbon_demand_plant += status.carbon_demand
    end

    # Here we have to determine if there is abortion or not:
    if status.TT_since_init > m.TT_flowering
        trophic_status_abortion = status.carbon_offer_plant / status.carbon_demand_plant

        # draws a number between 0 and 1 in a uniform distribution:
        random_abort = rand(m.random_generator)

        # Probability to get abortion:
        threshold_abortion = max(
            0.0,
            min(
                m.abortion_rate_max,
                m.abortion_rate_max + trophic_status_abortion * (m.abortion_rate_ref - m.abortion_rate_max)
            )
        )

        #e.g. if threshold_abortion is 0.7 we will have more chance to abort
        if random_abort < threshold_abortion
            status.state = "Aborted"
        end
    end
end