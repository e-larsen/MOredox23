% EL
% Original: Aug 2022
% Updated: April 2023 
%      - changed such that efficiency sampling is linear from 0-100%
%
% Function for getting metal rain ratio with varying depth and
% efficiencies.  Use for mass sampling.
%
% INPUTS:
%
%           j indexing is function of time
%           i indexing is function of mantle depth
%
%   P =         [Pa] pressure from PREM; i length array
%   z =         [m] depth from PREM; i length array
%   r_0 =       [] initial Fe3/Fe ratio at t=0
%   r_eq =      [] Fe3/Fe ratio as function of P,T; i length array
%   t =         [Myr or similar] time length for accretion; j length array
%   Accr_model = [] earth mass growth model; j length array
%   z_base =    [m] the base of the mantle during accretion; j length array
%   R_E =       [m] the radius of Earth during accretion; j length array
%   rho_Si =    [kg/m^3] density to use for mantle, e.g., 3750; value
%   Mm =        [kg] mass of mantle, present day, e.g., 4e24; value
%   dMp_temp =  [kg] the potential mass equilibrated during time interval
%                    dt; j-1 length array


function [r_m_Dt, eff_out, d_mo_out] = getRainRatio_lineff(P, z, r_0, r_eq, t, Accr_model, z_base, R_E, rho_Si, Mm, dMp_temp)
    
    r_m_Dt = zeros(1,length(t));        % Fe3+/sumFe as a function of time
    r_m_Dt(1) = r_0;
    r_m = zeros(1, length(r_eq));       % Fe3+/sumFe for a given time step as a function of depth
    r_m(1) = r_0;
    
    eff_out = zeros(1, length(t));
    d_mo_out = zeros(1, length(t));
    
    for j = 1:length(dMp_temp)          % earth evolution time

        if round(dMp_temp(j),3) == 0    % NOT AN IMPACT
            r_m_Dt(j+1) = r_m_Dt(j);    % ratio stays the same at this time step

        else                            % IMPACT, VARIANT MO DEPTH AND EFFICIENCY
            r_m(1) = r_m_Dt(j);         % initiate only initial r_m as present mantle ratio

            eff = rand(1);              %[] randomize efficiency factor for droplet equilibrium
            eff_out(j) = eff;
            d_mo = z_base(j)*rand(1);   %[m] randomize depth of MO for impact
            d_mo_out(j) = d_mo;

            [~, imp_idx] = min(abs(z-d_mo));
            P_base_imp = P(imp_idx);        % MO base during impact

            Mmo_imp = rho_Si * 4/3*pi*(R_E(j+1)^3 - (R_E(j+1)-d_mo)^3);      %mass of spherical shell MO
            dMp = min(dMp_temp(j)*eff, Mmo_imp);            %silicate mass eq'd with given efficiency, if eq'd mass > spherical shell mass, take all MO mass eq'd

            for i = 2:length(r_eq)          % droplets falling through mantle
                if P(i) <= P_base_imp
                    % ratio changes as the droplets fall through mantle layers until base of MO
                    r_m(i) = (dMp*r_eq(i) + (Mmo_imp-dMp)*r_m(i-1))/(Mmo_imp);
                else
                    r_m(i) = r_m(i-1);      %this is for the case where P_base is very small, like P(1), AND to fill the rest of r_m
                end
            end

            % final r from mixing redox'd MO with whole mantle
            r_m_Dt(j+1) = (Mmo_imp*r_m(end) + (Mm*Accr_model(j+1)-Mmo_imp)*r_m_Dt(j))/(Mm*Accr_model(j+1));     
        end
    end
    
end

