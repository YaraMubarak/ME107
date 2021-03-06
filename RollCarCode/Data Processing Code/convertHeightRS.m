function h_struct=convertHeightRS(h_actual)
% This function converts real height (e.g. in cm) to a drop height number
% that is used in the configuration structure.
    drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm

    [~,h_struct]=find(drop_height==h_actual);
end