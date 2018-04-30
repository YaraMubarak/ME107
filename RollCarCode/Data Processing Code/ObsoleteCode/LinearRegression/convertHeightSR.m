function h_real=convertHeightSR(h_struct)
    drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
    h_real=zeros(size(h_struct));
    for m=1:length(h_struct)
        h_real(m)=drop_height(h_struct(m));
    end
end