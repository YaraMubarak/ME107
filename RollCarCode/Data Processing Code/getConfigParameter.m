function config_parameter=getConfigParameter(config)
% This function creates a config parameter struct, given a configuration
% struct.  A config parameter struct is simply a structure that contains
% the mass, radius of gyration, and drop height number of a configuration.

config_parameter.m=config.m;
config_parameter.r=config.r;
config_parameter.h=config.h;
end