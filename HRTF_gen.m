function HRIR_idx = HRTF_gen(azimuth, elevation)
% take the specified angles and generate an HRTF from the loaded HRIR
% make sure the HRTF is loaded before calling this function

HRIR_idx = intersect(find([l_eq_hrir_S.azim_v] == azimuth),find([l_eq_hrir_S.elev_v] == elevation));

end